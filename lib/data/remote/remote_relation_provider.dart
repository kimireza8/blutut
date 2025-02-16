import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../data/models/relation_model.dart';

class RemoteRelationProvider {
  const RemoteRelationProvider({required this.dio});
  final Dio dio;

  Future<List<RelationModel>> getOprRelations(String cookie) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    try {
      Response<Map<String, dynamic>> response =
          await dio.post<Map<String, dynamic>>(
        'https://app.ptmakassartrans.com/index.php/oprrelation/index.mod?_dc=$timestamp',
        data: _buildRelationListRequestData(),
        options: Options(
          headers: <String, dynamic>{
            'Cookie': 'siklonsession=$cookie',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      log('Response Status Code: ${response.statusCode}');
      log('Response Data: ${response.data}');

      if (response.statusCode == 200 && response.data?['success'] == true) {
        var rows = response.data?['rows'] as List;
        return rows
            .map(
              (json) => RelationModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw Exception('Failed to fetch data');
      }
    } on DioException catch (e) {
      log('Dio Error: ${e.message}, ${e.response?.statusCode}, ${e.response?.data}');
      throw Exception('Failed to load data: ${e.message}');
    } catch (e) {
      log('Error: $e');
      throw Exception('An error occurred: $e');
    }
  }

  Map<String, dynamic> _buildRelationListRequestData() => <String, dynamic>{
        'select': jsonEncode([
          'oprcustomer_id',
          'oprcustomer_code',
          'oprcustomer_name',
          'oprcustomer_phone',
          'oprcustomer_oprincomingreceipt__oprincomingreceipt_number',
          'oprcustomer_oprincomingreceipt__oprincomingreceipt_date',
          'oprcustomer_address',
        ]),
        'advsearch': null,
        'prefilter': null,
        'sorter': jsonEncode([]),
        'grouper': jsonEncode([]),
        'flyoversearch': jsonEncode([]),
        'page': '1',
        'start': '0',
        'limit': '50',
      };
}
