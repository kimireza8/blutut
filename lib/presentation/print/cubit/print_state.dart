part of 'print_cubit.dart';

abstract class PrintState extends Equatable {
  const PrintState({
    this.pairedDevices = const [],
    this.discoveredDevices = const [],
    this.selectedDevice,
    this.scanning = false,
  });
  final List<Device> pairedDevices;
  final List<Device> discoveredDevices;
  final Device? selectedDevice;
  final bool scanning;

  @override
  List<Object?> get props =>
      [pairedDevices, discoveredDevices, selectedDevice, scanning];
}

class PrintInitial extends PrintState {
  const PrintInitial();
}

class PrintLoading extends PrintState {
  const PrintLoading(this.previousState);
  final PrintState previousState;

  @override
  List<Object?> get props => [previousState];
}

class PrintLoaded extends PrintState {
  const PrintLoaded({
    super.pairedDevices,
    super.discoveredDevices,
    super.selectedDevice,
    super.scanning,
  });

  PrintLoaded copyWith({
    List<Device>? pairedDevices,
    List<Device>? discoveredDevices,
    Device? selectedDevice,
    bool? scanning,
  }) =>
      PrintLoaded(
        pairedDevices: pairedDevices ?? this.pairedDevices,
        discoveredDevices: discoveredDevices ?? this.discoveredDevices,
        selectedDevice: selectedDevice ?? this.selectedDevice,
        scanning: scanning ?? this.scanning,
      );
}

class PrintConnected extends PrintState {
  const PrintConnected({required this.device}) : super(selectedDevice: device);
  final Device device;

  @override
  List<Object?> get props => [device];
}

class PrintSuccess extends PrintState {
  const PrintSuccess(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class PrintError extends PrintState {
  const PrintError(this.error);
  final String error;

  @override
  List<Object?> get props => [error];
}
