import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:injectable/injectable.dart';
import 'package:itlab_midi_ble/ble/ble_manager.dart';
import 'package:itlab_midi_ble/ui/settings_page/settings_view_state.dart';
import 'package:permission_handler/permission_handler.dart';

@injectable
class SettingsViewModel {
  final BleManager _bleManager;

  late SettingsViewState _localViewState = SettingsViewState();
  set localViewState(SettingsViewState value) {
    _localViewState = value;
    _viewState.add(value);
  }

  final StreamController<SettingsViewState> _viewState =
      StreamController.broadcast();
  Stream<SettingsViewState> get viewState => _viewState.stream;

  SettingsViewModel(this._bleManager) {
    Future.delayed(const Duration(seconds: 1), () {
      localViewState = _localViewState.copyWith(
          startScanButton: FooterButton(true, startScan));
    });
    _bleManager.discoveredBleDevices.listen((devices) {
      localViewState = _localViewState.copyWith(
        foundDevices: devices,
      );
    });
    _bleManager.connectedDeviceStream.listen((device) {
      localViewState = _localViewState.copyWith(
          isDeviceConnected:
              device?.connectionState == DeviceConnectionState.connected,
          connectingDevice: device);
    });
  }

  void stopScan() async {
    await _bleManager.stopScan();
    localViewState = _localViewState.copyWith(
        startScanButton: FooterButton(true, startScan),
        stopScanButton: const FooterButton(false, null));
  }

  void startScan() async {
    bool goForIt = false;
    PermissionStatus permission;
    if (Platform.isAndroid) {
      permission = await Permission.locationWhenInUse.status;
      if (permission == PermissionStatus.granted) goForIt = true;
    } else if (Platform.isIOS) {
      goForIt = true;
    }
    if (goForIt) {
      //TODO replace True with permission == PermissionStatus.granted is for IOS test
      _bleManager.scanForBleDevices();
      localViewState = _localViewState.copyWith(
          startScanButton: const FooterButton(false, null),
          stopScanButton: FooterButton(true, stopScan));
    } else {
      localViewState =
          _localViewState.copyWith(showLocationPermissionDialog: true);
    }
  }

  void onPermissionSubmitted(PermissionStatus status) async {
    localViewState =
        _localViewState.copyWith(showLocationPermissionDialog: false);
    if (status == PermissionStatus.granted) {
      startScan();
    }
  }

  void disconnect() {
    _bleManager.disconnect();
  }

  void connectToDevice(DiscoveredDevice device) async {
    if (_localViewState.isDeviceConnected) {
      _bleManager.disconnect();
    }
    _bleManager.connectToDevice(device);
  }

  void selectFileToUpdate() async {
    final updateFile = (await FilePicker.platform.pickFiles(
      dialogTitle: 'Select the update file',
      type: FileType.custom,
      allowedExtensions: ['bin'],
    ))
        ?.files
        .single;

    if (updateFile != null && updateFile.path != null) {
      _bleManager.initOTA(File.fromUri(Uri.parse(updateFile.path!)));
      localViewState = _localViewState.copyWith(
          isOtaReady: true, selectedOtaFile: updateFile.name);
    } else {
      // TODO: decide what to do in case of failure, maybe show a popup?
    }
  }

  void startOTA() async {
    _bleManager.performOTA().listen((event) {
      localViewState = _localViewState.copyWith(uploadFilePercentage: event);
    }, onError: (error) {
      localViewState = _localViewState.copyWith(
        isOtaReady: false,
      );
    }, onDone: () {
      localViewState = _localViewState.copyWith(
        isOtaReady: false,
      );
    });
  }
}
