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
      await BluetoothConnection.toAddress(state.address).then((_connection) {
        emit(
          state.copyWith(
              connection: _connection,
              status: BluetoothControllerStatus.connected),
        );
      }).catchError((error) {
        emit(
          state.copyWith(
            status: BluetoothControllerStatus.failed,
            connection: null,
          ),
        );
      });
    }
  }
}
