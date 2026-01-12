import 'package:flutter/material.dart';
import 'package:flutter_live_house/core/themes/app_theme.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        // SizedBox(height: MediaQuery.of(context).padding.top + 8),
        Container(
          color: AppTheme.primaryColor,
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage('assets/images/icon_nfgqaoquyp/bg-image2.jpg'),
          //     fit: BoxFit.cover,
          //   ),
          // ),
          height: 200,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(children: [Spacer(), Icon(Icons.settings, size: 24)]),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/login');
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        child: Text('A', style: AppTheme.customHeadline4),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('用户名', style: AppTheme.customHeadline2),
                          Text('用户邮箱', style: AppTheme.customSubtitle1),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 50),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.favorite, color: AppTheme.primaryColor),
                  title: Text('我的收藏', style: AppTheme.customHeadline6),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.history, color: AppTheme.primaryColor),
                  title: Text('观看历史', style: AppTheme.customHeadline6),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.settings, color: AppTheme.primaryColor),
                  title: Text('设置', style: AppTheme.customHeadline6),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 64),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 45,
          child: ElevatedButton(onPressed: () => {}, child: Text('安全退出')),
        ),
      ],
    );
  }
}
