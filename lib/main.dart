import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart'; // 用于 kIsWeb
import 'dart:ui' as ui; // 需要导入这个包来使用 BackdropFilter
import 'dart:io'; // 用于 Platform
import 'package:window_size/window_size.dart';
import 'package:flutter_live_house/pages/home.dart';
import 'package:flutter_live_house/pages/login.dart';
import 'package:flutter_live_house/core/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 仅在桌面平台且非 Web 环境设置窗口大小
  if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
    // 设置窗口不可调整大小，这样会隐藏最大化按钮
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
      theme: ThemeData(
        useMaterial3: true,
        textTheme: TextTheme(
          bodyLarge: const TextStyle(fontSize: 16, color: Colors.black),
          displayLarge: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        scaffoldBackgroundColor: Colors.white70, // 改为透明！
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent, // AppBar也改为透明
          foregroundColor: AppTheme.onPrimaryColor,
          elevation: 0, // 去掉阴影
        ),
      ),
      title: 'Flutter Live House',
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/login': (context) => LoginPage(),
      },
      // 添加 builder 来设置全局背景图片
      builder: (context, child) {
        return Stack(
          children: [
            // 背景图片
            // Container(
            //   decoration: BoxDecoration(
            //     image: DecorationImage(
            //       image: AssetImage(
            //         'assets/images/icon_nfgqaoquyp/bg-image2.jpg',
            //       ), // 替换为你的图片路径
            //       fit: BoxFit.cover, // 铺满整个屏幕
            //       opacity: 0.7, // 可选：设置透明度
            //       colorFilter: ColorFilter.mode(
            //         Colors.black.withOpacity(0.5),
            //         BlendMode.darken,
            //       ),
            //     ),
            //   ),
            // ),
            // 背景图片
            Image.asset(
              'assets/images/icon_nfgqaoquyp/bg-image2.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            // 模糊效果层
            BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 2, sigmaY: 2), // 控制模糊程度
              child: Container(
                color: Colors.transparent, // 保持透明
              ),
            ),
            // 原始页面内容
            child!,
          ],
        );
      },
    );
  }
}
