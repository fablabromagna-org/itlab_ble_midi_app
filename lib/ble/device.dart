import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class Device {
  final DiscoveredDevice deviceInformation;
  final DeviceConnectionState connectionState;

  Device(this.deviceInformation, this.connectionState);
}
