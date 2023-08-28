// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village.wale/persistance/api_repository.dart';
import 'City.dart';
import 'HomeScreen.dart';
import 'LogInPage1.dart';
import 'Model/ProfileModel.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await FlutterDownloader.initialize(debug: true, ignoreSsl: true);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Village Willa',
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    // getProfile();

    getToken();
    Future.delayed(const Duration(seconds: 3), () {
      // Do something
    });
    Timer(const Duration(seconds: 2), () {
      checkCondition();
    });
    super.initState();
  }

  void getProfile() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("id").toString();
    bool? _isLoing = sharedPreferences.getBool("isLogin");

    if (_isLoing != null) {
      if (_isLoing) {
        var api = APICallRepository();
        api.getProfile(id).then((value) {
          setState(() {
            print("==>RES=>" + value.toString());
            var model = ProfileModel.fromJson(jsonDecode(value));
            sharedPreferences.setString("name", model.name.toString());
            // checkCondition();
          });
        }, onError: (error) {
          // checkCondition();
        });
      } else {
        Navigator.pop(
            context,
            PageTransition(
                type: PageTransitionType.fade, child: LoginScreen1()));
        // Navigator.of(context)
        //     .pop(MaterialPageRoute(builder: (context) => LoginScreen1()));
      }
    } else {
      Navigator.pop(context,
          PageTransition(type: PageTransitionType.fade, child: LoginScreen1()));
      // Navigator.of(context)
      //     .pop(MaterialPageRoute(builder: (context) => LoginScreen1()));
    }
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
      // if(mounted){
      //
      // }
      Navigator.push(context,
          PageTransition(type: PageTransitionType.fade, child: LoginScreen1()));
      // Navigator.of(context, rootNavigator: true)
      //     .push(MaterialPageRoute(builder: (context) => LoginScreen1()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
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
                  child: Container(
                    child: Image.asset("images/VillageLogo.png"),
                    margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getToken() {
    FirebaseMessaging.instance.getToken().then((value) {
      String? token = value;
      print("===>TOKEN==>" + token.toString());
    });
  }
}
