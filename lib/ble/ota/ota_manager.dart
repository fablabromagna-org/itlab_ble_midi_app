// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class OtaManager {
  static const _INFO_PACKET_COMMAND = 0xFF;
  static const _NEXT_PACKET_COMMAND = 0xFC;
  static const _LAST_PACKET_COMMAND = 0xFE;
  static const _OTA_PACKET_SIZE = 510;

  final FlutterReactiveBle _bleManager;
  final File _updateFile;

  OtaManager(this._bleManager, this._updateFile);

  Stream<double> startOTA(QualifiedCharacteristic bleOtaCharacteristic) async* {
    var fileBites = await _updateFile.readAsBytes();
    int totalParts = (fileBites.length / _OTA_PACKET_SIZE).ceil();

    //send info packet with data information
    //the structure is the following:
    // [0] = command
    // [1] = total parts last 8 bit
    // [2] = total parts first 8 bit
    final infoPacket = Uint8List(3);
    infoPacket[0] = _INFO_PACKET_COMMAND;
    infoPacket[1] = (totalParts & 0xFF00) >> 8;
    infoPacket[2] = totalParts & 0x00FF;

    await _bleManager.writeCharacteristicWithResponse(bleOtaCharacteristic,
        value: infoPacket);

    final otaPacket = BytesBuilder();
    for (int i = 0; i < totalParts; i++) {
      final readData = i * _OTA_PACKET_SIZE;
      if (fileBites.length - readData > _OTA_PACKET_SIZE) {
        final packetBytes =
            fileBites.sublist(readData, readData + _OTA_PACKET_SIZE);
        otaPacket.addByte(_NEXT_PACKET_COMMAND);
        otaPacket.add(packetBytes);
      } else {
        final packetBytes = fileBites.sublist(readData, fileBites.length);
        otaPacket.addByte(_LAST_PACKET_COMMAND);
        otaPacket.add(packetBytes);
      }
      var packet = otaPacket.takeBytes();
      await _bleManager.writeCharacteristicWithResponse(bleOtaCharacteristic,
          value: packet);
      yield i / totalParts;
    }
    //since the file is cached every time, delete it from cache
    _updateFile.deleteSync();
  }
}
