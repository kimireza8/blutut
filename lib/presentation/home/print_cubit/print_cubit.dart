import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:image/image.dart' as img;
import 'package:qr_flutter/qr_flutter.dart';

import '../../../domain/entities/shippment_entity.dart';

part 'print_state.dart';

class PrintCubit extends Cubit<PrintState> {
  final BluetoothClassic _bluetoothClassicPlugin = BluetoothClassic();

  PrintCubit() : super(PrintInitial());

  Future<void> initBluetooth() async {
    await _bluetoothClassicPlugin.initPermissions();
    _bluetoothClassicPlugin.onDeviceStatusChanged().listen((event) {
      if (state.selectedDevice != null) {
        emit(PrintConnected(device: state.selectedDevice!));
      }
    });
  }

  Future<void> getPairedDevices() async {
    emit(PrintLoading(state));
    List<Device> devices = await _bluetoothClassicPlugin.getPairedDevices();
    emit(PrintLoaded(
      pairedDevices: devices,
      discoveredDevices: state.discoveredDevices,
      selectedDevice: state.selectedDevice,
      scanning: state.scanning,
    ));
  }

  Future<void> scanDevices() async {
    if (state.scanning) {
      await _bluetoothClassicPlugin.stopScan();
      emit(PrintLoaded(
        pairedDevices: state.pairedDevices,
        discoveredDevices: state.discoveredDevices,
        selectedDevice: state.selectedDevice,
        scanning: false,
      ));
    } else {
      emit(PrintLoaded(
        pairedDevices: state.pairedDevices,
        discoveredDevices: [],
        selectedDevice: state.selectedDevice,
        scanning: true,
      ));

      _bluetoothClassicPlugin.startScan();
      _bluetoothClassicPlugin.onDeviceDiscovered().listen((event) {
        if (!state.discoveredDevices.any((d) => d.address == event.address)) {
          emit(PrintLoaded(
            pairedDevices: state.pairedDevices,
            discoveredDevices: List.from(state.discoveredDevices)..add(event),
            selectedDevice: state.selectedDevice,
            scanning: state.scanning,
          ));
        }
      });
    }
  }

  Future<void> connectToDevice(Device device) async {
    try {
      await _bluetoothClassicPlugin.connect(
        device.address,
        '00001101-0000-1000-8000-00805F9B34FB',
      );
      emit(PrintConnected(device: device));
    } catch (e) {
      emit(PrintError('Failed to connect: $e'));
    }
  }

  Future<void> disconnectDevice() async {
    await _bluetoothClassicPlugin.disconnect();
    emit(PrintLoaded(
      pairedDevices: state.pairedDevices,
      discoveredDevices: state.discoveredDevices,
      selectedDevice: null,
      scanning: state.scanning,
    ));
  }

  Future<void> printQR(ShipmentEntity shipment) async {
    try {
      Uint8List qrCode = await _generateQrEscPos(shipment.trackingNumber);
      await _bluetoothClassicPlugin.write(qrCode);
      emit(PrintSuccess('QR Code sent to printer'));
    } catch (e) {
      emit(PrintError('Print failed: $e'));
    }
  }

  Future<Uint8List> _generateQrEscPos(String trackingNumber) async {
    CapabilityProfile profile = await CapabilityProfile.load();
    var generator = Generator(PaperSize.mm58, profile);

    List<int> bytes = [];

    bytes += generator.text(
      'Tracking Number:',
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.text(
      trackingNumber,
      styles: const PosStyles(align: PosAlign.center, bold: true),
    );

    ByteData? qrImage = await QrPainter(
      data: trackingNumber,
      version: QrVersions.auto,
    ).toImageData(200);

    img.Image? imgData = img.decodeImage(qrImage!.buffer.asUint8List());
    bytes += generator.image(imgData!);

    bytes += generator.feed(2);
    bytes += generator.cut();

    return Uint8List.fromList(bytes);
  }
}
