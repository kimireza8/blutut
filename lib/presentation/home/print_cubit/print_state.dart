part of 'print_cubit.dart';

abstract class PrintState extends Equatable {
  final List<Device> pairedDevices;
  final List<Device> discoveredDevices;
  final Device? selectedDevice;
  final bool scanning;

  const PrintState({
    this.pairedDevices = const [],
    this.discoveredDevices = const [],
    this.selectedDevice,
    this.scanning = false,
  });

  @override
  List<Object?> get props =>
      [pairedDevices, discoveredDevices, selectedDevice, scanning];
}

class PrintInitial extends PrintState {
  const PrintInitial();
}

class PrintLoading extends PrintState {
  final PrintState previousState;
  const PrintLoading(this.previousState);

  @override
  List<Object?> get props => [previousState];
}

class PrintLoaded extends PrintState {
  const PrintLoaded({
    List<Device> pairedDevices = const [],
    List<Device> discoveredDevices = const [],
    Device? selectedDevice,
    bool scanning = false,
  }) : super(
          pairedDevices: pairedDevices,
          discoveredDevices: discoveredDevices,
          selectedDevice: selectedDevice,
          scanning: scanning,
        );

  PrintLoaded copyWith({
    List<Device>? pairedDevices,
    List<Device>? discoveredDevices,
    Device? selectedDevice,
    bool? scanning,
  }) {
    return PrintLoaded(
      pairedDevices: pairedDevices ?? this.pairedDevices,
      discoveredDevices: discoveredDevices ?? this.discoveredDevices,
      selectedDevice: selectedDevice ?? this.selectedDevice,
      scanning: scanning ?? this.scanning,
    );
  }
}

class PrintConnected extends PrintState {
  final Device device;
  const PrintConnected({required this.device}) : super(selectedDevice: device);

  @override
  List<Object?> get props => [device];
}

class PrintSuccess extends PrintState {
  final String message;
  const PrintSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class PrintError extends PrintState {
  final String error;
  const PrintError(this.error);

  @override
  List<Object?> get props => [error];
}
