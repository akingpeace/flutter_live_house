import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void onLogin() {
    print(usernameController.text);
    print(passwordController.text);
    Navigator.pushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('登录')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: <Widget>[
              Text('Login'),
              SizedBox(height: 40),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: '请输入用户名',
                  labelText: '用户名',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(hintText: '请输入密码', labelText: '密码'),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(onPressed: onLogin, child: Text('登录')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
