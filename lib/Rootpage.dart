import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:village.wale/HomeScreen.dart';
import 'package:village.wale/MyProfile.dart';
import 'package:village.wale/Notification.dart';
import 'package:village.wale/Wallet.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:village.wale/util/AppUtil.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int pageIndex = 0;

  List<Widget> pages = [
    MyHomeScreen(),
    Wallet(),
    Notifications(),
    My_Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.orange,
      body: getBody(),
      extendBody: true,
      bottomNavigationBar: getFooter(),
    );
  }

  getBody() {
    return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }

  Widget getFooter() {
    List<IconData> iconItems = [
      Icons.home_outlined,
      Icons.account_balance_wallet_outlined,
      Icons.notifications_none_outlined,
      Icons.person_outline,
    ];

    return AnimatedBottomNavigationBar(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      activeColor: const Color(0XFF286953),
      splashColor: const Color(0XFF286953),
      inactiveColor: Colors.grey,
      icons: iconItems,
      shadow: const BoxShadow(
          color: Colors.black38, spreadRadius: 0, blurRadius: 10),
      activeIndex: pageIndex,
      gapLocation: GapLocation.none,
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 30,
      iconSize: 24,
      rightCornerRadius: 30,
      onTap: (index) {
        selectedTab(index);
      },
      //other params
    );
  }

  selectedTab(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
