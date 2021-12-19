import 'package:flutter/material.dart';
import 'package:itlab_midi_ble/ui/colors.dart';

class DiscoveredDeviceItem extends StatelessWidget {
  final String name;
  final String macAddress;
  final int dBm;
  final Function()? onCLickListener;
  const DiscoveredDeviceItem(this.name, this.macAddress, this.dBm,
      {Key? key, this.onCLickListener})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      tileColor: AppColors.iconDisabled,
      onTap: onCLickListener,
      enabled: onCLickListener != null,
      leading: CircleAvatar(
        backgroundColor: Colors.black,
        child: Text(
          'F',
          style: TextStyle(
              color: AppColors.textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(
        name,
        style: TextStyle(
          color: AppColors.textColor,
          fontSize: 18,
        ),
      ),
      subtitle: Text(
        macAddress,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 12,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.wifi_tethering,
            color: Colors.black,
          ),
          Text('$dBm dbm')
        ],
      ),
    );
  }
}
