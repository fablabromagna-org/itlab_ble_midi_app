import 'dart:async';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:injectable/injectable.dart';
import 'package:itlab_midi_ble/ble/ble_manager.dart';
import 'package:itlab_midi_ble/ui/footswitch_page/footswitch_page_view_state.dart';

@injectable
class FootswitchPageViewModel {
  final BleManager _bleManager;
  late FootswitchPageViewState _localViewState = FootswitchPageViewState();
  set localViewState(FootswitchPageViewState value) {
    _localViewState = value;
    _viewState.add(value);
  }

  final StreamController<FootswitchPageViewState> _viewState =
      StreamController.broadcast();
  Stream<FootswitchPageViewState> get viewState => _viewState.stream;

  FootswitchPageViewModel(this._bleManager) {
    _bleManager.connectedDeviceStream.listen((device) {
      localViewState = _localViewState.copyWith(
          isDeviceConnected:
              device?.connectionState == DeviceConnectionState.connected);
    });
    _bleManager.deviceConfiguraion.listen((event) {
      localViewState = _localViewState.copyWith(configuration: event);
    });
  }
}
