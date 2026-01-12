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
        // 登录成功
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('登录成功')));

        // 保存用户信息（例如 token）
        // 跳转到主页
        Navigator.pushNamed(context, '/');
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
      appBar: AppBar(title: Text('欢迎回来',style: TextStyle(color: AppTheme.textColorPrimary),)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: <Widget>[
            SizedBox(height: 40),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(hintText: '请输入用户名', labelText: '用户名'),
            ),
            SizedBox(height: 20),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(hintText: '请输入密码', labelText: '密码'),
            ),
            SizedBox(height: 60),
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  OverflowBar(
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(120, 45), // 最小尺寸
                          // fixedSize: Size(120, 45), // 固定尺寸（可选）
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ), // 内边距
                        ),
                        onPressed: onLogin,
                        child: Text('登录'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(120, 45), // 最小尺寸
                          // fixedSize: Size(120, 45), // 固定尺寸（可选）
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ), // 内边距
                        ),
                        onPressed: goRegisty,
                        child: Text('注册'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forget');
                    },
                    child: Text('忘记密码'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
