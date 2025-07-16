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
}
