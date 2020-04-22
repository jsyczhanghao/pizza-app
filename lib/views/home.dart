import 'package:flutter/material.dart';
import '../libs/mini/index.dart' as mini;
import '../data/index.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    //设置小程序退出后返回的页面路由
    mini.setExitRoute('home');
  }

  go2mini(Map info) {
    Navigator.of(context).push(
      PageRouteBuilder(pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation),
          child: mini.MiniPage(
            id: info['id'],
            name: info['name'],
            image: info['image']
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('小程序引擎演示'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: PROGRAMS.map((Map item) {
            return FlatButton(
              onPressed: () => go2mini(item),
              child: Text(item['name']),
            );
          }).toList(),
        ),
      ),
    );
  }
}
