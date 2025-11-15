import 'dart:io';

import 'package:admin/app/data/apis/tables_api.dart';
import 'package:admin/app/data/local/local_storage.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../data/model/enums/table_status.dart';
import '../../../data/model/table/tables.dart';
import 'package:pdf/widgets.dart' as pw;

class TablesController extends GetxController with StateMixin {
  final tables = <Table>[].obs;
  int get availableNb =>
      tables.where((table) => table.status == TableStatus.available).length;
  int get occupiedNb =>
      tables.where((table) => table.status == TableStatus.occupied).length;

  @override
  void onInit() {
    getTabels();
    super.onInit();
  }

  Future getTabels() async {
    try {
      tables(
        await TablesApi().getTables(
          status:
              Get.previousRoute == Routes.PASS_ORDER &&
                  LocalStorage().building!.tableMultiOrder == false
              ? TableStatus.available
              : null,
        ),
      );
      if (tables.isEmpty) {
        change([], status: RxStatus.empty());
      } else {
        change(tables, status: RxStatus.success());
      }
    } catch (e) {
      change([], status: RxStatus.error('Failed to load tables'));
    }
  }

  void updateTable(Table table) {
    final index = tables.indexWhere((t) => t.id == table.id);
    if (index != -1) {
      tables[index] = table;
      update([table.id]);
    }
  }

  void generateTablePdfQrcode() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        build: (context) {
          return [
            pw.Center(
              child: pw.Wrap(
                alignment: pw.WrapAlignment.center,
                runSpacing: 15,
                spacing: 15,
                children: List.generate(tables.length, (index) {
                  return pw.Container(
                    width: 150,
                    height: 150,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.black, width: 2),
                      borderRadius: pw.BorderRadius.circular(10),
                    ),
                    child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.BarcodeWidget(
                          barcode: pw.Barcode.qrCode(),
                          data:
                              '${tables[index].id}@${LocalStorage().building!.id}',
                          width: 100,
                          height: 100,
                        ),
                        pw.SizedBox(height: 20),
                        pw.Text(tables[index].name.replaceAll("№", "")),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ];
        },
      ),
    );
    final pdfDoc = await pdf.save();
    final directory = await getApplicationDocumentsDirectory();
    final file = File(
      '${directory.path}/"tables"_${LocalStorage().building!.name}.pdf',
    );
    await file.writeAsBytes(pdfDoc);
    await Printing.sharePdf(
      bytes: pdfDoc,
      filename: '${tables}_${LocalStorage().building!.name}.pdf',
    );
  }
}
