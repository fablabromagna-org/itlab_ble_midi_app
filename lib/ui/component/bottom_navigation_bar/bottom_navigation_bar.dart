import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:itlab_midi_ble/ui/colors.dart';

bottomNavigationBar(int currentIndex, Function(int)? onTap) => Container(
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(15), topLeft: Radius.circular(15)),
    ),
    child: ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15.0),
        topRight: Radius.circular(15.0),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: AppColors.textColor,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.iconDisabled,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 24,
            ),
            label: 'Home Page',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/ic_footswitch.svg',
                width: 24, height: 24),
            label: 'Footswitches',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              size: 24,
            ),
            label: 'Settings',
          )
        ],
      ),
    ));
