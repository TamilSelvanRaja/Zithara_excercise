import 'package:get/get.dart';
import 'package:zithara_excersize/ui/home_screen.dart';
import 'package:zithara_excersize/ui/login_screen.dart';
import 'package:zithara_excersize/ui/splash_screen.dart';

class RoutePaths {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
}

abstract class AppPages {
  static final pages = [
    GetPage(
      name: RoutePaths.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: RoutePaths.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: RoutePaths.home,
      page: () => MyHomePage(),
    ),
  ];
}
