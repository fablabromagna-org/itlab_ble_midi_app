import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:itlab_midi_ble/ble/device.dart';
import 'package:itlab_midi_ble/di/di_initializer.dart';
import 'package:itlab_midi_ble/domain/board/configuration.dart';
import 'package:itlab_midi_ble/ui/colors.dart';
import 'package:itlab_midi_ble/ui/component/toolbar/toolbar.dart';
import 'package:itlab_midi_ble/ui/home_page/connected_device/connected_device.dart';
import 'package:itlab_midi_ble/ui/home_page/home_page_view_model.dart';
import 'package:itlab_midi_ble/ui/home_page/home_page_view_state.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final HomePageViewModel _homePageViewModel = getIt<HomePageViewModel>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<HomePageViewState>(
        stream: _homePageViewModel.viewState,
        builder: (context, snapshot) {
          final viewState = snapshot.data;
          return Scaffold(
            appBar: getAppBar(
                'Home Page',
                viewState?.connectedDevice?.connectionState ==
                        DeviceConnectionState.connected
                    ? Icons.bluetooth_connected
                    : Icons.bluetooth_disabled,
                null,
                false),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 32.0, left: 24, right: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Connected device:',
                      style:
                          TextStyle(color: AppColors.textColor, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    showProperWidget(
                        viewState?.connectedDevice, viewState?.configuration),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget showProperWidget(
      Device? connectedDevice, Configuration? configuration) {
    if (connectedDevice?.connectionState != DeviceConnectionState.connected) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.bluetooth_disabled,
              color: AppColors.iconDisabled,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'You are not connected.\nGo to Settings and connect to a device',
              style: TextStyle(color: AppColors.iconDisabled, fontSize: 18),
            ),
          ],
        ),
      );
    } else {
      final device = connectedDevice!;
      return ConnectedDevice(device, configuration!);
    }
  }
}
