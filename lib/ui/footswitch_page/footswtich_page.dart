import 'package:flutter/material.dart';
import 'package:itlab_midi_ble/di/di_initializer.dart';
import 'package:itlab_midi_ble/domain/board/configuration.dart';
import 'package:itlab_midi_ble/ui/colors.dart';
import 'package:itlab_midi_ble/ui/component/toolbar/toolbar.dart';
import 'package:itlab_midi_ble/ui/footswitch_page/fooswitch_page_view_model.dart';
import 'package:itlab_midi_ble/ui/footswitch_page/footswitch_page_view_state.dart';
import 'package:itlab_midi_ble/ui/home_page/connected_device/footswitch.dart';

class FootswitchPage extends StatelessWidget {
  final FootswitchPageViewModel _footswitchPageViewModel =
      getIt<FootswitchPageViewModel>();

  FootswitchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FootswitchPageViewState>(
        stream: _footswitchPageViewModel.viewState,
        builder: (context, snapshot) {
          final viewState = snapshot.data;
          return Scaffold(
            appBar: getAppBar(
                'Footswitches',
                viewState?.isDeviceConnected == true
                    ? Icons.bluetooth_connected
                    : Icons.bluetooth_disabled,
                null,
                false),
            body: Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: showProperWidget(
                viewState?.isDeviceConnected ?? false,
                viewState?.configuration,
                context,
              ),
            ),
          );
        });
  }

  Widget showProperWidget(bool isDeviceConnected, Configuration? configuration,
      BuildContext context) {
    if (!isDeviceConnected) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
      return ListView.builder(
        scrollDirection: Axis.vertical,
        itemBuilder: (context, position) {
          return Footswitch(
            configuration!.footswitches[position],
            configuration.internalVariable,
            MediaQuery.of(context).size.width - Footswitch.padding,
          ); // remove padding (16) to calculate precise width
        },
        itemCount: configuration!.numberOfFootswitches,
      );
    }
  }
}
