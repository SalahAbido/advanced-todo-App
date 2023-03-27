import 'package:advanced_todo_app/controllers/notification_controller.dart';
import 'package:advanced_todo_app/db/db_helper.dart';
import 'package:advanced_todo_app/services/theme_servces.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'modules/themes.dart';
import 'ui/screens/home_page.dart';
import 'ui/screens/notification_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationController().initializeNoification();
  await DbHelper.open();
  await GetStorage.init();
  runApp(const MyApp());

}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      themeMode: ThemeServices().Theme,
      home: const HomePage(),
    );
  }
}

