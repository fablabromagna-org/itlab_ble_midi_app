import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:itlab_midi_ble/ble/ble_manager.dart';
import 'package:itlab_midi_ble/domain/board/footswitch/footswitch_configuration.dart';
import 'package:itlab_midi_ble/domain/board/footswitch/footswitch_event.dart';
import 'package:itlab_midi_ble/ui/footswitch_page/footswitch_configuration/footswitch_configuration_view_state.dart';

@injectable
class FootswitchConfigurationViewModel {
  final StreamController<FootswitchConfigurationViewState> _viewState =
      StreamController();

  FootswitchConfigurationViewModel(this._bleManager);
  Stream<FootswitchConfigurationViewState> get viewState => _viewState.stream;
  late FootswitchConfigurationViewState _localViewState =
      FootswitchConfigurationViewState();
  set __localViewState(FootswitchConfigurationViewState value) {
    _localViewState = value;
    _viewState.add(value);
  }

  final BleManager _bleManager;

  void onTapConfigurationChange(FootswitchEvent footswitchEvent) {
    __localViewState =
        (_localViewState.copyWith(tapConfiguration: footswitchEvent));
  }

  void loadFootswitchConfiguration(
      FootswitchConfiguration footswitchConfiguration) {
    __localViewState = FootswitchConfigurationViewState(
        tapConfiguration: footswitchConfiguration.tapConfiguration,
        holdConfiguration: footswitchConfiguration.holdConfiguration,
        groupIndex: footswitchConfiguration.tapConfiguration.groupIndex);
  }

  void onHoldConfigurationChange(FootswitchEvent footswitchEvent) {
    __localViewState =
        (_localViewState.copyWith(holdConfiguration: footswitchEvent));
  }

  void onGroupIndexSelected(int index) {
    __localViewState = (_localViewState.copyWith(groupIndex: index));
  }

  Future sendConfiguration(int footswitchNumber) {
    final currentViewState = _localViewState;
    final newState = currentViewState.copyWith(
        tapConfiguration: currentViewState.tapConfiguration
            .copyWith(groupIndex: currentViewState.groupIndex),
        holdConfiguration: currentViewState.holdConfiguration
            .copyWith(groupIndex: currentViewState.groupIndex));
    return _bleManager.sendFootswitchConfiguration(
        footswitchNumber,
        FootswitchConfiguration(
            newState.tapConfiguration, newState.holdConfiguration));
  }
}
