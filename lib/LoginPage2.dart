import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village.wale/util/AppUtil.dart';
import 'City.dart';
import 'Signup.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage2 extends StatefulWidget {
  String mobile;
  final String codeDigits;

  LoginPage2(this.mobile, this.codeDigits, {Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage2> {
  var greencolor = const Color(0XFF286953);
  bool _isLoading = false;
  String _verificationId = "";
  String _code = "";
  String? varificationCode;

  @override
  void initState() {
    verifyPhoneNumber();
    phoneSignIn(phoneNumber: widget.mobile);
    setState(() {
      _isLoading = true;
    });
    super.initState();
  }

  Future<void> phoneSignIn({required String phoneNumber}) async {
    setState(() {
      _isLoading = true;
    });
    FirebaseAuth _auth = await FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: "+91" + phoneNumber,
        verificationCompleted: _onVerificationCompleted,
        verificationFailed: _onVerificationFailed,
        codeSent: _onCodeSent,
        codeAutoRetrievalTimeout: _onCodeTimeout);
    print(phoneNumber);
    print(_verificationId);
  }

  _onVerificationCompleted(PhoneAuthCredential authCredential) async {
    print("verification completed ${authCredential.smsCode}");
    User? user = FirebaseAuth.instance.currentUser;
    // setState(() {
    //   this.otpCode.text = authCredential.smsCode!;
    // });
    // if (authCredential.smsCode != null) {
    //   try{
    //     UserCredential credential =
    //     await user!.linkWithCredential(authCredential);
    //   }on FirebaseAuthException catch(e){
    //     if(e.code == 'provider-already-linked'){
    //       await _auth.signInWithCredential(authCredential);
    //     }
    //   }
    //   // setState(() {
    //   //   isLoading = false;
    //   // });
    //   // Navigator.pushNamedAndRemoveUntil(
    //   //     context, Constants.homeNavigate, (route) => false);
    // }
  }

  _onVerificationFailed(FirebaseAuthException exception) {
    print("====>ERROR==>" + exception.message!);
    if (exception.code == 'invalid-phone-number') {
      showCustomToast("The phone number entered is invalid!");
    }
  }

  _onCodeSent(String verificationId, int? forceResendingToken) {
    _verificationId = verificationId;
    print(forceResendingToken);
    showCustomToast("code sent on registered mobile number");
    setState(() {
      _isLoading = false;
    });
  }

  _onCodeTimeout(String timeout) {
    return null;
  }

  void verifyOtp() {
    if (_code.length != 5) {
      setState(() {
        _isLoading = false;
      });
      setState(() {
        showCustomToast("OTP Verify Successfully..");
        Navigator.push(context,
            PageTransition(type: PageTransitionType.fade, child: CityPage()));
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => CityPage()));
        showCustomToast("Please Enter OTP");
        _isLoading = false;
      });

      try {
        FirebaseAuth _auth = FirebaseAuth.instance;
        final AuthCredential credential = PhoneAuthProvider.credential(
            verificationId: _verificationId, smsCode: _code);
        print("************");

        print(_auth);
        print(_code);
        print(_verificationId);
        // print("VERIFY==>"+credential.token.toString());
        _auth.signInWithCredential(credential).then((value) {
          print("PASS==>" + value.toString());
          setState(() {
            showCustomToast("OTP Verify Successfully..");
            callApi();
            _isLoading = false;
          });
        }, onError: (error) {
          setState(() {
            _isLoading = false;
          });
          print("ERROR==>" + error.toString());

          showCustomToast("Session Expire PLs Resend OTP..");
        });
        // showCustomToast("===>VERIFY==>"+credential.signInMethod.toString());
      } catch (e) {
        showCustomToast("EXCEPTION==>" + e.toString());
      }
    } else {
      Navigator.push(context,
          PageTransition(type: PageTransitionType.fade, child: CityPage()));
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => CityPage()));
      showCustomToast("Please Enter OTP");
    }
  }

  verifyPhoneNumber() async {
    //var _code;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "${widget.codeDigits + widget.mobile}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) {
          if (value.user != null) {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade, child: CityPage()));
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (c) => CityPage()));
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message.toString()),
          duration: const Duration(seconds: 3),
        ));
      },
      codeSent: (String vID, int? resendToken) {
        setState(() {
          varificationCode = vID;
        });
      },
      codeAutoRetrievalTimeout: (String vID) {
        setState(() {
          varificationCode = vID;
        });
      },
      timeout: const Duration(seconds: 60),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
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
                  height: 70,
                ),
                Center(
                  child: Container(
                    child: Image.asset(
                      "images/VillageLogo.png",
                      height: 100,
                    ),
                    margin: const EdgeInsets.fromLTRB(30, 0, 50, 0),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),

                Container(
                  child: const Text(
                    "Verify your number",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                ),
                const SizedBox(
                  height: 13,
                ),
                Container(
                  child: Text(
                    "Please enter OTP sent on number " +
                        widget.mobile.toString(),
                    style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                ),
                const SizedBox(
                  height: 30,
                ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Container(
                //       margin: EdgeInsets.only(right: 5),
                //       child: SizedBox(
                //         width: 38,
                //         child: TextFormField(
                //           onSaved: (pin1){},
                //           onChanged: (value){
                //             if(value.length == 1){
                //               FocusScope.of(context).nextFocus();
                //             }
                //           },
                //           style: Theme.of(context).textTheme.headline6,
                //           decoration: const InputDecoration(
                //             fillColor: Colors.white,
                //             filled: true,
                //           ),
                //           keyboardType: TextInputType.number,
                //           textAlign: TextAlign.center,
                //           inputFormatters: [
                //             LengthLimitingTextInputFormatter(1),
                //             FilteringTextInputFormatter.digitsOnly,
                //           ],
                //         ),
                //       ),
                //     ),
                //     Container(
                //       margin: EdgeInsets.only(right: 5),
                //       child: SizedBox(
                //         width: 38,
                //         child: TextFormField(
                //           onSaved: (pin1){},
                //           onChanged: (value){
                //             if(value.length == 1){
                //               FocusScope.of(context).nextFocus();
                //             }
                //           },
                //           style: Theme.of(context).textTheme.headline6,
                //           decoration: const InputDecoration(
                //             fillColor: Colors.white,
                //             filled: true,
                //           ),
                //           keyboardType: TextInputType.number,
                //           textAlign: TextAlign.center,
                //           inputFormatters: [
                //             LengthLimitingTextInputFormatter(1),
                //             FilteringTextInputFormatter.digitsOnly,
                //           ],
                //         ),
                //       ),
                //     ),
                //     Container(
                //       margin: EdgeInsets.only(right: 5),
                //       child: SizedBox(
                //         width: 38,
                //         child: TextFormField(
                //           onSaved: (pin1){},
                //           onChanged: (value){
                //             if(value.length == 1){
                //               FocusScope.of(context).nextFocus();
                //             }
                //           },
                //           style: Theme.of(context).textTheme.headline6,
                //           decoration: const InputDecoration(
                //             fillColor: Colors.white,
                //             filled: true,
                //           ),
                //           keyboardType: TextInputType.number,
                //           textAlign: TextAlign.center,
                //           inputFormatters: [
                //             LengthLimitingTextInputFormatter(1),
                //             FilteringTextInputFormatter.digitsOnly,
                //           ],
                //         ),
                //       ),
                //     ),
                //     Container(
                //       margin: EdgeInsets.only(right: 5),
                //       child: SizedBox(
                //         width: 38,
                //         child: TextFormField(
                //           onSaved: (pin1){},
                //           onChanged: (value){
                //             if(value.length == 1){
                //               FocusScope.of(context).nextFocus();
                //             }
                //           },
                //           style: Theme.of(context).textTheme.headline6,
                //           decoration: const InputDecoration(
                //             fillColor: Colors.white,
                //             filled: true,
                //           ),
                //           keyboardType: TextInputType.number,
                //           textAlign: TextAlign.center,
                //           inputFormatters: [
                //             LengthLimitingTextInputFormatter(1),
                //             FilteringTextInputFormatter.digitsOnly,
                //           ],
                //         ),
                //       ),
                //     ),
                //   ],
                // ),

                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Pinput(
                    submittedPinTheme: PinTheme(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: greencolor),
                            borderRadius: BorderRadius.circular(10))),
                    focusedPinTheme: PinTheme(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: greencolor),
                            borderRadius: BorderRadius.circular(10))),
                    defaultPinTheme: PinTheme(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: greencolor),
                            borderRadius: BorderRadius.circular(10))),
                    length: 6,

                    // onCompleted: (pin) {
                    //   setState(() {
                    //     _code = pin;
                    //   });
                    // },

                    onCompleted: (pin) async {
                      try {
                        await FirebaseAuth.instance
                            .signInWithCredential(PhoneAuthProvider.credential(
                                verificationId: varificationCode!,
                                smsCode: pin))
                            .then((value) {
                          if (value.user != null) {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child: CityPage()));
                            // Navigator.of(context).push(
                            //     MaterialPageRoute(builder: (c) => CityPage()));
                          }
                        });
                      } catch (e) {
                        FocusScope.of(context).unfocus();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Invalid OTP"),
                          duration: Duration(seconds: 3),
                        ));
                      }
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Center(
                      child: GestureDetector(
                    onTap: () {
                      verifyPhoneNumber();
                    },
                    child: Text(
                      "Verifying : ${widget.codeDigits} ${widget.mobile}",
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  )),
                ),
                const SizedBox(
                  height: 60,
                ),

                _isLoading
                    ? SizedBox(
                        height: 60,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                primary: greencolor),
                            onPressed: () {
                              // verifyOtp();
                              callApi();
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => CityPage()));
                            },
                            child: const SizedBox(
                                width: double.infinity,
                                child: Text(
                                  "Verify & Sign In",
                                  textAlign: TextAlign.center,
                                ))),
                      )
                    : Center(
                        child: getProgressBar(),
                      ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    phoneSignIn(phoneNumber: widget.mobile);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Did not get OTP?",
                        style: TextStyle(
                            fontFamily: "Poppins", color: Color(0xff9D9FA2)),
                      ),
                      TextButton(
                          onPressed: () {
                            phoneSignIn(phoneNumber: widget.mobile);
                          },
                          child: Text(
                            "Resend",
                            style: TextStyle(
                                fontFamily: "Poppins", color: greencolor),
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void callApi() async {
    print("TAP==>");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isLogin", true);
    Navigator.push(context,
        PageTransition(type: PageTransitionType.fade, child: CityPage()));
    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => CityPage()));
  }
}
