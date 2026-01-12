import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_size/window_size.dart';

import 'package:flutter_live_house/core/themes/app_theme.dart';
import 'package:flutter_live_house/pages/home.dart';
import 'package:flutter_live_house/pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
    setWindowMinSize(const Size(375, 700));
    setWindowMaxSize(const Size(375, 700));
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Live House',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      onGenerateRoute: _onGenerateRoute,
      builder: (context, child) {
        return _GlobalBackground(child: child ?? const SizedBox.shrink());
      },
    );
  }
}

/// =======================
/// 路由生成（push 动画，pop 无动画）
/// =======================
Route<dynamic> _onGenerateRoute(RouteSettings settings) {
  late Widget page;

  switch (settings.name) {
    case '/':
      page = const HomePage();
      break;
    case '/login':
      page = const LoginPage();
      break;
    default:
      page = const HomePage();
  }

  return PageRouteBuilder(
    settings: settings,
    opaque: true,
    transitionDuration: const Duration(milliseconds: 220),
    reverseTransitionDuration: Duration.zero, // ⭐ pop 无动画
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.03),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      );
    },
  );
}

/// =======================
/// 全局背景（只创建一次）
/// =======================
class _GlobalBackground extends StatelessWidget {
  final Widget child;

  const _GlobalBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 背景图
        Positioned.fill(
          child: Image.asset(
            'assets/images/icon_nfgqaoquyp/bg-image2.jpg',
            fit: BoxFit.cover,
          ),
        ),

        // 模糊层
        Positioned.fill(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: const SizedBox(),
          ),
        ),

        // 轻遮罩
        Positioned.fill(
          child: Container(color: Colors.white.withValues(alpha: 0.5)),
        ),

        // 页面内容
        Positioned.fill(child: child),
      ],
    );
  }
}
