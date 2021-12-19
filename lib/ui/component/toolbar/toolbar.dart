import 'package:flutter/material.dart';
import 'package:itlab_midi_ble/ui/colors.dart';

AppBar getAppBar(
  final String title,
  final IconData icon,
  final Function()? iconClickListener,
  final bool isBackEnabled,
) =>
    AppBar(
      backgroundColor: AppColors.primary,
      title: Text(
        title,
        style: TextStyle(
            color: AppColors.textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold),
      ),
      elevation: 0,
      actions: [
        IconButton(
            onPressed: iconClickListener,
            icon: Icon(
              icon,
              color: AppColors.textColor,
            ))
      ],
      leading: isBackEnabled
          ? IconButton(
              onPressed: iconClickListener,
              icon: const Icon(Icons.arrow_back_ios_new))
          : null,
    );
