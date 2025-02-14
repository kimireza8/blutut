import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  HiveService();

  late Box _shipmentDataBox;

  Future<void> init() async {
    await Hive.initFlutter();
    _shipmentDataBox = await Hive.openBox('shipment_data_box');
  }

  Box get shipmentDataBox => _shipmentDataBox;

  Future<void> setshipmentData(String key, value) async {
    await _shipmentDataBox.put(key, value);
  }

  dynamic getshipmentData(String key) => _shipmentDataBox.get(key);
}
