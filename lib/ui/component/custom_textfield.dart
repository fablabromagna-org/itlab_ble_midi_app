import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itlab_midi_ble/ui/colors.dart';

class CustomNumberField extends StatefulWidget {
  final Function(int) onNumberChanged;
  final int maxNumber;
  final int minNumber;
  final String? text;

  const CustomNumberField(this.onNumberChanged,
      {Key? key, this.maxNumber = 127, this.minNumber = 0, this.text})
      : super(key: key);

  @override
  State<CustomNumberField> createState() => _CustomNumberFieldState();
}

class _CustomNumberFieldState extends State<CustomNumberField> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    _textEditingController.value = TextEditingController.fromValue(
            TextEditingValue(text: widget.text ?? ''))
        .value;
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 70,
        height: 45,
        child: TextField(
          controller: _textEditingController,
          cursorColor: AppColors.primary,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
              border: const OutlineInputBorder(
                  gapPadding: 0,
                  borderSide: BorderSide(),
                  borderRadius: BorderRadius.all(Radius.circular(0))),
              filled: true,
              fillColor: AppColors.textColor,
              focusedBorder: OutlineInputBorder(
                  gapPadding: 0,
                  borderSide: BorderSide(color: AppColors.primary),
                  borderRadius: const BorderRadius.all(Radius.circular(0))),
              helperStyle: TextStyle(color: AppColors.textColor)),
          keyboardType: TextInputType.number,
          onChanged: (text) {
            int interval = int.tryParse(text) ?? 0;
            if (interval >= widget.minNumber && interval <= widget.maxNumber) {
              widget.onNumberChanged(interval);
            }
          },
          onEditingComplete: () {
            int interval = int.tryParse(_textEditingController.text) ?? 0;
            if (interval >= widget.minNumber && interval <= widget.maxNumber) {
              widget.onNumberChanged(interval);
            }
          },
          maxLength: 3,
          maxLines: 1,
        ));
  }
}
