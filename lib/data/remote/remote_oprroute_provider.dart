import 'package:blutut_clasic/data/models/route_model.dart';
import 'package:dio/dio.dart';

import '../../core/services/shared_preferences_service.dart';
import '../../dependency_injections.dart';

class RemoteOprRouteProvider {
  final Dio _dio;

  const RemoteOprRouteProvider({required Dio dio}) : _dio = dio;

  Future<List<RouteModel>> getOprRoutes() async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    final cookie = serviceLocator<SharedPreferencesService>().getCookie();
    try {
      final response = await _dio.post(
        'https://app.ptmakassartrans.com/index.php/oprroute/index.mod?_dc=$timestamp',
        data: {
          "select": [
            "oprroute_id",
            "oprroute_branchoffice__organization_name",
            "oprroute_oprkindofservice__oprkindofservice_name",
            "oprroute_name"
          ],
          "advsearch": null,
          "prefilter": null,
          "sorter": [],
          "grouper": [],
          "flyoversearch": [],
          "page": 1,
          "start": 0,
          "limit": 50
        },
        options: Options(
          headers: {
            'Cookie': "siklonsession=$cookie",
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        List<dynamic> rows = response.data['rows'] ?? [];
        return rows.map((json) => RouteModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      throw Exception('Error fetching routes: $e');
    }
  }

}