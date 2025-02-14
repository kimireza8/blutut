import 'package:blutut_clasic/data/models/relation_model.dart';
import 'package:dio/dio.dart';

class RemoteRelationProvider {
  final Dio _dio;

  const RemoteRelationProvider({required Dio dio}) : _dio = dio;

  Future<List<RelationModel>> getOprRelations(String cookie) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    try {
      final response = await _dio.post(
        "https://app.ptmakassartrans.com/index.php/oprrelation/index.mod?_dc=$timestamp",
        data: {
          "select": [
            "oprcustomer_id",
            "oprcustomer_code",
            "oprcustomer_name",
            "oprcustomer_phone",
            "oprcustomer_oprincomingreceipt__oprincomingreceipt_number",
            "oprcustomer_oprincomingreceipt__oprincomingreceipt_date",
            "oprcustomer_address"
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
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        List<dynamic> rows = response.data['rows'] ?? [];
        return rows.map((json) => RelationModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      throw Exception('Error fetching relations: $e');
    }
  }
}
