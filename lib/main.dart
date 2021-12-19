import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itlab_midi_ble/ui/colors.dart';
import 'package:itlab_midi_ble/ui/component/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:itlab_midi_ble/ui/home_page/home_page.dart';
import 'package:itlab_midi_ble/ui/settings_page/settings_page.dart';

import 'di/di_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ITLAB MIDI BLE',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.primary,
        primaryColor: AppColors.textColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PageContainer(),
    );
  }
}

class PageContainer extends StatefulWidget {
  final List<Widget> pages = [HomePage(), HomePage(), SettingsPage()];
  PageContainer({Key? key}) : super(key: key);
  @override
  _PageContainerState createState() => _PageContainerState();
}

class _PageContainerState extends State<PageContainer> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        bottomNavigationBar:
            bottomNavigationBar(_currentIndex, onBottomBarElementTapped),
        body: IndexedStack(
          index: _currentIndex,
          children: widget.pages,
        ),
      );

  void onBottomBarElementTapped(int elementIndex) {
    if (elementIndex != _currentIndex) {
      setState(() {
        _currentIndex = elementIndex;
      });
    }
  }
}

class LogContainer extends StatelessWidget {
  final String? log;

  const LogContainer(this.log, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3.0),
      width: 1400,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue, width: 2)),
      height: 90,
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Text(log ?? ''),
        ),
      ),
    );
  }
}
