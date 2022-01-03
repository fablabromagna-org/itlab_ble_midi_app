import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:itlab_midi_ble/ble/device.dart';
import 'package:itlab_midi_ble/di/di_initializer.dart';
import 'package:itlab_midi_ble/ui/colors.dart';
import 'package:itlab_midi_ble/ui/component/discovered_device/discovered_device.dart';
import 'package:itlab_midi_ble/ui/component/toolbar/toolbar.dart';
import 'package:itlab_midi_ble/ui/settings_page/settings_view_model.dart';
import 'package:itlab_midi_ble/ui/settings_page/settings_view_state.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsViewModel _viewModel = getIt<SettingsViewModel>();

  @override
  initState() {
    super.initState();
    _viewModel.viewState.listen((viewState) {
      if (viewState.showLocationPermissionDialog) {
        showNoPermissionDialog();
      }
      if (viewState.connectingDevice != null) {
        showConnectingDeviceDialog(viewState.connectingDevice!);
      }
    });
  }

  Future<void> showNoPermissionDialog() async => showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) => AlertDialog(
          title: const Text('No location permission '),
          content: SingleChildScrollView(
            child: ListBody(
              children: const [
                Text('No location permission granted.'),
                Text('Location permission is required for BLE to function.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Acknowledge'),
              onPressed: () async {
                Navigator.of(context).pop();
                _viewModel.onPermissionSubmitted(
                    await Permission.locationWhenInUse.request());
              },
            ),
          ],
        ),
      );

  Future<void> showConnectingDeviceDialog(Device connectingDevice) async {
    String lottieAsset = 'assets/loading.json';
    final bool isConnected =
        connectingDevice.connectionState == DeviceConnectionState.connected;
    switch (connectingDevice.connectionState) {
      case DeviceConnectionState.connected:
        lottieAsset = 'assets/green_checkmark_animation.json';
        break;
      case DeviceConnectionState.disconnected:
        lottieAsset = 'assets/error.json';
        break;
      default:
        lottieAsset = 'assets/loading.json';
        break;
    }
    return showDialog(
        context: context,
        barrierDismissible: connectingDevice.connectionState !=
            DeviceConnectionState.connecting,
        builder: (BuildContext context) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(lottieAsset,
                        width: 78,
                        height: 78,
                        fit: BoxFit.fill,
                        repeat: !isConnected),
                    const SizedBox(height: 44),
                    if (isConnected)
                      const Text(
                        'Connected!',
                        style: TextStyle(fontSize: 18),
                      ),
                    if (!isConnected)
                      Text(
                          'Connecting to ${connectingDevice.deviceInformation.name}'),
                    const SizedBox(height: 12),
                    if (!isConnected) const Text('Please wait'),
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SettingsViewState>(
        stream: _viewModel.viewState,
        builder: (context, snapshot) {
          final viewState = snapshot.data;
          return Scaffold(
            appBar: getAppBar(
                'Settings',
                viewState?.isDeviceConnected == true
                    ? Icons.bluetooth_connected
                    : Icons.bluetooth_disabled,
                null,
                false),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 32.0, left: 24, right: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Devices found:',
                      style:
                          TextStyle(color: AppColors.textColor, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    DiscoveredDevicesList(
                      viewState?.foundDevices ?? [],
                      onItemClickListener: _viewModel.connectToDevice,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed:
                                viewState?.startScanButton.onButtonPressed,
                            child: Text(
                              'Start scan',
                              style: TextStyle(color: AppColors.textColor),
                            )),
                        const SizedBox(
                          width: 12,
                        ),
                        ElevatedButton(
                            onPressed:
                                viewState?.stopScanButton.onButtonPressed,
                            child: Text(
                              'Stop scan',
                              style: TextStyle(color: AppColors.textColor),
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    if (viewState?.isDeviceConnected == true)
                      Center(
                        child: ElevatedButton(
                            onPressed: () => _viewModel.disconnect(),
                            child: Text('Disconnect',
                                style: TextStyle(color: AppColors.textColor))),
                      )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class DiscoveredDevicesList extends StatelessWidget {
  final List<DiscoveredDevice> devices;
  final Function(DiscoveredDevice)? onItemClickListener;

  const DiscoveredDevicesList(
    this.devices, {
    Key? key,
    this.onItemClickListener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.textColor),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: ListView.builder(
            itemCount: devices.length,
            padding: const EdgeInsets.all(4.0),
            itemBuilder: (context, position) {
              return DiscoveredDeviceItem(
                devices[position].name,
                devices[position].id,
                devices[position].rssi,
                onCLickListener: () =>
                    onItemClickListener?.call(devices[position]),
              );
            }),
      ),
    );
  }
}

class UploadWidget extends StatelessWidget {
  const UploadWidget(
    this.isOtaReady,
    this.uploadFilePercentage,
    this.startOta,
    this.selectUpdateFile,
    this.selectedOtaFile, {
    Key? key,
  }) : super(key: key);

  final bool isOtaReady;
  final double uploadFilePercentage;
  final Function() startOta;
  final Function() selectUpdateFile;
  final String? selectedOtaFile;

  @override
  Widget build(BuildContext context) {
    final bool isUpdating = isOtaReady && uploadFilePercentage > 0;
    return Container(
        margin: const EdgeInsets.all(3.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue, width: 2)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          if (!isUpdating)
            Expanded(
                child: Text(
              selectedOtaFile ?? 'Select update file',
            )),
          if (isUpdating)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: LinearProgressIndicator(
                  value: uploadFilePercentage,
                  backgroundColor: Colors.white,
                  color: Colors.blue,
                ),
              ),
            ),
          ElevatedButton(
              child: Icon(
                isOtaReady ? Icons.send : Icons.folder,
                color: isUpdating ? Colors.blue : Colors.white,
              ),
              onPressed: (isOtaReady) ? startOta : selectUpdateFile),
        ]));
  }
}
