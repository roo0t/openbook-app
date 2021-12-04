import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:openbook/src/launch_switcher.dart';
import 'package:openbook/src/user/sign_in_page.dart';
import 'package:openbook/src/user/user_controller.dart';

import 'src/home_page.dart';

void main() async {
  await GetStorage.init('auth');
  runApp(const OpenBookApp());
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, (swatch as Map<int, Color>));
}

class OpenBookApp extends StatelessWidget {
  const OpenBookApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'OPEN BOOK',
        theme: ThemeData(
          primarySwatch:
              createMaterialColor(const Color.fromARGB(255, 56, 87, 35)),
          fontFamily: 'RidiBatang',
          textTheme: const TextTheme(
            headline5: TextStyle(fontSize: 18),
            headline6: TextStyle(fontSize: 18),
            bodyText1: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
            bodyText2: TextStyle(
              fontSize: 16,
              color: Color.fromARGB(180, 0, 0, 0),
              height: 1.5,
            ),
          ),
        ),
        home: const LaunchSwitcher());
  }
}
