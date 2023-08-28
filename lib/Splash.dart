import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village.wale/HomeScreen.dart';
import 'package:village.wale/Model/ProfileModel.dart';
import 'package:village.wale/persistance/api_repository.dart';
import 'City.dart';
import 'LogInPage1.dart';

class Splash extends StatefulWidget {
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash1(),
    );
  }
}

class Splash1 extends StatefulWidget {
  const Splash1({Key? key}) : super(key: key);

  @override
  State<Splash1> createState() => _Splash1State();
}

class _Splash1State extends State<Splash1> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      checkCondition();
    });
    // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>), (route) => false)
    // checkCondition();
    print("====init state call==>");
    // checkCondition();
    initApp();
    // Firebase.initializeApp();
    // Timer(const Duration(seconds: 2),()=>checkCondition());
    // Timer(Duration(seconds: 2),()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>LoginScreen1())));
    super.initState();
  }

  void checkCondition() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? isLogin = sharedPreferences.getBool("isLogin");
    bool? isAddressAdd = sharedPreferences.getBool("isAddressAdd");

    print("===>IS LOGIN=>" + isLogin.toString());
    print("===>IS ADDRESS ADD=>" + isAddressAdd.toString());
    if (isLogin != null) {
      if (isLogin) {
        if (isAddressAdd != null) {
          if (isAddressAdd) {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade, child: MyHomeScreen()));
            // Navigator.of(context).push(
            //     MaterialPageRoute(builder: (context) => const MyHomeScreen()));
          } else {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade, child: CityPage()));
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (context) => CityPage()));
          }
        } else {
          Navigator.push(context,
              PageTransition(type: PageTransitionType.fade, child: CityPage()));
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (context) => CityPage()));
        }
      } else {
        Navigator.push(context,
            PageTransition(type: PageTransitionType.fade, child: CityPage()));
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => CityPage()));
      }
    } else {
      print("====LOGIN ELSE");
      Navigator.push(context,
          PageTransition(type: PageTransitionType.fade, child: LoginScreen1()));
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => LoginScreen1()));
    }
  }

  Future<void> initApp() async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage("images/Splash1.png"), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset("images/VillageLogo.png"),
            )
          ],
        ),
      ),
    );
  }
}
