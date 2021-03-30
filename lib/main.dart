import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBarView.dart';
import 'package:motion_tab_bar/MotionTabController.dart';
import 'package:motion_tab_bar/motiontabbar.dart';
import 'package:used_market_app_ex/add_page.dart';
import 'package:used_market_app_ex/home_page.dart';
import 'package:used_market_app_ex/purchase_list.dart';

void main() {
  runApp(MyApp());
}
//만공거 = 만나서 공정한 거래

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Motion Tab Bar Sample',
      theme:
          ThemeData(appBarTheme: AppBarTheme(color: const Color(0xffaee1e1))),
      home: MyHomePage(title: '만나서 공정한 거래'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  MotionTabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = MotionTabController(initialIndex: 1, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        bottomNavigationBar: MotionTabBar(
          labels: ["작성", "홈", "구매목록"],
          initialSelectedTab: "홈",
          tabIconColor: const Color(0xffd3e0dc),
          tabSelectedColor: const Color(0xffaee1e1),
          onTabItemSelected: (int value) {
            print(value);
            setState(() {
              _tabController.index = value;
            });
          },
          icons: [Icons.add, Icons.home, Icons.pending_actions_sharp],
          textStyle: TextStyle(color: Colors.black),
        ),
        body: MotionTabBarView(
          controller: _tabController,
          children: <Widget>[AddPage(), HomePage(), ListPage()],
        ));
  }
}
