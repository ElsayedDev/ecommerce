part of 'bluetooth_controller_cubit.dart';

enum BluetoothControllerStatus { initial, connected, failed }

class BluetoothControllerState {
  final BluetoothControllerStatus status;
  final String? address;
  final BluetoothConnection? connection;

  const BluetoothControllerState(
      {this.status = BluetoothControllerStatus.initial,
      this.address,
      this.connection});

  BluetoothControllerState copyWith({
    BluetoothControllerStatus? status,
    String? address,
    BluetoothConnection? connection,
  }) {
    return BluetoothControllerState(
      status: status ?? this.status,
      address: address ?? this.address,
      connection: connection ?? this.connection,
    );
  }
}
