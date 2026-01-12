import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // 添加这行
import 'package:geocoding/geocoding.dart'; // 添加这行
import '../core/themes/app_theme.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(),
        Expanded(child: _MainPage()),
      ],
    );
  }
}

class _Header extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HeaderState();
  }
}

class _HeaderState extends State<_Header> {
  String _location = '上海';
  final TextEditingController searchController = TextEditingController();
  String searchStr = '';
  bool _isLoadingLocation = false; // 添加加载状态

  void changeStr(String str) {
    setState(() {
      searchStr = str;
    });
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return; // 检查是否仍然挂载
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('位置服务未启用，请开启位置服务')));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (!mounted) return; // 检查是否仍然挂载
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('位置权限被拒绝')));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return; // 检查是否仍然挂载
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('位置权限被永久拒绝，请在设置中开启')));
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String currentCity =
            place.locality ?? place.administrativeArea ?? '未知位置';
        setState(() {
          _location = currentCity;
        });
      }
    } catch (e) {
      if (!mounted) return; // 检查是否仍然挂载
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('获取位置失败: $e')));
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.primaryColor,
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 8,
        16,
        20,
      ),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                onTap: _getCurrentLocation,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: _isLoadingLocation
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(Icons.location_on),
                ),
              ),
              Text(_location),
              Spacer(),
              InkWell(
                onTap: () => {},
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.message),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          SizedBox(
            height: 50,
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: '请输入搜索内容',
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.mic),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onChanged: changeStr,
            ),
          ),
        ],
      ),
    );
  }
}

class _MainGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double aspectRatio = 16 / 8;

    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        color: Colors.white,
        child: PageView(
          children: [
            PageView(children: [_buildIconGrid(0, 10), _buildIconGrid(10, 20)]),
          ],
        ),
      ),
    );
  }

  Widget _buildIconGrid(int startIndex, int endIndex) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 根据可用宽度计算图标尺寸
        double iconSize = constraints.maxWidth / 5 * 0.7; // 每行5个图标，取60%的宽度
        if (iconSize > 60) iconSize = 60; // 设置最大尺寸

        List<Map<String, String>> allIcons = [
          {'icon': 'assets/images/icon_nfgqaoquyp/maoyan.png', 'title': '电影'},
          {'icon': 'assets/images/icon_nfgqaoquyp/waimai.png', 'title': '外卖'},
          {'icon': 'assets/images/icon_nfgqaoquyp/lvyou.png', 'title': '旅游度假'},
          {'icon': 'assets/images/icon_nfgqaoquyp/shangou.png', 'title': '闪购'},
          {'icon': 'assets/images/icon_nfgqaoquyp/tuangou.png', 'title': '团购'},
          {
            'icon': 'assets/images/icon_nfgqaoquyp/jiudianminsu_1.png',
            'title': '酒店民宿',
          },
          {
            'icon': 'assets/images/icon_nfgqaoquyp/lishiwenhua.png',
            'title': '历史文化',
          },
          {'icon': 'assets/images/icon_nfgqaoquyp/yiliao.png', 'title': '医疗健康'},
          {'icon': 'assets/images/icon_nfgqaoquyp/zu.png', 'title': '洗浴汗蒸'},
          {
            'icon': 'assets/images/icon_nfgqaoquyp/ent-jingdianmenpiao.png',
            'title': '景点门票',
          },
          {
            'icon': 'assets/images/icon_nfgqaoquyp/jiudianminsu_1.png',
            'title': '酒店民宿',
          },
          {
            'icon': 'assets/images/icon_nfgqaoquyp/lishiwenhua.png',
            'title': '历史文化',
          },
          {'icon': 'assets/images/icon_nfgqaoquyp/yiliao.png', 'title': '医疗健康'},
          {'icon': 'assets/images/icon_nfgqaoquyp/zu.png', 'title': '洗浴汗蒸'},
          {
            'icon': 'assets/images/icon_nfgqaoquyp/ent-jingdianmenpiao.png',
            'title': '景点门票',
          },
        ];

        List<Map<String, String>> pageIcons = [];
        for (int i = startIndex; i < endIndex && i < allIcons.length; i++) {
          if (i < allIcons.length) {
            pageIcons.add(allIcons[i]);
          }
        }

        return GridView.count(
          crossAxisCount: 5,
          childAspectRatio: 0.8,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          padding: EdgeInsets.all(16),
          physics: NeverScrollableScrollPhysics(), // 禁用GridView滚动
          shrinkWrap: true, // 自适应高度
          children: pageIcons.map((item) {
            return IconBox(
              icon: item['icon']!,
              title: item['title']!,
              iconSize: iconSize,
            );
          }).toList(),
        );
      },
    );
  }
}

class IconBox extends StatelessWidget {
  final String icon;
  final String title;
  final double iconSize;

  const IconBox({
    super.key,
    required this.icon,
    required this.title,
    this.iconSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(icon, width: iconSize, height: iconSize),
        SizedBox(height: 5),
        Text(title),
      ],
    );
  }
}

class _MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<_MainPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _MainGrid()),
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Text('列表项目 ${index + 1}'),
            );
          }, childCount: 19),
        ),
      ],
    );
  }
}
