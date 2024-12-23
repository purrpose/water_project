import 'package:go_router/go_router.dart';
import 'package:task_manager/features/pages/auth_page.dart';
import 'package:task_manager/features/pages/reg_page.dart';
import 'package:task_manager/features/pages/settings_page.dart';
import 'package:task_manager/features/pages/water_page.dart';

abstract class AppRouter {
  static final GoRouter router =
      GoRouter(initialLocation: AuthPage.path, routes: [
    GoRoute(
      path: AuthPage.path,
      builder: (context, state) => const AuthPage(),
    ),
    GoRoute(
      path: RegPage.path,
      builder: (context, state) => const RegPage(),
    ),
    GoRoute(
      path: WaterPage.path,
      builder: (context, state) => const WaterPage(),
    ),
    GoRoute(
      path: SettingsPage.path,
      builder: (context, state) => const SettingsPage(),
    ),
  ]);
}
