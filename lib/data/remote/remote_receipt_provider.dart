import 'dart:developer';
import 'package:dio/dio.dart';
import 'dart:convert';

import '../../core/services/shared_preferences_service.dart';
import '../../dependency_injections.dart';
import '../models/shipping_model.dart';

class RemoteReceiptProvider {
  final Dio _dio;

  const RemoteReceiptProvider({required Dio dio}) : _dio = dio;

  Future<List<ShipmentModel>> getOprIncomingReceipts(String cookie) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    var token = serviceLocator<SharedPreferencesService>().getCookie();
    log('Cookie: $cookie');
    log('Timestamp: $timestamp');

    try {
      final response = await _dio.post(
        "https://app.ptmakassartrans.com/index.php/oprincomingreceipt/index.mod?_dc=$timestamp",
        data: {
          'select': jsonEncode([
            "oprincomingreceipt_id",
            "oprincomingreceipt_branch__organization_name",
            "oprincomingreceipt_number",
            "oprincomingreceipt_date",
            "oprincomingreceipt_totalcollies",
            "oprincomingreceipt_colliesnum",
            "oprincomingreceipt_cargonum",
            "oprincomingreceipt_oprkindofservice__oprkindofservice_name",
            "oprincomingreceipt_oprroute__oprroute_name",
            "oprincomingreceipt_oprcustomer__oprcustomer_name",
            "oprincomingreceipt_oprcustomerrole__oprcustomerrole_name",
            "oprincomingreceipt_shippername",
            "oprincomingreceipt_consigneename",
            "oprincomingreceipt_oprincomingreceiptstatus__oprincomingreceiptstatus_name"
          ]),
          'advsearch': null,
          'prefilter': jsonEncode([
            {
              "field_name": "oprincomingreceipt_branch__organization_id",
              "field_value": null
            },
            {
              "field_name": "oprincomingreceipt_year__year_id",
              "field_value": null
            },
            {
              "field_name": "oprincomingreceipt_month__month_id",
              "field_value": null
            },
            {
              "field_name":
              "oprincomingreceipt_oprincomingreceiptstatus__oprincomingreceiptstatus_id",
              "field_value": null
            }
          ]),
          'sorter': jsonEncode([
            {"field_name": "oprincomingreceipt_date", "sort": "DESC"},
            {"field_name": "oprincomingreceipt_number", "sort": "DESC"}
          ]),
          'grouper': jsonEncode([]),
          'flyoversearch': jsonEncode([]),
          'page': '1',
          'start': '0',
          'limit': '10',
        },
        options: Options(
          headers: {
            'Cookie': "siklonsession=$token",
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      log('Response Status Code: ${response.statusCode}');
      log('Response Data: ${response.data}');
      log('Response Data Type: ${response.data.runtimeType}');
      log(serviceLocator<SharedPreferencesService>().getCookie() ?? " ");

      dynamic responseData = response.data;
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }

      if (responseData == null ||
          responseData['rows'] == null ||
          responseData['rows'] is! List) {
        throw Exception(
            'Invalid API response format: Missing or incorrect "rows" key');
      }

      final data = (responseData['rows'] as List?) ?? [];

      return data.map((json) => ShipmentModel.fromJson(json)).toList();
    } on DioException catch (e) {
      log('Dio Error: ${e.message}, ${e.response?.statusCode}, ${e.response?.data}');
      throw Exception('Failed to load data: ${e.message}');
    } catch (e) {
      log('Error: ${e.toString()}');
      throw Exception('An error occurred: ${e.toString()}');
    }
  }

}
