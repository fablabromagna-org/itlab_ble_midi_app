// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:io';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:injectable/injectable.dart';
import 'package:itlab_midi_ble/ble/device.dart';
import 'package:itlab_midi_ble/ble/ota/ota_manager.dart';
import 'package:itlab_midi_ble/data/configuration_mapper.dart';
import 'package:itlab_midi_ble/domain/board/configuration.dart';

@singleton
@injectable
class BleManager {
  final Uuid _DEVICE_UUID = Uuid.parse('03b80e5a-ede8-4b33-a751-6ce34ec4c700');
  final Uuid _OTA_SERVICE_UUID =
      Uuid.parse('fb1e4001-54ae-4a28-9f74-dfccb248601d');
  final Uuid _OTA_CHARACTERISTIC =
      Uuid.parse('fb1e4001-54ae-4a28-9f74-dfccb248601d');
  final Uuid _MIDI_CHARACTERISTIC =
      Uuid.parse('7772e5db-3868-4112-a1a9-f2669d106bf3');
  final Uuid _CONFIGURATION_SERVICE_UUID =
      Uuid.parse('98611bc6-43c5-11ec-81d3-0242ac130003');
  final Uuid _CHARACTERISTIC_CONFIGURATION_UUID =
      Uuid.parse('ae0f58f2-43c5-11ec-81d3-0242ac130003');

  final FlutterReactiveBle _flutterReactiveBle;
  final _configurationMapper = ConfigurationMapper();

  BleManager(this._flutterReactiveBle);

  final StreamController<List<DiscoveredDevice>> _discoveredBleDevices =
      StreamController.broadcast();

  Stream<List<DiscoveredDevice>> get discoveredBleDevices =>
      _discoveredBleDevices.stream;

  late StreamSubscription<DiscoveredDevice?> _scanStream;
  final StreamController<Device?> _connectedDeviceStream =
      StreamController.broadcast();
  Stream<Device?> get connectedDeviceStream => _connectedDeviceStream.stream;

  final StreamController<Configuration?> _deviceConfiguration =
      StreamController.broadcast();
  Stream<Configuration?> get deviceConfiguraion => _deviceConfiguration.stream;

  final StreamController<List<int>> _midiDataReceived =
      StreamController.broadcast();
  Stream get midiDataReceived => _midiDataReceived.stream;

  StreamSubscription<ConnectionStateUpdate>? _connection;
  late QualifiedCharacteristic _otaTxCharacteristic;
  late QualifiedCharacteristic _midiCharacteristic;
  late QualifiedCharacteristic _configurationCharacteristic;

  late OtaManager _otaManager;
  final List<DiscoveredDevice> _discoveredDevices = [];

  void initOTA(File updateFile) {
    _otaManager = OtaManager(_flutterReactiveBle, updateFile);
  }

  Stream<double> performOTA() {
    return _otaManager.startOTA(_otaTxCharacteristic);
  }

  void scanForBleDevices() async {
    _scanStream = _flutterReactiveBle.scanForDevices(withServices: [
      _DEVICE_UUID,
      _OTA_SERVICE_UUID,
      _CONFIGURATION_SERVICE_UUID
    ]).listen((device) async {
      if (!_discoveredDevices.any((element) => element.id == device.id)) {
        _discoveredDevices.add(device);
        _discoveredBleDevices.add(_discoveredDevices);
      }
    }, onError: (Object error) {
      //TODO: what to do on error?
    });
  }

  Future stopScan() async {
    return _scanStream.cancel();
  }

  void disconnect() async {
    _connectedDeviceStream.add(null);
    _discoveredDevices.clear();
    _deviceConfiguration.add(null);
    await _connection?.cancel();
    _connection = null;
  }

  void connectToDevice(DiscoveredDevice deviceToConnect) async {
    final currentConnectionStream =
        _flutterReactiveBle.connectToAdvertisingDevice(
      id: deviceToConnect.id,
      prescanDuration: const Duration(seconds: 1),
      withServices: [_DEVICE_UUID, _OTA_CHARACTERISTIC, _MIDI_CHARACTERISTIC],
    );
    int mtu = await _flutterReactiveBle.requestMtu(
        deviceId: deviceToConnect.id, mtu: 517);
    print('** Negotiated MTU: $mtu');
    _connection = currentConnectionStream.listen((event) async {
      _connectedDeviceStream
          .add(Device(deviceToConnect, event.connectionState));
      switch (event.connectionState) {
        case DeviceConnectionState.connected:
          {
            _otaTxCharacteristic = QualifiedCharacteristic(
                serviceId: _OTA_SERVICE_UUID,
                characteristicId: _OTA_CHARACTERISTIC,
                deviceId: event.deviceId);
            _midiCharacteristic = QualifiedCharacteristic(
                characteristicId: _MIDI_CHARACTERISTIC,
                serviceId: _DEVICE_UUID,
                deviceId: event.deviceId);
            _configurationCharacteristic = QualifiedCharacteristic(
                characteristicId: _CHARACTERISTIC_CONFIGURATION_UUID,
                serviceId: _CONFIGURATION_SERVICE_UUID,
                deviceId: event.deviceId);
            _flutterReactiveBle
                .subscribeToCharacteristic(_midiCharacteristic)
                .listen((event) {
              _midiDataReceived.add(event);
            }).onError((dynamic error) {
              print('Error receiveng midi: $error');
            });

            //request configuration
            final configurationFromDevice = await _flutterReactiveBle
                .readCharacteristic(_configurationCharacteristic);
            _deviceConfiguration
                .add(_configurationMapper.mapTo(configurationFromDevice));

            break;
          }
        case DeviceConnectionState.disconnected:
          {
            disconnect();
            break;
          }
        default:
          break;
      }
    });
  }
}
