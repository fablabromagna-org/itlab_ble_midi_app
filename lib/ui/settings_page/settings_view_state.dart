import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:itlab_midi_ble/ble/device.dart';

part 'settings_view_state.freezed.dart';

@freezed
class SettingsViewState with _$SettingsViewState {
  factory SettingsViewState({
    @Default(false) final bool isDeviceConnected,
    @Default([]) final List<DiscoveredDevice> foundDevices,
    @Default(null) final Device? connectingDevice,
    @Default(false) final bool showLocationPermissionDialog,
    @Default(false) final bool isOtaReady,
    @Default(null) final String? selectedOtaFile,
    @Default(0.0) final double uploadFilePercentage,
    @Default(FooterButton(false, null)) final FooterButton startScanButton,
    @Default(FooterButton(false, null)) final FooterButton stopScanButton,
  }) = _SettingsViewState;
}

class FooterButton {
  final Function()? onButtonPressed;
  final bool isEnabled;

  const FooterButton(this.isEnabled, this.onButtonPressed);
}
