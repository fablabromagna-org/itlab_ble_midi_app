import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:itlab_midi_ble/domain/board/configuration.dart';
import 'package:itlab_midi_ble/domain/board/footswitch/event_type.dart';
import 'package:itlab_midi_ble/domain/board/footswitch/footswitch_configuration.dart';
import 'package:itlab_midi_ble/domain/board/footswitch/footswitch_event.dart';
import 'package:itlab_midi_ble/ui/colors.dart';

class Footswitch extends StatelessWidget {
  final FootswitchConfiguration _footswitchConfiguration;
  final List<InternalVariable> _internalVariables;

  const Footswitch(
    this._footswitchConfiguration,
    this._internalVariables, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
          child: SizedBox(
            width: 180,
            child: Stack(
              children: [
                Column(children: [
                  Container(
                    color: Colors.amber,
                    height: 52,
                  ),
                  Container(
                    color: AppColors.textColor,
                    height: 218,
                  ),
                ]),
                Positioned(
                    left: 60,
                    top: 20,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.textColor,
                      child: SvgPicture.asset('assets/ic_footswitch.svg',
                          width: 40, height: 40),
                    )),
                Positioned(
                    top: 70,
                    width: 180,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FootswitchInformationColumn(
                            _footswitchConfiguration.tapConfiguration,
                            _internalVariables,
                            'TAP'),
                        FootswitchInformationColumn(
                          _footswitchConfiguration.holdConfiguration,
                          _internalVariables,
                          'HOLD',
                          isHold: true,
                        )
                      ],
                    ))
              ],
            ),
          ),
        ));
  }
}

class FootswitchInformationColumn extends StatelessWidget {
  final FootswitchEvent _footswitchEvent;
  final List<InternalVariable> internalVariable;
  final String title;
  final bool isHold;

  const FootswitchInformationColumn(
    this._footswitchEvent,
    this.internalVariable,
    this.title, {
    this.isHold = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget footswitchInformation;
    IconData evetnIcon;
    final List<Widget> columnWidget = [];
    switch (_footswitchEvent.eventType) {
      case EventType.SINGLE:
        evetnIcon = Icons.arrow_right;
        columnWidget.addAll([
          FootswitchValueInfo(
            'CH',
            _footswitchEvent.midiChannel.toString(),
            valueTypeColor: AppColors.primary,
          ),
          FootswitchValueInfo(
            _footswitchEvent.midiType.name,
            _footswitchEvent.midiNumber.toString(),
          ),
          FootswitchValueInfo(
            'V',
            _footswitchEvent.midiValueOn.toString(),
          ),
        ]);
        break;
      case EventType.REPEAT:
        evetnIcon = Icons.repeat;
        columnWidget.addAll([
          FootswitchValueInfo(
            'CH',
            _footswitchEvent.midiChannel.toString(),
            valueTypeColor: AppColors.primary,
          ),
          FootswitchValueInfo(
            'RT',
            '${_footswitchEvent.midiChannel}"',
            valueTypeColor: Colors.green.shade900,
          ),
          FootswitchValueInfo(
            _footswitchEvent.midiType.name,
            _footswitchEvent.midiNumber.toString(),
          ),
          FootswitchValueInfo(
            'V',
            _footswitchEvent.midiValueOn.toString(),
          ),
        ]);
        break;
      case EventType.INCREMENT:
        evetnIcon = Icons.exposure;
        columnWidget.addAll([
          FootswitchValueInfo(
            'CH',
            _footswitchEvent.midiChannel.toString(),
            valueTypeColor: AppColors.primary,
          ),
          if (isHold)
            FootswitchValueInfo(
              'RT',
              '${_footswitchEvent.midiChannel}"',
              valueTypeColor: Colors.green.shade900,
            ),
          FootswitchValueInfo('m-M',
              '${internalVariable[_footswitchEvent.internalValueIndex].minValue}-${internalVariable[_footswitchEvent.internalValueIndex].maxValue}'),
          FootswitchValueInfo(
            'SP',
            '${_footswitchEvent.positiveStep == true ? '+' : '-'}${_footswitchEvent.stepValue}',
          ),
          FootswitchValueInfo(
            'CE',
            internalVariable[_footswitchEvent.internalValueIndex]
                .cycle
                .toString(),
          ),
          FootswitchValueInfo(
            _footswitchEvent.midiType.name,
            _footswitchEvent.midiNumber.toString(),
          ),
          FootswitchValueInfo(
            'V',
            _footswitchEvent.midiValueOn.toString(),
          ),
        ]);
        break;
      case EventType.ON_OFF:
        evetnIcon = Icons.toggle_off;
        columnWidget.addAll([
          FootswitchValueInfo(
            'CH',
            _footswitchEvent.midiChannel.toString(),
            valueTypeColor: AppColors.primary,
          ),
          FootswitchValueInfo(
            _footswitchEvent.midiType.name,
            _footswitchEvent.midiNumber.toString(),
          ),
          FootswitchValueInfo(
            'Von',
            _footswitchEvent.midiValueOn.toString(),
          ),
          FootswitchValueInfo(
            'Voff',
            _footswitchEvent.midiValueOff.toString(),
          )
        ]);
        break;
    }
    footswitchInformation = Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.primary)),
          child: Icon(
            evetnIcon,
            size: 24,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [...columnWidget],
        )
      ],
    );
    return footswitchInformation;
  }
}

class FootswitchValueInfo extends StatelessWidget {
  final String valueType;
  final String value;
  final Color valueTypeColor;

  const FootswitchValueInfo(
    this.valueType,
    this.value, {
    Key? key,
    this.valueTypeColor = Colors.blue,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 35,
          height: 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: valueTypeColor,
              border: Border.all(color: AppColors.primary)),
          child: Text(valueType, style: const TextStyle(color: Colors.white)),
        ),
        Container(
          width: 40,
          height: 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.primary)),
          child: Text(
            value,
            style: TextStyle(color: AppColors.primary),
          ),
        )
      ],
    );
  }
}
