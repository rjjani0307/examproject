import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:task_managment/services/theme_services.dart';
import 'package:task_managment/ui/auth_screen/sign_in_screen.dart';
import 'package:task_managment/ui/screens/home_screen.dart';
import 'package:task_managment/ui/screens/splash_screen.dart';
import 'package:task_managment/ui/theme.dart';

import 'db/db_helper.dart';
import 'package:timezone/data/latest_10y.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeTimeZones();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  await DBHelper.initDb();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      home: Splash(),
    );
  }
}