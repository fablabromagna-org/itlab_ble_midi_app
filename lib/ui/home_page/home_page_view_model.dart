import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:itlab_midi_ble/ble/ble_manager.dart';
import 'package:itlab_midi_ble/ui/home_page/home_page_view_state.dart';

@injectable
class HomePageViewModel {
  final BleManager _bleManager;
  late HomePageViewState _localViewState = HomePageViewState();
  set localViewState(HomePageViewState value) {
    _localViewState = value;
    _viewState.add(value);
  }

  final StreamController<HomePageViewState> _viewState =
      StreamController.broadcast();
  Stream<HomePageViewState> get viewState => _viewState.stream;

  HomePageViewModel(this._bleManager) {
    _bleManager.connectedDeviceStream.listen((device) {
      localViewState = _localViewState.copyWith(connectedDevice: device);
    });
  }
}
