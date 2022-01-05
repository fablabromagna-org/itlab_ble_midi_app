import 'package:flutter/material.dart';
import 'package:itlab_midi_ble/ui/colors.dart';

class RadioButton<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String leading;
  final ValueChanged<T?> onChanged;

  const RadioButton({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.leading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: _customRadioButton,
    );
  }

  Widget get _customRadioButton {
    final isSelected = value == groupValue;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : AppColors.textColor,
        border: Border.all(),
      ),
      child: Text(
        leading,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.primary,
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }
}
