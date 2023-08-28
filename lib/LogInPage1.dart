import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:village.wale/City.dart';
import 'package:village.wale/LoginPage2.dart';
import 'package:village.wale/Signup.dart';
import 'package:village.wale/persistance/api_repository.dart';
import 'package:village.wale/util/AppUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomeScreen.dart';

Color getColorPrimary() {
  return getColorFromHex("#286953");
}

class LoginScreen1 extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen1> {
  var greencolor = const Color(0XFF286953);

  @override
  void initState() {
    // initApp();

    super.initState();
    getToken();
  }

  String _token = "";
  //String? mobile;
  final fcmToken = FirebaseMessaging.instance.getToken();
  String dialCodDigits = "+91";

  final _mobileController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage(
                "images/Group1.png",
              ),
              fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 59,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text("Don’t have an account?",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500)),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: SignupPage()));
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) => const SignupPage()));
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: greencolor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 22),
                      child: Image.asset("images/Login1.png"),
                    ),
                    const SizedBox(
                      height: 46,
                    ),
                    const Text("Login to continue shopping",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 24,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text("Enter mobile number to login via OTP ",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 15,
                            fontWeight: FontWeight.w400)),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                        height: 50,
                        width: double.infinity,
                        child: TextField(
                            maxLength: 10,
                            controller: _mobileController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              counterText: "",
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.green),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.green),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              floatingLabelStyle: TextStyle(
                                  fontFamily: "Poppins",
                                  color: getColorPrimary()),
                              filled: true,
                              fillColor: const Color(0xffEFF1F4),
                              prefixIcon: Icon(
                                Icons.call,
                                color: getColorFromHex("#9D9FA2"),
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.green),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: "Enter Mobile Number",
                              hintStyle: TextStyle(
                                fontFamily: "Poppins",
                                color: getColorPrimary(),
                                fontSize: 13,
                              ),
                            ))),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                !_isLoading
                    ? SizedBox(
                        height: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                primary: greencolor),
                            onPressed: () {
                              callApi();
                              // getFcmToken();
                              getToken();
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => LoginPage2(
                              //         _mobileController.toString())));
                            },
                            child: const SizedBox(
                                width: double.infinity,
                                child: Text(
                                  "Login to Continue",
                                  textAlign: TextAlign.center,
                                ))),
                      )
                    : Center(
                        child: CircularProgressIndicator(
                          backgroundColor: greencolor,
                        ),
                      ),
                const SizedBox(
                  height: 20,
                ),
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
      _token = value.toString();
      print("===>TOKEN==>" + token.toString());
    });
  }

  void callApi() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    if (_mobileController.text.isEmpty) {
      showCustomToast("Please Enter Mobile Number");
      return;
    }

    if (_mobileController.text.length > 10) {
      showCustomToast("Please Enter Valid Mobile Number");
      return;
    }

    setState(() {
      _isLoading = true;
    });
    var api = APICallRepository();
    api.login(_mobileController.text, _token).then((value) {
      setState(() {
        _isLoading = false;
        var json = jsonDecode(value.toString());
        String message = json["message"];

        if (message == "User Found") {
          String email = json["gmail"];
          String image = json["image"];
          String id = json["id"];
          String mobile = json["mobile_no"];
          String Name = json["name"];

          _prefs.setString("email", email);
          _prefs.setString("image", image);
          _prefs.setString("id", id);
          _prefs.setString("mobile", mobile);
          _prefs.setString("name", Name);

          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: LoginPage2(mobile, dialCodDigits)));
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => LoginPage2(mobile, dialCodDigits)));

          print(mobile);
        }

        if (message == "User Not Found") {
          showCustomToast("User Not Found Please Register");
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade, child: SignupPage()));
          // Navigator.of(context).push(
          //     MaterialPageRoute(builder: (context) => const SignupPage()));
        }
      });
    }, onError: (error) {
      setState(() {
        _isLoading = false;
        showCustomToast(error.toString());
      });
    });
  }

  void initApp() async {
    await Firebase.initializeApp().whenComplete(() {
      print("===>COMPLETE=>" + Firebase.app().name.toString());
    });
  }

  // void getFcmToken() async {
  //   var firebaseMessaging = FirebaseMessaging.instance;
  //   firebaseMessaging.getToken().then((value) {
  //     print("==>Token==>" + value.toString());
  //   });
  // }
}
