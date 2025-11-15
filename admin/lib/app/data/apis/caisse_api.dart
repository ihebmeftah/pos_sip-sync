import 'package:admin/app/data/apis/htthp_helper.dart';
import 'package:admin/app/data/model/caisse/caisse.dart';

class CaisseApi {
  Future<List<Caisse>> getCaisse() {
    return HttpHelper.get(
      endpoint: '/caisse',
      fromJson: (data) {
        return (data as List)
            .map((e) => Caisse.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<Caisse> createCaisse() {
    return HttpHelper.post(
      endpoint: '/caisse/create',
      fromJson: (data) {
        return Caisse.fromJson(data as Map<String, dynamic>);
      },
    );
  }
}
