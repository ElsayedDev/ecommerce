import 'package:bloc/bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

part 'bluetooth_controller_state.dart';

class BluetoothControllerCubit extends Cubit<BluetoothControllerState> {
  BluetoothControllerCubit() : super(const BluetoothControllerState());

  Future<void> setAddress(String address) async {
    emit(
      state.copyWith(
        address: address,
      ),
    );
    setConnection();
  }

  Future<void> setConnection() async {
    if (state.address != null) {
      final BluetoothConnection? _connection =
          await BluetoothConnection.toAddress(state.address);
      if (_connection != null) {
        emit(
          state.copyWith(
              connection: _connection,
              status: BluetoothControllerStatus.connected),
        );
      } else {
        emit(
          state.copyWith(
            status: BluetoothControllerStatus.failed,
            connection: null,
          ),
        );
      }
    }
  }
}
