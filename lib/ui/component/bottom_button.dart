import 'package:flutter/material.dart';
import 'package:itlab_midi_ble/ui/colors.dart';

class BottomButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonText;
  static const double buttonHeight = 56;
  static const double margin = 34;

  const BottomButton(this.buttonText, {Key? key, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: buttonHeight,
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(AppColors.textColor)),
          onPressed: onPressed,
          child: Text(
            buttonText,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.primary),
          )),
    );
  }
}
