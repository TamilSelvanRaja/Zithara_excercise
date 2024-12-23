import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:zithara_excersize/controllers/task_controller.dart';
import 'package:zithara_excersize/resources/ui_helper.dart';
import 'package:zithara_excersize/services/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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
