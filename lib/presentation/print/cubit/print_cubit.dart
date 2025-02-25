import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:bluetooth_classic/bluetooth_classic.dart';
import 'package:bluetooth_classic/models/device.dart';
import 'package:equatable/equatable.dart';

part 'print_state.dart';

class PrintCubit extends Cubit<PrintState> {
  PrintCubit._() : super(const PrintInitial());
  final BluetoothClassic _bluetoothClassicPlugin = BluetoothClassic();

  factory PrintCubit.create() => PrintCubit._();

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
    emit(
      PrintLoaded(
        pairedDevices: devices,
        discoveredDevices: state.discoveredDevices,
        selectedDevice: state.selectedDevice,
        scanning: state.scanning,
      ),
    );
  }

  Future<void> scanDevices() async {
    if (state.scanning) {
      await _bluetoothClassicPlugin.stopScan();
      emit(
        PrintLoaded(
          pairedDevices: state.pairedDevices,
          discoveredDevices: state.discoveredDevices,
          selectedDevice: state.selectedDevice,
        ),
      );
    } else {
      emit(
        PrintLoaded(
          pairedDevices: state.pairedDevices,
          selectedDevice: state.selectedDevice,
          scanning: true,
        ),
      );

      await _bluetoothClassicPlugin.startScan();
      _bluetoothClassicPlugin.onDeviceDiscovered().listen((event) {
        if (!state.discoveredDevices.any((d) => d.address == event.address)) {
          emit(
            PrintLoaded(
              pairedDevices: state.pairedDevices,
              discoveredDevices: List.from(state.discoveredDevices)..add(event),
              selectedDevice: state.selectedDevice,
              scanning: state.scanning,
            ),
          );
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
    emit(
      PrintLoaded(
        pairedDevices: state.pairedDevices,
        discoveredDevices: state.discoveredDevices,
        scanning: state.scanning,
      ),
    );
  }

  Future<void> printLabelTSPL(String trackingNumber) async {
    try {
      String tsplCommand = '''
    SIZE 30 mm, 40 mm
    GAP 2 mm, 0 mm
    DIRECTION 1
    CLS
    QRCODE 150,200,L,13,A,0,"$trackingNumber"
    TEXT 80,550,"3",0,1,1,"$trackingNumber"
    PRINT 2,1
    ''';

      await _bluetoothClassicPlugin
          .write(Uint8List.fromList(tsplCommand.codeUnits));
      emit(const PrintSuccess('TSPL QR Code sent'));
    } catch (e) {
      emit(PrintError('Print failed: $e'));
    }
  }
}
