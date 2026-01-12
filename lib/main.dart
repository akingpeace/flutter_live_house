import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_size/window_size.dart';

import 'package:flutter_live_house/pages/home.dart';
import 'package:flutter_live_house/pages/login.dart';
import 'package:flutter_live_house/core/themes/app_theme.dart';

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

/// ==================
/// 路由（全部 opaque）
/// ==================
Route<dynamic> _onGenerateRoute(RouteSettings settings) {
  Widget page;

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
    opaque: true, // 关键：实体路由
    pageBuilder: (_, __, ___) => page,
    transitionDuration: const Duration(milliseconds: 180),
    reverseTransitionDuration: const Duration(milliseconds: 180),
    transitionsBuilder: (_, animation, __, child) {
      return FadeTransition(opacity: animation, child: child);
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
        /// 背景图（不会闪）
        Positioned.fill(
          child: Image.asset(
            'assets/images/icon_nfgqaoquyp/bg-image2.jpg',
            fit: BoxFit.cover,
          ),
        ),

        /// 模糊层
        Positioned.fill(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: const SizedBox(),
          ),
        ),

        /// 轻遮罩
        Positioned.fill(
          child: Container(color: Colors.black.withOpacity(0.05)),
        ),

        /// 页面内容（路由在这里切换）
        Positioned.fill(child: child),
      ],
    );
  }
}
