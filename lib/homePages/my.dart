import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 8,
        16,
        20,
      ),
      child: Column(
        children: [
          Text('我的'),
          ElevatedButton(
            onPressed: () => {Navigator.of(context).pushNamed('/login')},
            child: Text('登陆'),
          ),
        ],
      ),
    );
  }
}
