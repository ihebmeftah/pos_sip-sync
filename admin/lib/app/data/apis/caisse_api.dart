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

  Future<Caisse> getCaisseOfDay() {
    return HttpHelper.get(
      endpoint: '/caisse/day',
      fromJson: (data) {
        return Caisse.fromJson(data as Map<String, dynamic>);
      },
    );
  }
}
