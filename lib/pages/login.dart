import 'package:flutter/material.dart';
import 'package:flutter_live_house/core/themes/app_theme.dart';
import '../core/services/http_service.dart'; // 导入 HttpService
import './registy.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void onLogin() async {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('请输入用户名和密码')));
      return;
    }

    // 显示加载状态
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('正在登录...'),
            ],
          ),
        );
      },
    );

    try {
      // 调用登录接口
      var response = await HttpService().post(
        '/api/user/login',
        data: {'username': username, 'password': password},
      );

      // 关闭加载对话框
      if (!mounted) return; // 检查是否仍然挂载
      Navigator.of(context).pop();

      // 响应数据现在已经是解码后的 Map，无需再次调用 json.decode
      dynamic responseData = response.data;

      // 现在可以直接检查响应数据
      if (responseData is Map && responseData['code'] == 200) {
        // 登录成功 - 保存 token
        String? token =
            responseData['data']['token']; // 假设 token 在 data.token 字段中
        if (token != null) {
          await HttpService().saveToken(token);
        }
        // 显示成功消息
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('登录成功')));
        // 跳转到主页
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      } else {
        // 登录失败
        String errorMessage = responseData['message'] ?? '登录失败';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } catch (e) {
      // 关闭加载对话框
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      // 错误处理
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('登录出错: ${e.toString()}')));
    }
  }

  void goRegisty() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const Registy(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: Text('欢迎回来', style: AppTheme.customAppBarTitle),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              SizedBox(height: 40),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: '请输入用户名',
                  labelText: '用户名',
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: '请输入密码',
                  labelText: '密码',
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              SizedBox(height: 64),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(onPressed: onLogin, child: Text('登录')),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: goRegisty,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryColor,
                  ),
                  child: Text('注册'),
                ),
              ),
              SizedBox(height: 64),
              TextButton(
                onPressed: () {
                  // Navigator.pushNamed(context, '/forget');
                },
                child: Text('忘记密码'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
