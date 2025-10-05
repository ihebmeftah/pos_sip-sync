import 'package:admin/app/data/apis/htthp_helper.dart';
import 'package:admin/app/data/model/enums/table_status.dart';
import 'package:admin/app/data/model/table/tables.dart';

class TablesApi {
  Future<List<Table>> getTables({TableStatus? status}) async {
    return await HttpHelper.get<List<Table>>(
      endpoint: '/tables',
      queryParams: {if (status != null) 'status': status.name},
      fromJson: (json) => (json as List)
          .map((e) => Table.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<List<Table>> createTabels({
    required int nbTables,
    required int seatsMax,
  }) async {
    return await HttpHelper.post<List<Table>>(
      endpoint: '/tables/',
      body: {"nbTables": nbTables, "seatsMax": seatsMax},
      fromJson: (json) => (json as List)
          .map((e) => Table.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<Table> scanTable({required String id}) async {
    return await HttpHelper.post<Table>(
      endpoint: '/tables/$id/scan',
      fromJson: (json) => Table.fromJson(json as Map<String, dynamic>),
    );
  }
}
