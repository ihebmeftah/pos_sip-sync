import 'package:admin/app/common/appbottomsheet.dart';
import 'package:admin/app/common/appemptyscreen.dart';
import 'package:admin/app/data/local/local_storage.dart';
import 'package:admin/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../../../data/model/enums/table_status.dart';
import '../../../data/model/enums/user_role.dart';
import '../../order/controllers/pass_order_controller.dart';
import '../controllers/tables_controller.dart';
import '../widgets/tableitemwidget.dart';
import '../widgets/tablestatuswidget.dart';

class TablesView extends GetView<TablesController> {
  const TablesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Get.previousRoute == Routes.PASS_ORDER
          ? AppBar(title: const Text('Tables'), centerTitle: true)
          : null,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: controller.obx(
          (_) => Column(
            spacing: 5,
            children: [
              if (LocalStorage().user?.type == UserType.admin)
                TextButton.icon(
                  onPressed: controller.generateTablePdfQrcode,
                  label: const Text('Generate Tables QR Code'),
                  icon: const Icon(Icons.qr_code),
                ),
              Row(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TableStatusWidget(
                    color: Colors.greenAccent,
                    status: "Available (${controller.availableNb})",
                  ),
                  TableStatusWidget(
                    color: Colors.brown.shade700,
                    status: "Occupied (${controller.occupiedNb})",
                  ),
                  //   TableStatusWidget(color: Colors.red, status: "Reserved (3)"),
                ],
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: GetPlatform.isWeb && !GetPlatform.isMobile
                        ? 4
                        : 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: controller.tables.length,
                  itemBuilder: (context, index) => GetBuilder<TablesController>(
                    id: controller.tables[index].id,
                    builder: (_) {
                      return TableItemWidget(
                        onTap: () {
                          final passOrderCtr = Get.find<PassOrderController>();
                          if (Get.previousRoute == Routes.PASS_ORDER) {
                            passOrderCtr.setTable(controller.tables[index]);
                            return;
                          }
                          bottomSheet(
                            onConfirm: () {
                              Get.back();
                              passOrderCtr.setTable(controller.tables[index]);
                              Get.toNamed(Routes.PASS_ORDER);
                            },
                            confirmeButtonText: "Pass Order",
                            children: [
                              Row(
                                spacing: 20,
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/svg/table.svg',
                                    width: 30,
                                    height: 30,
                                    colorFilter: ColorFilter.mode(
                                      Colors.black,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.tables[index].name,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        "Max seats ${controller.tables[index].seatsMax}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color:
                                          controller.tables[index].status ==
                                              TableStatus.occupied
                                          ? Colors.red.shade700
                                          : Colors.greenAccent.shade700,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "${controller.tables[index].status.name.capitalize}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (passOrderCtr.table ==
                                  controller.tables[index])
                                ListTile(
                                  title: Text('Unselect Table'),
                                  onTap: () => passOrderCtr.setTable(
                                    controller.tables[index],
                                  ),
                                ),

                              if (LocalStorage().building!.tableMultiOrder &&
                                  controller.tables[index].status ==
                                      TableStatus.occupied)
                                ListTile(
                                  title: Text('Consult table orders'),
                                  onTap: () => Get.toNamed(
                                    "${Routes.ORDERS_TABLES}/${controller.tables[index].id}",
                                  ),
                                ),
                              if (!LocalStorage().building!.tableMultiOrder &&
                                  controller.tables[index].status ==
                                      TableStatus.occupied)
                                ListTile(
                                  title: Text('Consult table current order'),
                                  onTap: () => Get.toNamed(
                                    "${Routes.ORDER_DETAILS}/${controller.tables[index].id}",
                                    parameters: {'from': 'tables'},
                                  ),
                                ),
                            ],
                          );
                        },
                        table: controller.tables[index],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          onEmpty: Appemptyscreen(route: Routes.TABLES),
        ),
      ),
    );
  }
}
