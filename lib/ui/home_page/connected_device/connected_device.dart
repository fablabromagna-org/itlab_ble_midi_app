import 'package:flutter/material.dart';
import 'package:itlab_midi_ble/ble/device.dart';
import 'package:itlab_midi_ble/domain/board/configuration.dart';
import 'package:itlab_midi_ble/ui/colors.dart';
import 'package:itlab_midi_ble/ui/component/discovered_device/discovered_device.dart';
import 'package:itlab_midi_ble/ui/home_page/connected_device/footswitch.dart';

class ConnectedDevice extends StatelessWidget {
  final Device _device;
  final Configuration? _configuration;
  const ConnectedDevice(
    this._device,
    this._configuration, {
    Key? key,
  }) : super(key: key);
  static const double footswitchWidth = 180;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DiscoveredDeviceItem(
          _device.deviceInformation.name,
          _device.deviceInformation.id,
          _device.deviceInformation.rssi,
        ),
        const SizedBox(height: 24),
        if (_configuration != null)
          ..._configurationInformation(_configuration!),
      ],
    );
  }

  List<Widget> _configurationInformation(Configuration _configuration) {
    return [
      Text(
        'Device configuration',
        style: TextStyle(color: AppColors.textColor, fontSize: 18),
      ),
      Text(
        'Number of footswitches: ${_configuration.numberOfFootswitches}',
        style: TextStyle(color: AppColors.textColor, fontSize: 14),
      ),
      Text(
        'Device mode: ${_configuration.mode.name}',
        style: TextStyle(color: AppColors.textColor, fontSize: 14),
      ),
      Text(
        'Firmware version: ${_configuration.version}',
        style: TextStyle(color: AppColors.textColor, fontSize: 14),
      ),
      const SizedBox(height: 24),
      Text(
        'Footswitches: ',
        style: TextStyle(color: AppColors.textColor, fontSize: 18),
      ),
      SizedBox(
        height: 286,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, position) {
            return Footswitch(_configuration.footswitches[position],
                _configuration.internalVariable, footswitchWidth);
          },
          itemCount: _configuration.numberOfFootswitches,
        ),
      )
    ];
  }
}
