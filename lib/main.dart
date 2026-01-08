import 'package:flutter/material.dart';
import 'package:flutter_live_house/pages/home.dart';
import 'package:flutter_live_house/pages/login.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/login': (context) => LoginPage(),
        // 可以添加更多路由
      },
      
    );
  }
}
