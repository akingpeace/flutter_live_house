import 'package:flutter/material.dart';
import '../core/services/http_service.dart'; // 导入 HttpService
import '../widgets/base_page.dart';

class Registy extends StatefulWidget {
  const Registy({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegistyState();
  }
}

class _RegistyState extends State<Registy> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String?> _errors = {}; // 存储错误信息
  final Map<String, FocusNode> _focusNodes = {}; // 焦点节点

  final List<String> _fields = [
    'name',
    'username',
    'password',
    'confirmPassword',
    'email',
    'phone',
    'gender',
  ];

  // 性别选项
  final List<Map<String, dynamic>> _genders = [
    {'id': 1, 'label': '男'},
    {'id': 2, 'label': '女'},
  ];

  int? _selectedGender; // 当前选中的性别

  @override
  void initState() {
    super.initState();
    for (var field in _fields) {
      _controllers[field] = TextEditingController();
      _focusNodes[field] = FocusNode();
    }

    // 监听焦点变化，以便滚动到当前焦点控件
    for (var field in _fields) {
      _focusNodes[field]!.addListener(() {
        if (_focusNodes[field]!.hasFocus) {
          // 当获得焦点时，延迟一点时间再滚动
          Future.delayed(Duration(milliseconds: 300), () {
            _scrollToFocusedField(field);
          });
        }
      });
    }
  }

  // 滚动到当前焦点字段
  void _scrollToFocusedField(String field) {
    Scrollable.ensureVisible(
      _focusNodes[field]!.context!,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    // 清理资源
    for (TextEditingController controller in _controllers.values) {
      controller.dispose();
    }
    for (FocusNode focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }

  // 验证函数
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入姓名';
    }
    if (value.length < 2) {
      return '姓名至少需要2个字符';
    }
    if (value.length > 20) {
      return '姓名不能超过20个字符';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入用户名';
    }
    if (value.length < 3) {
      return '用户名至少需要3个字符';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入密码';
    }
    if (value.length < 6) {
      return '密码至少需要6个字符';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return '请确认密码';
    }
    if (value != _controllers['password']?.text) {
      return '两次输入的密码不一致';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入邮箱';
    }
    // 简单的邮箱格式验证
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return '请输入有效的邮箱地址';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入手机号码';
    }
    // 简单的手机号验证（中国手机号格式）
    final phoneRegex = RegExp(r'^1[3-9]\d{9}$');
    if (!phoneRegex.hasMatch(value)) {
      return '请输入有效的手机号码';
    }
    return null;
  }

  void _onRegister() {
    setState(() {
      _errors.clear(); // 清除之前的错误
    });

    // 手动验证所有字段
    bool isValid = true;

    if (_validateName(_controllers['name']?.text) != null) {
      _errors['name'] = _validateName(_controllers['name']?.text);
      isValid = false;
    }

    if (_validateUsername(_controllers['username']?.text) != null) {
      _errors['username'] = _validateUsername(_controllers['username']?.text);
      isValid = false;
    }

    if (_validatePassword(_controllers['password']?.text) != null) {
      _errors['password'] = _validatePassword(_controllers['password']?.text);
      isValid = false;
    }

    if (_validateConfirmPassword(_controllers['confirmPassword']?.text) !=
        null) {
      _errors['confirmPassword'] = _validateConfirmPassword(
        _controllers['confirmPassword']?.text,
      );
      isValid = false;
    }

    if (_validateEmail(_controllers['email']?.text) != null) {
      _errors['email'] = _validateEmail(_controllers['email']?.text);
      isValid = false;
    }

    if (_validatePhone(_controllers['phone']?.text) != null) {
      _errors['phone'] = _validatePhone(_controllers['phone']?.text);
      isValid = false;
    }

    if (_selectedGender == null) {
      _errors['gender'] = '请选择性别';
      isValid = false;
    }

    if (isValid) {
      final data = {
        'name': _controllers['name']?.text,
        'username': _controllers['username']?.text,
        'password': _controllers['password']?.text,
        'email': _controllers['email']?.text,
        'phone': _controllers['phone']?.text,
        'gender': _selectedGender,
      };
      HttpService().setContext(context);
      // 所有验证通过，执行注册逻辑
      HttpService().post('/api/user/register', data: data).then((response) {
        _showSuccessDialog();
      });
    } else {
      // 有错误，重新构建界面显示错误信息
      setState(() {});
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('注册成功'),
          content: Text('注册信息已提交'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
                Navigator.pop(context); // 返回上一页
              },
              child: Text('确定'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('注册')),
      body: BasePage(
        child: SafeArea(
          // 确保内容在安全区域内
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 4,
                children: [
                  // 姓名输入框
                  _buildCustomTextField(
                    controller: _controllers['name']!,
                    focusNode: _focusNodes['name']!,
                    labelText: '姓名',
                    keyboardType: TextInputType.name,
                    validator: _validateName,
                    errorText: _errors['name'],
                  ),
                  // 用户名输入框
                  _buildCustomTextField(
                    controller: _controllers['username']!,
                    focusNode: _focusNodes['username']!,
                    labelText: '用户名',
                    keyboardType: TextInputType.text,
                    validator: _validateUsername,
                    errorText: _errors['username'],
                  ),
                  // 密码输入框
                  _buildCustomTextField(
                    controller: _controllers['password']!,
                    focusNode: _focusNodes['password']!,
                    labelText: '密码',
                    obscureText: true,
                    validator: _validatePassword,
                    errorText: _errors['password'],
                  ),
                  // 确认密码输入框
                  _buildCustomTextField(
                    controller: _controllers['confirmPassword']!,
                    focusNode: _focusNodes['confirmPassword']!,
                    labelText: '确认密码',
                    obscureText: true,
                    validator: _validateConfirmPassword,
                    errorText: _errors['confirmPassword'],
                  ),
                  // 邮箱输入框
                  _buildCustomTextField(
                    controller: _controllers['email']!,
                    focusNode: _focusNodes['email']!,
                    labelText: '邮箱',
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                    errorText: _errors['email'],
                  ),
                  // 手机号输入框
                  _buildCustomTextField(
                    controller: _controllers['phone']!,
                    focusNode: _focusNodes['phone']!,
                    labelText: '手机号码',
                    keyboardType: TextInputType.phone,
                    validator: _validatePhone,
                    errorText: _errors['phone'],
                  ),
                  // 性别选择
                  _buildGenderSelection(),
                  SizedBox(height: 32),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onRegister,
                      child: Text('注册'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: errorText != null ? Colors.red : Colors.transparent,
                width: 2.0,
              ),
            ),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode, // 添加焦点节点
            decoration: InputDecoration(
              labelText: labelText,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none, // 正常状态下无边框
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            obscureText: obscureText,
            keyboardType: keyboardType,
          ),
        ),
        if (errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 4, left: 16),
            child: Text(
              errorText,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  // 性别选择组件
  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '性别 *',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        Row(
          children: _genders.map((gender) {
            return Expanded(
              child: RadioListTile<int>(
                title: Text(gender['label']),
                value: gender['id'],
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                    _errors.remove('gender'); // 清除性别错误
                  });
                },
              ),
            );
          }).toList(),
        ),
        if (_errors['gender'] != null)
          Padding(
            padding: EdgeInsets.only(top: 4, left: 16),
            child: Text(
              _errors['gender']!,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
