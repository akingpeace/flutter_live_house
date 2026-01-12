import 'package:flutter/material.dart';

class Usercenter extends StatelessWidget {
  const Usercenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('用户中心')),
      body: Center(child: Text('欢迎来到用户中心！')),
    );
  }
}

