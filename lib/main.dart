import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:zithara_excersize/controllers/task_controller.dart';
import 'package:zithara_excersize/resources/ui_helper.dart';
import 'package:zithara_excersize/services/initial_binding.dart';
import 'package:zithara_excersize/services/router.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  InitialBinding().dependencies();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyDNGJrHDjEp_7Tz1IYGa0qHfUVJ-yey3nI",
    appId: "1:923237625165:android:43b36e163332924ea15b04",
    messagingSenderId: "923237625165",
    projectId: "androidteamchat-5f8c2",
  ));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TaskController taskController = Get.put(TaskController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        themeMode: taskController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        theme: UiHelper.lightThemeref(),
        darkTheme: UiHelper.darkThemeref(),
        initialRoute: RoutePaths.splash,
        getPages: AppPages.pages,
      ),
    );
  }
}
