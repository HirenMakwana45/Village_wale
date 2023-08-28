import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:village.wale/City.dart';
import 'package:village.wale/persistance/api_repository.dart';
import 'package:village.wale/util/AppUtil.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'HomeScreen.dart';
import 'LogInPage1.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  // @override
  // State<Signup> createState() => _SignupState();

  // @override
  // State<Signup> createState() => _SignupState();

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<SignupPage> {
  // void LoginAndSignup(String name,number,String email) async{
  //   try{
  //     Response response=await post(
  //       Uri.parse('https://mechodalgroup.xyz/VillageWale/api/user_register.php'),
  //       body: {
  //             'name':name,
  //             'number':number,
  //             'email':email
  //       }
  //     );
  //     if(response.statusCode==200){
  //       print("account created successfully");
  //     }else{
  //         print("failed");
  //     }
  //   }catch(e){
  //         print(e.toString());
  //   }
  // }

  bool _isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  var greencolor = const Color(0XFF286953);
  String _token = "";
  String? message;
  @override
  void initState() {
    getToken();

    super.initState();
  }

  void getToken() {
    FirebaseMessaging.instance.getToken().then((value) {
      String? token = value;
      _token = value.toString();
      print("===>TOKEN==>" + token.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Row(
            children: [
              const Text("Already have an account?",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
              TextButton(
                  onPressed: () {
                    // Navigate to  login page
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        color: greencolor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ))
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              Center(
                child: Container(
                  child: Image.asset(
                    "images/VillageLogo.png",
                    height: 100,
                  ),
                  margin: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              const Text("Create new account",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                height: 60,
                child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      floatingLabelStyle: TextStyle(
                          fontFamily: "Poppins", color: getColorPrimary()),
                      filled: true,
                      fillColor: const Color(0xffEFF1F4),
                      prefixIcon: Icon(Icons.person_outline,
                          color: getColorFromHex("#9D9FA2")),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xffAAAAAA)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: "Full Name*",
                      hintStyle: const TextStyle(
                        fontFamily: "Poppins",
                        color: Color(0xffAAAAAA),
                        fontSize: 13,
                      ),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 60,
                child: TextField(
                    maxLength: 10,
                    controller: mobileController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      counterText: "",
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      floatingLabelStyle: TextStyle(
                          fontFamily: "Poppins", color: getColorPrimary()),
                      filled: true,
                      fillColor: const Color(0xffEFF1F4),
                      prefixIcon: Icon(Icons.call_outlined,
                          color: getColorFromHex("#9D9FA2")),
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white12, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: "Enter Mobile Number*",
                      hintStyle: const TextStyle(
                        fontFamily: "Poppins",
                        color: Color(0xffAAAAAA),
                        fontSize: 13,
                      ),
                    )),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 60,
                child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      counterText: "",
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      floatingLabelStyle: TextStyle(
                          fontFamily: "Poppins", color: getColorPrimary()),
                      filled: true,
                      fillColor: const Color(0xffEFF1F4),
                      prefixIcon: Icon(
                        Icons.mail_outline,
                        color: getColorFromHex("#9D9FA2"),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xffAAAAAA)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: "Email Address",
                      hintStyle: const TextStyle(
                        fontFamily: "Poppins",
                        color: Color(0xffAAAAAA),
                        fontSize: 13,
                      ),
                    )),
              ),
              const SizedBox(
                height: 60,
              ),
              !_isLoading
                  ? SizedBox(
                      height: 45,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              primary: greencolor),
                          onPressed: () {
                            // LoginAndSignup(nameController.text.toString(),mobileController.text.toString(),emailController.text.toString());
                            // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CityPage()));
                            callApi();
                            if (nameController.text.toString() == "" ||
                                mobileController.text.toString() == "" ||
                                emailController.text.toString() == "") {
                              callApi();
                            }
                          },
                          child: const SizedBox(
                              width: double.infinity,
                              child: Text(
                                "Submit",
                                textAlign: TextAlign.center,
                              ))),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        backgroundColor: greencolor,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  callApi() {
    if (nameController.text.isEmpty) {
      showCustomToast("Please Enter Name");
      return;
    }
    if (mobileController.text.isEmpty) {
      showCustomToast("Please Enter Mobile Number");
      return;
    }
    if (mobileController.text.length > 10) {
      showCustomToast("Please Enter Correct Mobile Number");
      return;
    }

    if (emailController.text.isEmpty) {
      showCustomToast("Please Enter Email");
      return;
    }
    if (isEmail(emailController.text) == false) {
      showCustomToast("Please Enter Valid email");
      return;
    }

    setState(() {
      _isLoading = true;
    });
    var api = APICallRepository();
    api
        .signUp(nameController.text, mobileController.text,
            emailController.text, "referCode", _token)
        .then((value) {
      setState(() {
        _isLoading = false;
        var json = jsonDecode(value.toString());
        message = json["message"];
        showCustomToast(message.toString());
      });
      if (message == 'User registered Successfully') {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade, child: LoginScreen1()));
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => LoginScreen1()));
      }
      if (message == 'User Already registered') {}
      Navigator.push(context,
          PageTransition(type: PageTransitionType.fade, child: LoginScreen1()));
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => LoginScreen1()));
    }, onError: (error) {
      setState(() {
        showCustomToast(error.toString());
        print("==>error=>" + error.toString());
      });
    });
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }
}
