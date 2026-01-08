import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: IndexedStack(
          index: _currentIndex,
          children: [
            Center(child: Home()),
            Center(child: Text('发现')),
            Center(child: Text('购物车')),
            Center(child: Text('我的')),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed, // 固定类型，显示多个标签
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: '发现'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: '购物车'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
        ],
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  String _position = '北京';
  String _seaStr = '';
  TextEditingController searchController() {
    return TextEditingController();
  }

  void changeSearchStr(String value) {
    setState(() {
      _seaStr = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(children: [Text(_position), Icon(Icons.map)]),
          TextField(
            controller: searchController(),
            decoration: InputDecoration(
              hintText: '请输入搜索内容',
              fillColor: Colors.black12,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              prefixIcon: Icon(Icons.search),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
            ),
            onChanged: (value) => changeSearchStr(value),
          ),
        ],
      ),
    );
  }
}
