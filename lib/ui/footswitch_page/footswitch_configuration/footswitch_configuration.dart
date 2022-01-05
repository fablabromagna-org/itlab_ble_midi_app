import 'package:flutter/material.dart';
import 'package:itlab_midi_ble/di/di_initializer.dart';
import 'package:itlab_midi_ble/domain/board/footswitch/event_type.dart';
import 'package:itlab_midi_ble/domain/board/footswitch/footswitch_configuration.dart';
import 'package:itlab_midi_ble/domain/board/footswitch/footswitch_event.dart';
import 'package:itlab_midi_ble/domain/midi/midi_type.dart';
import 'package:itlab_midi_ble/ui/colors.dart';
import 'package:itlab_midi_ble/ui/component/bottom_button.dart';
import 'package:itlab_midi_ble/ui/component/custom_textfield.dart';
import 'package:itlab_midi_ble/ui/component/radio_button/radio_button.dart';
import 'package:itlab_midi_ble/ui/component/toolbar/toolbar.dart';
import 'package:itlab_midi_ble/ui/footswitch_page/footswitch_configuration/footswitch_configuration_view_model.dart';
import 'package:itlab_midi_ble/ui/footswitch_page/footswitch_configuration/footswitch_configuration_view_state.dart';

class FootswitchConfigurationWidget extends StatelessWidget {
  final int _footswitchNumber;
  final FootswitchConfiguration _footswitchConfiguration;
  final FootswitchConfigurationViewModel _footswitchConfigurationViewModel =
      getIt<FootswitchConfigurationViewModel>();

  FootswitchConfigurationWidget(
    this._footswitchNumber,
    this._footswitchConfiguration, {
    Key? key,
  }) : super(key: key) {
    _footswitchConfigurationViewModel
        .loadFootswitchConfiguration(_footswitchConfiguration);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FootswitchConfigurationViewState>(
        stream: _footswitchConfigurationViewModel.viewState,
        builder: (context, snapshot) {
          final viewState = snapshot.data;
          return Scaffold(
            appBar: getAppBar('Configuration', Icons.info_outline, null, true,
                onBackPressed: () => Navigator.of(context).pop()),
            body: viewState != null
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                          top: 32, left: 24, right: 24, bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GroupList(
                              viewState.groupIndex,
                              (p0) => _footswitchConfigurationViewModel
                                  .onGroupIndexSelected(p0)),
                          const SizedBox(height: 32),
                          FootswitchEventWidget(false, 'Tap configuration:',
                              viewState.tapConfiguration, (p0) {
                            _footswitchConfigurationViewModel
                                .onTapConfigurationChange(viewState
                                    .tapConfiguration
                                    .copyWith(eventType: p0!));
                          }, (p0) {
                            _footswitchConfigurationViewModel
                                .onTapConfigurationChange(p0);
                          }),
                          const SizedBox(height: 24),
                          FootswitchEventWidget(true, 'Hold configuration:',
                              viewState.holdConfiguration, (p0) {
                            _footswitchConfigurationViewModel
                                .onHoldConfigurationChange(viewState
                                    .holdConfiguration
                                    .copyWith(eventType: p0!));
                          }, (p0) {
                            _footswitchConfigurationViewModel
                                .onHoldConfigurationChange(p0);
                          }),
                          const SizedBox(height: 56),
                          BottomButton(
                            'Save configuration',
                            onPressed: () => _footswitchConfigurationViewModel
                                .sendConfiguration(_footswitchNumber)
                                .then((value) async {
                              await showDialog(
                                  context: context,
                                  builder: (context) => const AlertDialog(
                                      content: Text(
                                          'Configuration sent succesfully!')));
                              Navigator.of(context).pop();
                            }, onError: (obj, stackTrace) async {
                              await showDialog(
                                  context: context,
                                  builder: (context) => const AlertDialog(
                                      content:
                                          Text('Configuration sent failed')));
                            }),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(),
          );
        });
  }
}

class FootswitchEventWidget extends StatelessWidget {
  final bool showRepeat;
  final String title;
  final FootswitchEvent footswitchEvent;
  final void Function(EventType?)? onEventTypeSelected;
  final void Function(FootswitchEvent) onConfigurationChanged;

  const FootswitchEventWidget(
    this.showRepeat,
    this.title,
    this.footswitchEvent,
    this.onEventTypeSelected,
    this.onConfigurationChanged, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
              color: AppColors.textColor,
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
        ExpansionPanelList.radio(
          elevation: 0,
          dividerColor: Colors.transparent,
          initialOpenPanelValue: footswitchEvent.eventType,
          children: [
            _createEventyTypeWidget(
              EventType.SINGLE,
              footswitchEvent.eventType,
              'Single',
              Icons.arrow_right_outlined,
              Container(),
            ),
            if (showRepeat)
              _createEventyTypeWidget(
                EventType.REPEAT,
                footswitchEvent.eventType,
                'Repeat',
                Icons.repeat,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Interval(ms * 100)',
                      style:
                          TextStyle(color: AppColors.textColor, fontSize: 14),
                    ),
                    CustomNumberField(
                      (interval) => onConfigurationChanged(
                          footswitchEvent.copyWith(repeatIntervalMs: interval)),
                      text: footswitchEvent.repeatIntervalMs.toString(),
                    )
                  ],
                ),
              ),
            _createEventyTypeWidget(
              EventType.INCREMENT,
              footswitchEvent.eventType,
              'Increment',
              Icons.exposure,
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Step:',
                        style:
                            TextStyle(color: AppColors.textColor, fontSize: 14),
                      ),
                      CustomNumberField(
                        (interval) => footswitchEvent.copyWith(
                            stepValue: interval, positiveStep: interval >= 0),
                        minNumber: -127,
                        maxNumber: 127,
                        text: footswitchEvent.stepValue.toString(),
                      )
                    ],
                  ),
                  marginWidget,
                  if (showRepeat)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Interval(ms * 100)',
                          style: TextStyle(
                              color: AppColors.textColor, fontSize: 14),
                        ),
                        CustomNumberField(
                            (value) => onConfigurationChanged(footswitchEvent
                                .copyWith(repeatIntervalMs: value)),
                            maxNumber: 255,
                            minNumber: 0,
                            text: footswitchEvent.repeatIntervalMs.toString())
                      ],
                    ),
                ],
              ),
            ),
            _createEventyTypeWidget(
              EventType.ON_OFF,
              footswitchEvent.eventType,
              'On_off',
              Icons.toggle_off,
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Midi Value off:',
                        style:
                            TextStyle(color: AppColors.textColor, fontSize: 14),
                      ),
                      CustomNumberField(
                        (value) => onConfigurationChanged(
                            footswitchEvent.copyWith(midiValueOff: value)),
                        minNumber: 0,
                        maxNumber: 127,
                        text: footswitchEvent.midiValueOff.toString(),
                      )
                    ],
                  ),
                  marginWidget,
                  if (showRepeat)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Interval(ms * 100)',
                          style: TextStyle(
                              color: AppColors.textColor, fontSize: 14),
                        ),
                        CustomNumberField(
                          (value) => onConfigurationChanged(footswitchEvent
                              .copyWith(repeatIntervalMs: value)),
                          minNumber: 0,
                          maxNumber: 255,
                          text: footswitchEvent.repeatIntervalMs.toString(),
                        )
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
        marginWidget,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Midi type:',
              style: TextStyle(color: AppColors.textColor, fontSize: 14),
            ),
            Row(
              children: [
                RadioButton(
                    value: MidiType.CC,
                    groupValue: footswitchEvent.midiType,
                    onChanged: onMidiTypeSelected,
                    leading: 'CC'),
                RadioButton(
                    value: MidiType.PC,
                    groupValue: footswitchEvent.midiType,
                    onChanged: onMidiTypeSelected,
                    leading: 'PC')
              ],
            ),
          ],
        ),
        marginWidget,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Midi number:',
              style: TextStyle(color: AppColors.textColor, fontSize: 14),
            ),
            CustomNumberField(
              (value) => onConfigurationChanged(
                  footswitchEvent.copyWith(midiNumber: value)),
              text: footswitchEvent.midiNumber.toString(),
            )
          ],
        ),
        marginWidget,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Midi value:',
              style: TextStyle(color: AppColors.textColor, fontSize: 14),
            ),
            CustomNumberField(
                (value) => onConfigurationChanged(
                    footswitchEvent.copyWith(midiValueOn: value)),
                text: footswitchEvent.midiValueOn.toString()),
          ],
        ),
      ],
    );
  }

  void onMidiTypeSelected(MidiType? midiType) {
    if (midiType != null) {
      onConfigurationChanged(footswitchEvent.copyWith(midiType: midiType));
    }
  }

  Widget get marginWidget => const SizedBox(
        height: 16,
      );

  ExpansionPanelRadio _createEventyTypeWidget(
      EventType value,
      EventType currentEventSelected,
      String eventTitle,
      IconData eventIcon,
      Widget radioExpandedBody) {
    return ExpansionPanelRadio(
      canTapOnHeader: true,
      backgroundColor: AppColors.primary,
      value: value,
      headerBuilder: (context, isExpanded) => RadioListTile(
        value: value,
        groupValue: currentEventSelected,
        onChanged: onEventTypeSelected,
        activeColor: AppColors.textColor,
        title: Text(
          eventTitle,
          style: TextStyle(color: AppColors.textColor, fontSize: 16),
        ),
        secondary: Icon(
          eventIcon,
          color: AppColors.textColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: radioExpandedBody,
      ),
    );
  }
}

class GroupList extends StatelessWidget {
  final int selectedGroup;
  final int numberOfGroups;
  final Function(int) onGroupPressed;

  const GroupList(
    this.selectedGroup,
    this.onGroupPressed, {
    Key? key,
    this.numberOfGroups = 4,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'Group:',
          style: TextStyle(
              color: AppColors.textColor,
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < AppColors.groupColors.length; i++)
              ColorsGroupColor(selectedGroup == i, i, onGroupPressed)
          ],
        ),
      ],
    );
  }
}

class ColorsGroupColor extends StatelessWidget {
  final bool isSelected;
  final int index;
  static const double size = 30;
  final Function(int) onGroupPressed;

  const ColorsGroupColor(
    this.isSelected,
    this.index,
    this.onGroupPressed, {
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        color: AppColors.groupColors[index],
        foregroundDecoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(size / 2),
            ),
            border: Border.all(
                color: isSelected ? AppColors.textColor : Colors.transparent,
                width: 2)),
        child: GestureDetector(
          onTap: () => onGroupPressed(index),
        ),
      ),
    );
  }
}
