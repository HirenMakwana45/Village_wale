// import 'dart:convert';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:page_transition/page_transition.dart';
// // import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';
// // import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';
// // import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';
// // import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:village.wale/Cart2.dart';
// import 'package:village.wale/Model/ProfileModel.dart';
// import 'package:village.wale/payutest.dart';
// import 'package:village.wale/persistance/api_repository.dart';
// import 'package:village.wale/util/AppUtil.dart';
// import 'package:village.wale/Model/CartModel.dart' as model;
// import 'Cart.dart';
// import 'HomeScreen.dart';
// import 'MyProfile.dart';
// import 'Notification.dart';
// import 'SplashMondeyAdded.dart';
// import 'TransactionHistory.dart';
// // import 'package:payumoney_pro_unofficial/payumoney_pro_unofficial.dart';
// import 'package:convert/convert.dart';
// import 'package:crypto/crypto.dart';

// class Wallet extends StatefulWidget {
//   const Wallet({Key? key}) : super(key: key);

//   @override
//   State<Wallet> createState() => _WalletState();
// }

// class _WalletState extends State<Wallet> {
//   final TextEditingController _controller = TextEditingController();
//   List<model.Cart>? cartlist = [];
//   List<model.SubscriptionCart> cartsubscribeList = [];
//   // Razorpay _razorpay = Razorpay();
//   String id = "";
//   int walletAmount = 0;
//   bool _isLoading = false;
//   bool _isPaymentProcess = false;
//   int selectedAmount = 0;
//   List<String> amountList = [];
//   String name = "";
//   String email = "";
//   String number = "";
//   String image = "";
//   String Merchantsalt = "I5SzoJDrdd8rUsweWjJo9ySV0PRHjkBX";

//   String t_id = DateTime.now().millisecondsSinceEpoch.toString();

//   @override
//   void initState() {
//     getuserId();
//     setState(() {});

//     setState(() {
//       // _checkoutPro = PayUCheckoutProFlutter(_checkoutPro!.delegate!);

//       // _checkoutPro = PayUCheckoutProFlutter(protocol!.delegate!);

//       // _checkoutPro = PayUCheckoutProFlutter(_checkoutPro.delegate!);
//     });

//     print("===>INIT STATE CALLL");

//     // _razorpay = Razorpay();
//     // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

//     _controller.text = "100";

//     amountList.add("100");
//     amountList.add("200");
//     amountList.add("500");
//     amountList.add("1000");
//     amountList.add("2000");

//     super.initState();
//   }

//   // Future<void> initializePayment() async {
//   //   final response = await PayumoneyProUnofficial.payUParams(
//   //       email: email,
//   //       firstName: name,
//   //       merchantName: 'Villagewale',
//   //       isProduction: false,
//   //       merchantKey: 'gFHRTP',
//   //       merchantSalt: Merchantsalt,
//   //       amount: int.parse(_controller.text).toString(),
//   //       hashUrl:
//   //           'c972d3540751fd64f9654c0fcca0da253edc01cda2dbc7f718850ee832f019d438cb75f7e2b25c1d998beb2ddcf6f53057053ba2aef44c6d7cb0932930f73727',

//   //       // 'ffcdbf04fa5beefdcc2dd476c18bc410f02b3968e7f4f54e8f43f1e1a310bb32e3b4dec9305232bb89db5b1d0c009a53bcace6f4bd8ec2f695baf3d43ba730ce', //nodejs code is included. Host the code and update its url here.

//   //       productInfo: 'Money Add to Wallet',
//   //       transactionId: t_id,
//   //       showExitConfirmation: true,
//   //       showLogs: true, // true for debugging, false for production

//   //       userCredentials: 'gFHRTP' + email,
//   //       userPhoneNumber: number);

//   //   if (response['status'] == PayUParams.success) handlePaymentSuccess();

//   //   print(response);

//   //   if (response['status'] == PayUParams.failed)
//   //     handlePaymentFailure(response['message']);

//   //   setState(() {
//   //     _isPaymentProcess = false;
//   //   });
//   // }

//   handlePaymentSuccess() {
//     //Implement Your Success Logic
//     var api = APICallRepository();
//     api
//         .addUserTransation(
//             id, _controller.text, "", "Success", "Money Add to Wallet")
//         .then((value) {
//       setState(() {
//         _isPaymentProcess = false;
//       });
//       var json = jsonDecode(value.toString());
//       var message = json["message"];
//       if (message == "Transaction Added") {
//         walletAmount = walletAmount + int.parse(_controller.text);
//         print(walletAmount);
//         showCustomToast("Money Added Successfully");
//         Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(
//                 builder: (context) => const Money_Add_Succesffuly()),
//             (route) => false);
//         _controller.text = "";
//       }
//     }, onError: (error) {
//       setState(() {
//         _isPaymentProcess = false;
//       });
//       showCustomToast(error.toString());
//     });
//   }

//   handlePaymentFailure(String errorMessage) {
//     //Implement Your Failed Payment Logic
//     var api = APICallRepository();
//     api
//         .addUserTransation(
//             id, _controller.text, "", "Failed", "Money Add to Wallet")
//         .then((value) {
//       setState(() {
//         _isPaymentProcess = false;
//       });
//       showCustomToast("Payment Failed");
//     }, onError: (error) {
//       setState(() {
//         _isPaymentProcess = false;
//       });
//       showCustomToast(error.toString());
//     });
//     print(errorMessage);
//   }

//   // @override
//   // onPaymentSuccess(dynamic response) async {
//   //   SharedPreferences _prefs = await SharedPreferences.getInstance();
//   //   String id = _prefs.getString("id").toString();
//   //   setState(() {
//   //     _isLoading = true;
//   //   });

//   //   // print("===>" + id);
//   //   // print("===>" + widget._productId);
//   //   // print("===>" + widget.quentity.toString());
//   //   // print("===>" + widget.normalPrice);
//   //   // var api = APICallRepository();
//   //   // api
//   //   //     .addOrder(
//   //   //         id,

//   //   //         // widget._productId,
//   //   //         // widget.quentity.toString(),
//   //   //         // widget.normalPrice,
//   //   //         // "online",
//   //   //         // widget.productVolume,
//   //   //         widget.model,
//   //   //         C_id)
//   //   //     .then((value) {
//   //   //   var json = jsonDecode(value);
//   //   //   String message = json["messaage"];
//   //   //   showCustomToast(message);
//   //   //   setState(() {
//   //   //     _isLoading = false;
//   //   //   });
//   //   //   Navigator.push(
//   //   //       context,
//   //   //       PageTransition(
//   //   //           type: PageTransitionType.fade, child: const MyHomeScreen()));
//   //   //   // Navigator.of(context)
//   //   //   //     .push(MaterialPageRoute(builder: (context) => const MyHomeScreen()));
//   //   // }, onError: (error) {
//   //   //   setState(() {
//   //   //     _isLoading = false;
//   //   //   });
//   //   //   showCustomToast(error.toString());
//   //   // });
//   //   showAlertDialog(context, "onPaymentSuccess", response.toString());
//   // }

//   // @override
//   // onPaymentFailure(dynamic response) {
//   //   showAlertDialog(context, "onPaymentFailure", response.toString());
//   // }

//   // @override
//   // onPaymentCancel(Map? response) {
//   //   showAlertDialog(context, "onPaymentCancel", response.toString());
//   // }

//   // @override
//   // onError(Map? response) {
//   //   showAlertDialog(context, "onError", response.toString());
//   // }

//   // openCheckout() {
//   //   setState(() {
//   //     print("Checkout Clicking");
//   //     print("CheckoutPro" + _checkoutPro.toString());
//   //     // print("CheckoutPro delegate" + _checkoutPro!.delegate.toString());
//   //     // _checkoutPro = PayUCheckoutProFlutter(_checkoutPro.delegate!);

//   //     _checkoutPro?.openCheckoutScreen(
//   //       payUPaymentParams: payUPaymentParams,
//   //       payUCheckoutProConfig: payUPaymentParams,
//   //     );
//   //   });

//   //   // _checkoutPro.openCheckoutScreen(
//   //   //   payUPaymentParams:
//   //   //       PayUParams.createPayUPaymentParams(walletAmount.toString()),
//   //   //   payUCheckoutProConfig: PayUParams.createPayUConfigParams(),
//   //   // );
//   // }

//   void getuserId() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     id = sharedPreferences.getString("id").toString();

//     setState(() {
//       _isLoading = true;
//     });
//     var api = APICallRepository();
//     api.getProfile(id).then((value) {
//       var model = ProfileModel.fromJson(jsonDecode(value));
//       setState(() {
//         walletAmount = int.parse(model.wallet!);
//         setState(() {
//           name = model.name.toString();
//           email = model.gmail.toString();
//           image = model.image.toString();

//           number = model.mobileNo.toString();
//           _isLoading = false;
//         });
//       });
//     }, onError: (error) {
//       setState(() {
//         _isLoading = false;
//       });
//     });
//   }

//   // void _handlePaymentSuccess(PaymentSuccessResponse response) {
//   //   var api = APICallRepository();
//   //   api
//   //       .addUserTransation(
//   //           id, _controller.text, "", "Success", "Money Add to Wallet")
//   //       .then((value) {
//   //     setState(() {
//   //       _isPaymentProcess = false;
//   //     });
//   //     var json = jsonDecode(value.toString());
//   //     var message = json["message"];
//   //     if (message == "Transaction Added") {
//   //       walletAmount = walletAmount + int.parse(_controller.text);
//   //       print(walletAmount);
//   //       showCustomToast("Money Added Successfully");
//   //       Navigator.of(context).pushAndRemoveUntil(
//   //           MaterialPageRoute(
//   //               builder: (context) => const Money_Add_Succesffuly()),
//   //           (route) => false);
//   //       _controller.text = "";
//   //     }
//   //   }, onError: (error) {
//   //     setState(() {
//   //       _isPaymentProcess = false;
//   //     });
//   //     showCustomToast(error.toString());
//   //   });
//   // }

//   // void _handlePaymentError(PaymentFailureResponse response) {
//   //   var api = APICallRepository();
//   //   api
//   //       .addUserTransation(
//   //           id, _controller.text, "", "Failed", "Money Add to Wallet")
//   //       .then((value) {
//   //     setState(() {
//   //       _isPaymentProcess = false;
//   //     });
//   //     showCustomToast("Payment Failed");
//   //   }, onError: (error) {
//   //     setState(() {
//   //       _isPaymentProcess = false;
//   //     });
//   //     showCustomToast(error.toString());
//   //   });
//   // }

//   // void _handleExternalWallet(ExternalWalletResponse response) {
//   //   setState(() {
//   //     _isPaymentProcess = false;
//   //   });
//   // }

//   // void openCheckout() async {
//   //   var options = {
//   //     'key': 'rzp_test_NNbwJ9tmM0fbxj',
//   //     'amount': int.parse(_controller.text) * 100,
//   //     'description': 'Payment',
//   //     'external': {
//   //       'wallets': ['paytm']
//   //     }
//   //   };

//   //   try {
//   //     // _razorpay.open(options);
//   //   } catch (e) {
//   //     debugPrint(e.toString());
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Builder(builder: (context) {
//         return Scaffold(
//           bottomNavigationBar: Container(
//             decoration: const BoxDecoration(
//               borderRadius: BorderRadius.only(
//                   topRight: Radius.circular(30), topLeft: Radius.circular(30)),
//               boxShadow: [
//                 BoxShadow(
//                     color: Colors.black38, spreadRadius: 0, blurRadius: 10),
//               ],
//             ),
//             child: ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(30.0),
//                 topRight: Radius.circular(30.0),
//               ),
//               child: BottomNavigationBar(
//                 currentIndex: 1,
//                 elevation: 40,
//                 type: BottomNavigationBarType.fixed,
//                 selectedItemColor: const Color(0XFF286953),
//                 unselectedItemColor: Colors.grey,
//                 selectedFontSize: 0,
//                 unselectedFontSize: 0,
//                 onTap: (value) {
//                   if (value == 0) {
//                     Navigator.push(
//                         context,
//                         PageTransition(
//                             type: PageTransitionType.fade,
//                             child: const MyHomeScreen()));
//                     // Navigator.of(context).push(MaterialPageRoute(
//                     //     builder: (context) => const MyHomeScreen()));
//                   }
//                   if (value == 1) {}
//                   if (value == 2) {
//                     Navigator.push(
//                         context,
//                         PageTransition(
//                             type: PageTransitionType.fade,
//                             child: const Notifications()));
//                     // Navigator.of(context).push(MaterialPageRoute(
//                     //     builder: (context) => const Notifications()));
//                   }
//                   if (value == 3) {
//                     Navigator.push(
//                         context,
//                         PageTransition(
//                             type: PageTransitionType.fade,
//                             child: const My_Profile()));
//                     // Navigator.of(context).push(MaterialPageRoute(
//                     //     builder: (context) => const My_Profile()));
//                   }
//                 },
//                 items: const [
//                   BottomNavigationBarItem(
//                     backgroundColor: Colors.black,
//                     icon: Icon(
//                       Icons.home_outlined,
//                     ),
//                     label: "",
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(
//                       Icons.account_balance_wallet_outlined,
//                     ),
//                     label: "",
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(
//                       Icons.notifications_none_outlined,
//                     ),
//                     label: "",
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(
//                       Icons.person_outline,
//                     ),
//                     label: "",
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           drawer: Drawer(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   const MyHeaderDrawer(),
//                   Container(
//                     height: 1,
//                     width: double.infinity,
//                     color: Colors.black12,
//                   ),
//                   const MyDrawerList()
//                 ],
//               ),
//             ),
//           ),
//           body: !_isLoading
//               ? Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(
//                           height: 30,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 Builder(
//                                   builder: (context) {
//                                     return IconButton(
//                                         iconSize: 70,
//                                         onPressed: () {
//                                           Scaffold.of(context).openDrawer();
//                                         },
//                                         tooltip:
//                                             MaterialLocalizations.of(context)
//                                                 .openAppDrawerTooltip,
//                                         icon: Image.asset(
//                                           "images/Frame1.png",
//                                         ));
//                                   },
//                                 ),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     const Text(
//                                       "Welcome",
//                                       style: TextStyle(
//                                           fontFamily: "Poppins",
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w400),
//                                       textAlign: TextAlign.start,
//                                     ),
//                                     Container(
//                                       alignment: Alignment.topLeft,
//                                       child: Text(
//                                         name.toString(),
//                                         style: const TextStyle(
//                                             fontFamily: "Poppins",
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             IconButton(
//                               iconSize: 70,
//                               onPressed: () {
//                                 Navigator.push(
//                                     context,
//                                     PageTransition(
//                                         type: PageTransitionType.fade,
//                                         child: Cart2(
//                                             cartlist, cartsubscribeList)));
//                                 // Navigator.of(context).push(MaterialPageRoute(
//                                 //     builder: (context) =>
//                                 //         Cart2(cartlist, cartsubscribeList)));
//                               },
//                               icon: Image.asset("images/Frame2.png"),
//                             ),
//                           ],
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(15.0),
//                           child: Container(
//                             color: const Color(0XffFFFFFF),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     const Padding(
//                                       padding: EdgeInsets.all(8.0),
//                                       child: Icon(
//                                         Icons.account_balance_wallet_outlined,
//                                         size: 35,
//                                       ),
//                                     ),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         const Text(
//                                           'Available Wallet Balance',
//                                           style: TextStyle(
//                                               fontFamily: "Poppins",
//                                               fontSize: 17),
//                                         ),
//                                         Row(
//                                           children: [
//                                             const Icon(Icons.currency_rupee,
//                                                 color: Color(0XFF286953)),
//                                             Text(
//                                               walletAmount.toString(),
//                                               style: const TextStyle(
//                                                   fontFamily: "Poppins",
//                                                   fontSize: 16,
//                                                   color: Color(0XFF286953)),
//                                             )
//                                           ],
//                                         )
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         const Padding(
//                           padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
//                           child: Text(
//                             'Add money',
//                             style: TextStyle(
//                                 fontFamily: "Poppins",
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
//                           child: Container(
//                             child: TextField(
//                               controller: _controller,
//                               decoration: InputDecoration(
//                                 prefixIcon: const Icon(
//                                     Icons.currency_rupee_outlined,
//                                     color: Color(0xff9D9FA1)),
//                                 border: OutlineInputBorder(
//                                     borderSide: const BorderSide(
//                                         color: Color(0xff9D9FA1), width: 1.0),
//                                     borderRadius: BorderRadius.circular(0)),
//                                 focusedBorder: OutlineInputBorder(
//                                     borderSide: const BorderSide(
//                                         color: Color(0xff9D9FA1), width: 1.0),
//                                     borderRadius: BorderRadius.circular(0)),
//                                 enabledBorder: OutlineInputBorder(
//                                     borderSide: const BorderSide(
//                                         color: Color(0xff9D9FA1), width: 1.0),
//                                     borderRadius: BorderRadius.circular(0)),
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 20,
//                         ),
//                         Container(
//                           margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
//                           height: 50,
//                           child: ListView.builder(
//                             itemBuilder: (context, index) =>
//                                 getAmountLayout(index),
//                             itemCount: amountList.length,
//                             scrollDirection: Axis.horizontal,
//                           ),
//                         ),
//                       ],
//                     ),
//                     !_isPaymentProcess
//                         ? Column(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 15.0),
//                                 child: SizedBox(
//                                   height: 45,
//                                   child: ElevatedButton(
//                                       style: ElevatedButton.styleFrom(
//                                           shape: RoundedRectangleBorder(
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                           ),
//                                           primary: getColorFromHex("#286953")),
//                                       onPressed: () {
//                                         setState(() {
//                                           _isPaymentProcess = true;
//                                         });

//                                         if (_controller.text != "0") {
//                                           // initializePayment();
//                                           // openCheckout();
//                                         } else {
//                                           showCustomToast(
//                                               "Please select Amount");
//                                         }
//                                       },
//                                       child: const SizedBox(
//                                           width: double.infinity,
//                                           child: Text(
//                                             "Proceed To Pay",
//                                             textAlign: TextAlign.center,
//                                           ))),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 height: 30,
//                               )
//                             ],
//                           )
//                         : Center(
//                             child: getProgressBar(),
//                           ),
//                   ],
//                 )
//               : Center(
//                   child: getProgressBar(),
//                 ),
//         );
//       }),
//     );
//   }

//   int select_index = 0;
//   Widget getAmountLayout(int index) {
//     return InkWell(
//       onTap: () {
//         setState(() {
//           _controller.text = amountList[index];

//           select_index = index;
//         });
//       },
//       child: Container(
//         margin: const EdgeInsets.only(right: 5),
//         decoration: ShapeDecoration(
//             color: index == select_index
//                 ? const Color(0XFF286953)
//                 : getColorFromHex("#e4ecd6"),
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20.0),
//                 side: const BorderSide(width: 1, color: Colors.transparent))),
//         child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               ButtonTheme(
//                 child: TextButton(
//                   onPressed: () {
//                     setState(() {
//                       _controller.text = amountList[index];
//                       select_index = index;
//                     });
//                   },
//                   style: ButtonStyle(
//                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                           RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20.0),
//                   ))),
//                   child: Text(
//                     amountList[index].toString(),
//                     style: const TextStyle(
//                         fontSize: 14,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             ]),
//       ),
//     );
//   }
// }

// class MyDrawerList extends StatefulWidget {
//   const MyDrawerList({Key? key}) : super(key: key);

//   @override
//   State<MyDrawerList> createState() => _MyDrawerListState();
// }

// class _MyDrawerListState extends State<MyDrawerList> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 30),
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       PageTransition(
//                           type: PageTransitionType.fade,
//                           child: const My_Profile()));
//                   // Navigator.of(context).push(MaterialPageRoute(
//                   //   builder: (context) => const My_Profile(),
//                   // ));
//                 },
//                 child: const Column(
//                   children: [
//                     Column(
//                       children: [
//                         Column(
//                           children: [
//                             Row(children: [
//                               Expanded(
//                                   child: Icon(
//                                 Icons.person,
//                                 size: 20,
//                                 color: Colors.black,
//                               )),
//                               Expanded(
//                                   flex: 3,
//                                   child: Text(
//                                     'My account',
//                                     style: TextStyle(
//                                         fontFamily: "Poppins", fontSize: 16),
//                                   )),
//                               Expanded(
//                                   child: Icon(
//                                 Icons.navigate_next,
//                                 size: 20,
//                                 color: Colors.black,
//                               )),
//                             ]),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // Padding(padding: EdgeInsets.only(top: 15),
//             //   child: GestureDetector(
//             //     onTap: () {
//             //       //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>My_Profile(),));
//             //     },
//             //     child: Row(
//             //         children: [
//             //           Expanded(child:
//             //           Icon(Icons.category_outlined,
//             //             size: 20,
//             //             color: Colors.black,
//             //           )
//             //           ),
//             //           Expanded(
//             //               flex: 3,
//             //               child:Text(
//             //                 'Shop by category',
//             //                 style: TextStyle(
//             //                     fontSize: 16
//             //                 ),
//             //               )
//             //           ),
//             //           Expanded(child:
//             //           Icon(Icons.navigate_next,
//             //             size: 20,
//             //             color: Colors.black,
//             //           )
//             //           ),
//             //
//             //         ]
//             //     ),
//             //   ),
//             //
//             // ),
//             Padding(
//               padding: const EdgeInsets.only(top: 30),
//               child: GestureDetector(
//                 onTap: () {
//                   //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>My_Profile(),));
//                 },
//                 child: const Row(children: [
//                   Expanded(
//                       child: Icon(
//                     Icons.subscriptions_outlined,
//                     size: 20,
//                     color: Colors.black,
//                   )),
//                   Expanded(
//                       flex: 3,
//                       child: Text(
//                         'My subscriptions',
//                         style: TextStyle(fontFamily: "Poppins", fontSize: 16),
//                       )),
//                   Expanded(
//                       child: Icon(
//                     Icons.navigate_next,
//                     size: 20,
//                     color: Colors.black,
//                   )),
//                 ]),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 30),
//               child: GestureDetector(
//                 onTap: () {
//                   //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>My_Profile(),));
//                 },
//                 child: const Row(children: [
//                   Expanded(
//                       child: Icon(
//                     Icons.wallet_giftcard_outlined,
//                     size: 20,
//                     color: Colors.black,
//                   )),
//                   Expanded(
//                       flex: 3,
//                       child: Text(
//                         'Refer & earn',
//                         style: TextStyle(fontFamily: "Poppins", fontSize: 16),
//                       )),
//                   Expanded(
//                       child: Icon(
//                     Icons.navigate_next,
//                     size: 20,
//                     color: Colors.black,
//                   )),
//                 ]),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 30),
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                       context,
//                       PageTransition(
//                           type: PageTransitionType.fade,
//                           child: const Transaction_history()));
//                   // Navigator.of(context).push(MaterialPageRoute(
//                   //   builder: (context) => const Transaction_history(),
//                   // ));
//                 },
//                 child: const Row(children: [
//                   Expanded(
//                       child: Icon(
//                     Icons.history,
//                     size: 20,
//                     color: Colors.black,
//                   )),
//                   Expanded(
//                       flex: 3,
//                       child: Text(
//                         'Transaction history',
//                         style: TextStyle(fontFamily: "Poppins", fontSize: 16),
//                       )),
//                   Expanded(
//                       child: Icon(
//                     Icons.navigate_next,
//                     size: 20,
//                     color: Colors.black,
//                   )),
//                 ]),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 30),
//               child: GestureDetector(
//                 onTap: () {
//                   //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>My_Profile(),));
//                 },
//                 child: const Row(children: [
//                   Expanded(
//                       child: Icon(
//                     Icons.view_list_outlined,
//                     size: 20,
//                     color: Colors.black,
//                   )),
//                   Expanded(
//                       flex: 3,
//                       child: Text(
//                         'My Order',
//                         style: TextStyle(fontFamily: "Poppins", fontSize: 16),
//                       )),
//                   Expanded(
//                       child: Icon(
//                     Icons.navigate_next,
//                     size: 20,
//                     color: Colors.black,
//                   )),
//                 ]),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 30),
//               child: GestureDetector(
//                 onTap: () {},
//                 child: const Row(children: [
//                   Expanded(
//                       child: Icon(
//                     Icons.local_offer_outlined,
//                     size: 20,
//                     color: Colors.black,
//                   )),
//                   Expanded(
//                       flex: 3,
//                       child: Text(
//                         'Offers',
//                         style: TextStyle(fontFamily: "Poppins", fontSize: 16),
//                       )),
//                   Expanded(
//                       child: Icon(
//                     Icons.navigate_next,
//                     size: 20,
//                     color: Colors.black,
//                   )),
//                 ]),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 30),
//               child: GestureDetector(
//                 onTap: () {
//                   //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>My_Profile(),));
//                 },
//                 child: const Row(children: [
//                   Expanded(
//                       child: Icon(
//                     Icons.headset_mic_outlined,
//                     size: 20,
//                     color: Colors.black,
//                   )),
//                   Expanded(
//                       flex: 3,
//                       child: Text(
//                         'Support',
//                         style: TextStyle(fontFamily: "Poppins", fontSize: 16),
//                       )),
//                   Expanded(
//                       child: Icon(
//                     Icons.navigate_next,
//                     size: 20,
//                     color: Colors.black,
//                   )),
//                 ]),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(
//           height: 90,
//         ),
//         const Padding(
//           padding: EdgeInsets.only(left: 8.0),
//           child: Divider(),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(left: 20.0),
//           child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
//             TextButton(
//                 onPressed: () {},
//                 child: const Row(
//                   children: [
//                     Icon(
//                       Icons.logout_outlined,
//                       size: 26,
//                       color: Colors.black,
//                     ),
//                     Text(
//                       "Logout",
//                       style: TextStyle(
//                           fontFamily: "Poppins",
//                           fontSize: 16,
//                           color: Colors.black),
//                     ),
//                   ],
//                 ))
//           ]),
//         )
//       ],
//     );
//   }
// }

// class MyHeaderDrawer extends StatefulWidget {
//   const MyHeaderDrawer({Key? key}) : super(key: key);

//   @override
//   State<MyHeaderDrawer> createState() => _MyHeaderDrawerState();
// }

// class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: const Color(0xffFFFFFF),
//       width: double.infinity,
//       padding: const EdgeInsets.only(top: 20),
//       child: Column(children: [
//         const SizedBox(
//           height: 35,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               child: Image.asset(
//                 "images/VillageLogo.png",
//                 height: 100,
//                 width: 200,
//               ),
//               margin: const EdgeInsets.fromLTRB(5, 10, 10, 0),
//               alignment: Alignment.center,
//             ),
//             const SizedBox(
//               height: 20,
//             )
//           ],
//         ),
//         Row(children: [
//           GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                     context,
//                     PageTransition(
//                         type: PageTransitionType.fade,
//                         child: const My_Profile()));
//                 // Navigator.of(context).push(MaterialPageRoute(
//                 //   builder: (context) => const My_Profile(),
//                 // ));
//               },
//               child: Container(
//                 width: 304,
//                 height: 90,
//                 decoration: ShapeDecoration(
//                     color: const Color(0xffFFFFFF),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                         side: const BorderSide(
//                             width: 1, color: Colors.transparent))),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           height: 87,
//                           width: 301.3,
//                           child: Row(
//                             children: [
//                               Column(
//                                 children: [
//                                   const SizedBox(
//                                     height: 30,
//                                   ),
//                                   Row(
//                                     children: [
//                                       const SizedBox(
//                                         width: 4,
//                                       ),
//                                       ClipOval(
//                                         child: FadeInImage(
//                                           height: 45,
//                                           width: 45,
//                                           image: NetworkImage(image),
//                                           fit: BoxFit.cover,
//                                           placeholder: const NetworkImage(
//                                               "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSd7ouUaXq_gL4N44vL7zj-NcpCKQDJIoIQzM3FnHnZ5Q&s"),
//                                         ),
//                                       ),
//                                       // ClipOval(
//                                       //   child: Image.network(
//                                       //     image=="" ?"https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png":image,
//                                       //     fit: BoxFit.cover,height: 45,width: 45,),
//                                       //   //   child:  _image != null
//                                       //   //       ? Image.file(File(_image!.path), fit: BoxFit.fill,)
//                                       //   //       : Image.network(image_url , fit: BoxFit.fill , scale: 1.0) ,
//                                       // ),
//                                       const SizedBox(
//                                         width: 2,
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(
//                                     height: 10,
//                                   ),
//                                 ],
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   const SizedBox(
//                                     height: 18,
//                                   ),
//                                   Row(
//                                     children: [
//                                       Text(
//                                         name.toString(),
//                                         style: const TextStyle(
//                                             fontFamily: "Poppins",
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       const SizedBox(
//                                         width: 90,
//                                       )
//                                     ],
//                                   ),
//                                   const SizedBox(
//                                     height: 5,
//                                   ),
//                                   Row(
//                                     children: [
//                                       const SizedBox(
//                                         width: 7,
//                                       ),
//                                       Text(email.toString(),
//                                           style: const TextStyle(
//                                             fontFamily: "Poppins",
//                                             fontWeight: FontWeight.w400,
//                                             fontSize: 14,
//                                           ))
//                                     ],
//                                   ),
//                                   const SizedBox(
//                                     height: 5,
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ))
//         ]),
//       ]),
//     );
//   }
// }

// // class PayUTestCredentials {
// //   static const merchantKey = 'gFHRTP';
// //   static const iosSurl = "<ADD YOUR iOS SURL>";
// //   static const iosFurl = "<ADD YOUR iOS FURL>";
// //   static const androidSurl = "<ADD YOUR ANDROID SURL>";
// //   static const androidFurl = "<ADD YOUR ANDROID FURL>";
// //   static const merchantAccessKey = "<ADD YOUR MERCHNAT ACCESS KEY>"; // Optional
// //   static const sodexoSourceId = "<ADD YOUR SODEXO SOURCE ID>"; // Optional
// // }

// // var siParams = {
// //   PayUSIParamsKeys.isFreeTrial: true,
// //   PayUSIParamsKeys.billingAmount: '1', //REQUIRED
// //   PayUSIParamsKeys.billingInterval: 1, //REQUIRED
// //   PayUSIParamsKeys.paymentStartDate: '2023-04-20', //REQUIRED
// //   PayUSIParamsKeys.paymentEndDate: '2023-04-30', //REQUIRED
// //   PayUSIParamsKeys.billingCycle:
// //       'daily', //REQUIRED //Can be any of 'daily','weekly','yearly','adhoc','once','monthly'
// //   PayUSIParamsKeys.remarks: 'Test SI transaction',
// //   PayUSIParamsKeys.billingCurrency: 'INR',
// //   PayUSIParamsKeys.billingLimit: 'ON', //ON, BEFORE, AFTER
// //   PayUSIParamsKeys.billingRule: 'MAX', //MAX, EXACT
// // };
// // var additionalParam = {
// //   PayUAdditionalParamKeys.udf1: "udf1",
// //   PayUAdditionalParamKeys.udf2: "udf2",
// //   PayUAdditionalParamKeys.udf3: "udf3",
// //   PayUAdditionalParamKeys.udf4: "udf4",
// //   PayUAdditionalParamKeys.udf5: "udf5",
// //   PayUAdditionalParamKeys.merchantAccessKey:
// //       PayUTestCredentials.merchantAccessKey,
// //   PayUAdditionalParamKeys.sourceId: PayUTestCredentials.sodexoSourceId,
// // };
// // var spitPaymentDetails = [
// //   {
// //     "type": "absolute",
// //     "splitInfo": {
// //       "imAJ7I": {"aggregatorSubTxnId": "Testchild123", "aggregatorSubAmt": "5"},
// //       "qOoYIv": {"aggregatorSubTxnId": "Testchild098", "aggregatorSubAmt": "5"},
// //     }
// //   }
// // ];
// // var payUPaymentParams = {
// //   PayUPaymentParamKey.key: "gFHRTP", //REQUIRED
// //   PayUPaymentParamKey.amount: "1", //REQUIRED
// //   PayUPaymentParamKey.productInfo: "Info", //REQUIRED
// //   PayUPaymentParamKey.firstName: "Abc", //REQUIRED
// //   PayUPaymentParamKey.email: "test@gmail.com", //REQUIRED
// //   PayUPaymentParamKey.phone: "9999999999", //REQUIRED
// //   PayUPaymentParamKey.ios_surl: PayUTestCredentials.iosSurl, //REQUIRED
// //   PayUPaymentParamKey.ios_furl: PayUTestCredentials.iosFurl, //REQUIRED
// //   PayUPaymentParamKey.android_surl: PayUTestCredentials.androidSurl, //REQUIRED
// //   PayUPaymentParamKey.android_furl: PayUTestCredentials.androidFurl, //REQUIRED
// //   PayUPaymentParamKey.environment: "0", //0 => Production 1 => Test
// //   PayUPaymentParamKey.userCredential:
// //       null, //Pass user credential to fetch saved cards => A:B - OPTIONAL
// //   PayUPaymentParamKey.transactionId: "<ADD TRANSACTION ID>", //REQUIRED
// //   PayUPaymentParamKey.additionalParam: additionalParam, // OPTIONAL
// //   PayUPaymentParamKey.enableNativeOTP: true, // OPTIONAL
// //   PayUPaymentParamKey.userToken:
// //       "<Pass a unique token to fetch offers>", // OPTIONAL
// //   PayUPaymentParamKey.payUSIParams: siParams, // OPTIONAL
// //   PayUPaymentParamKey.splitPaymentDetails: spitPaymentDetails, // OPTIONAL
// // };

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village.wale/persistance/api_repository.dart';
import 'package:village.wale/util/AppUtil.dart';
import 'package:village.wale/Cart2.dart';
import 'package:village.wale/Model/ProfileModel.dart';
import 'package:village.wale/persistance/api_repository.dart';
import 'package:village.wale/util/AppUtil.dart';
import 'package:village.wale/Model/CartModel.dart' as model;

import 'Cart.dart';
import 'HomeScreen.dart';
import 'Model/ProfileModel.dart';
import 'MyProfile.dart';
import 'Notification.dart';
import 'SplashMondeyAdded.dart';
import 'TransactionHistory.dart';

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  final TextEditingController _controller = TextEditingController();
  List<model.Cart>? cartlist = [];
  List<model.SubscriptionCart> cartsubscribeList = [];
  Razorpay _razorpay = Razorpay();
  String id = "";
  int walletAmount = 0;
  bool _isLoading = false;
  bool _isPaymentProcess = false;
  int selectedAmount = 0;
  List<String> amountList = [];
  String name = "";
  String email = "";
  String image = "";
  @override
  void initState() {
    getuserId();
    print("===>INIT STATE CALLL");
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _controller.text = "100";
    amountList.add("100");
    amountList.add("200");
    amountList.add("500");
    amountList.add("1000");
    amountList.add("2000");
    super.initState();
  }

  void getuserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    id = sharedPreferences.getString("id").toString();

    setState(() {
      _isLoading = true;
    });
    var api = APICallRepository();
    api.getProfile(id).then((value) {
      var model = ProfileModel.fromJson(jsonDecode(value));
      setState(() {
        walletAmount = int.parse(model.wallet!);
        setState(() {
          name = model.name.toString();
          email = model.gmail.toString();
          image = model.image.toString();
          _isLoading = false;
        });
      });
    }, onError: (error) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    var api = APICallRepository();
    api
        .addUserTransation(
            id, _controller.text, "", "Success", "Money Add to Wallet")
        .then((value) {
      setState(() {
        _isPaymentProcess = false;
      });
      var json = jsonDecode(value.toString());
      var message = json["message"];
      if (message == "Transaction Added") {
        walletAmount = walletAmount + int.parse(_controller.text);
        print(walletAmount);
        showCustomToast("Money Added Successfully");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const Money_Add_Succesffuly()),
            (route) => false);
        _controller.text = "";
      }
    }, onError: (error) {
      setState(() {
        _isPaymentProcess = false;
      });
      showCustomToast(error.toString());
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    var api = APICallRepository();
    api
        .addUserTransation(
            id, _controller.text, "", "Failed", "Money Add to Wallet")
        .then((value) {
      setState(() {
        _isPaymentProcess = false;
      });
      showCustomToast("Payment Failed");
    }, onError: (error) {
      setState(() {
        _isPaymentProcess = false;
      });
      showCustomToast(error.toString());
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    setState(() {
      _isPaymentProcess = false;
    });
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_NNbwJ9tmM0fbxj',
      'amount': int.parse(_controller.text) * 100,
      'description': 'Payment',
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(builder: (context) {
        return Scaffold(
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black38, spreadRadius: 0, blurRadius: 10),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: BottomNavigationBar(
                currentIndex: 1,
                elevation: 40,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: const Color(0xff85A633),
                unselectedItemColor: Colors.grey,
                selectedFontSize: 0,
                unselectedFontSize: 0,
                onTap: (value) {
                  if (value == 0) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const MyHomeScreen()));
                  }
                  if (value == 1) {}
                  if (value == 2) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Notifications()));
                  }
                  if (value == 3) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const My_Profile()));
                  }
                },
                items: const [
                  BottomNavigationBarItem(
                    backgroundColor: Colors.black,
                    icon: Icon(
                      Icons.home_outlined,
                    ),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.account_balance_wallet_outlined,
                    ),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.notifications_none_outlined,
                    ),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person_outline,
                    ),
                    label: "",
                  ),
                ],
              ),
            ),
          ),
          drawer: Drawer(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const MyHeaderDrawer(),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.black12,
                  ),
                  const MyDrawerList()
                ],
              ),
            ),
          ),
          body: !_isLoading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Builder(builder: (context) {
                                  return IconButton(
                                      iconSize: 70,
                                      onPressed: () {
                                        Scaffold.of(context).openDrawer();
                                      },
                                      tooltip: MaterialLocalizations.of(context)
                                          .openAppDrawerTooltip,
                                      icon: Image.asset(
                                        "images/Frame1.png",
                                      ));
                                }),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Welcome",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.start,
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        name.toString(),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            IconButton(
                                iconSize: 70,
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          Cart2(cartlist, cartsubscribeList)));
                                },
                                icon: Image.asset("images/Frame2.png")),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            color: const Color(0XffFFFFFF),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.account_balance_wallet_outlined,
                                        size: 35,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Available Wallet Balance',
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.currency_rupee,
                                                color: Color(0Xff85A633)),
                                            Text(
                                              walletAmount.toString(),
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0Xff85A633)),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Text(
                            'Add money',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                          child: Container(
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                    Icons.currency_rupee_outlined,
                                    color: Color(0xff9D9FA1)),
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xff9D9FA1), width: 1.0),
                                    borderRadius: BorderRadius.circular(0)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xff9D9FA1), width: 1.0),
                                    borderRadius: BorderRadius.circular(0)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xff9D9FA1), width: 1.0),
                                    borderRadius: BorderRadius.circular(0)),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            height: 50,
                            child: ListView.builder(
                              itemBuilder: (context, index) =>
                                  getAmountLayout(index),
                              itemCount: amountList.length,
                              scrollDirection: Axis.horizontal,
                            )),
                      ],
                    ),
                    !_isPaymentProcess
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: SizedBox(
                                  height: 45,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          primary: getColorFromHex("#85A633")),
                                      onPressed: () {
                                        setState(() {
                                          _isPaymentProcess = true;
                                        });

                                        if (_controller.text != "0") {
                                          openCheckout();
                                        } else {
                                          showCustomToast(
                                              "Please select Amount");
                                        }
                                      },
                                      child: const SizedBox(
                                          width: double.infinity,
                                          child: Text(
                                            "Proceed To Pay",
                                            textAlign: TextAlign.center,
                                          ))),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              )
                            ],
                          )
                        : Center(
                            child: getProgressBar(),
                          ),
                  ],
                )
              : Center(
                  child: getProgressBar(),
                ),
        );
      }),
    );
  }

  int select_index = 0;
  Widget getAmountLayout(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _controller.text = amountList[index];

          select_index = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 5),
        decoration: ShapeDecoration(
            color: index == select_index
                ? const Color(0xff85A633)
                : getColorFromHex("#e4ecd6"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: const BorderSide(width: 1, color: Colors.transparent))),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ButtonTheme(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _controller.text = amountList[index];
                      select_index = index;
                    });
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ))),
                  child: Text(
                    amountList[index].toString(),
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}

class MyDrawerList extends StatefulWidget {
  const MyDrawerList({Key? key}) : super(key: key);

  @override
  State<MyDrawerList> createState() => _MyDrawerListState();
}

class _MyDrawerListState extends State<MyDrawerList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const My_Profile(),
                  ));
                },
                child: Column(
                  children: [
                    Column(
                      children: [
                        Column(
                          children: [
                            Row(children: const [
                              Expanded(
                                  child: Icon(
                                Icons.person,
                                size: 20,
                                color: Colors.black,
                              )),
                              Expanded(
                                  flex: 3,
                                  child: Text(
                                    'My account',
                                    style: TextStyle(fontSize: 16),
                                  )),
                              Expanded(
                                  child: Icon(
                                Icons.navigate_next,
                                size: 20,
                                color: Colors.black,
                              )),
                            ]),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Padding(padding: EdgeInsets.only(top: 15),
            //   child: GestureDetector(
            //     onTap: () {
            //       //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>My_Profile(),));
            //     },
            //     child: Row(
            //         children: [
            //           Expanded(child:
            //           Icon(Icons.category_outlined,
            //             size: 20,
            //             color: Colors.black,
            //           )
            //           ),
            //           Expanded(
            //               flex: 3,
            //               child:Text(
            //                 'Shop by category',
            //                 style: TextStyle(
            //                     fontSize: 16
            //                 ),
            //               )
            //           ),
            //           Expanded(child:
            //           Icon(Icons.navigate_next,
            //             size: 20,
            //             color: Colors.black,
            //           )
            //           ),
            //
            //         ]
            //     ),
            //   ),
            //
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: GestureDetector(
                onTap: () {
                  //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>My_Profile(),));
                },
                child: Row(children: const [
                  Expanded(
                      child: Icon(
                    Icons.subscriptions_outlined,
                    size: 20,
                    color: Colors.black,
                  )),
                  Expanded(
                      flex: 3,
                      child: Text(
                        'My subscriptions',
                        style: TextStyle(fontSize: 16),
                      )),
                  Expanded(
                      child: Icon(
                    Icons.navigate_next,
                    size: 20,
                    color: Colors.black,
                  )),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: GestureDetector(
                onTap: () {
                  //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>My_Profile(),));
                },
                child: Row(children: const [
                  Expanded(
                      child: Icon(
                    Icons.wallet_giftcard_outlined,
                    size: 20,
                    color: Colors.black,
                  )),
                  Expanded(
                      flex: 3,
                      child: Text(
                        'Refer & earn',
                        style: TextStyle(fontSize: 16),
                      )),
                  Expanded(
                      child: Icon(
                    Icons.navigate_next,
                    size: 20,
                    color: Colors.black,
                  )),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Transaction_history(),
                  ));
                },
                child: Row(children: const [
                  Expanded(
                      child: Icon(
                    Icons.history,
                    size: 20,
                    color: Colors.black,
                  )),
                  Expanded(
                      flex: 3,
                      child: Text(
                        'Transaction history',
                        style: TextStyle(fontSize: 16),
                      )),
                  Expanded(
                      child: Icon(
                    Icons.navigate_next,
                    size: 20,
                    color: Colors.black,
                  )),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: GestureDetector(
                onTap: () {
                  //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>My_Profile(),));
                },
                child: Row(children: const [
                  Expanded(
                      child: Icon(
                    Icons.view_list_outlined,
                    size: 20,
                    color: Colors.black,
                  )),
                  Expanded(
                      flex: 3,
                      child: Text(
                        'My Order',
                        style: TextStyle(fontSize: 16),
                      )),
                  Expanded(
                      child: Icon(
                    Icons.navigate_next,
                    size: 20,
                    color: Colors.black,
                  )),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: GestureDetector(
                onTap: () {},
                child: Row(children: const [
                  Expanded(
                      child: Icon(
                    Icons.local_offer_outlined,
                    size: 20,
                    color: Colors.black,
                  )),
                  Expanded(
                      flex: 3,
                      child: Text(
                        'Offers',
                        style: TextStyle(fontSize: 16),
                      )),
                  Expanded(
                      child: Icon(
                    Icons.navigate_next,
                    size: 20,
                    color: Colors.black,
                  )),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: GestureDetector(
                onTap: () {
                  //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>My_Profile(),));
                },
                child: Row(children: const [
                  Expanded(
                      child: Icon(
                    Icons.headset_mic_outlined,
                    size: 20,
                    color: Colors.black,
                  )),
                  Expanded(
                      flex: 3,
                      child: Text(
                        'Support',
                        style: TextStyle(fontSize: 16),
                      )),
                  Expanded(
                      child: Icon(
                    Icons.navigate_next,
                    size: 20,
                    color: Colors.black,
                  )),
                ]),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 90,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            TextButton(
                onPressed: () {},
                child: Row(
                  children: const [
                    Icon(
                      Icons.logout_outlined,
                      size: 26,
                      color: Colors.black,
                    ),
                    Text(
                      "Logout",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ))
          ]),
        )
      ],
    );
  }
}

class MyHeaderDrawer extends StatefulWidget {
  const MyHeaderDrawer({Key? key}) : super(key: key);

  @override
  State<MyHeaderDrawer> createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffFFFFFF),
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20),
      child: Column(children: [
        const SizedBox(
          height: 35,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset(
                "images/VillageLogo.png",
                height: 100,
                width: 200,
              ),
              margin: const EdgeInsets.fromLTRB(5, 10, 10, 0),
              alignment: Alignment.center,
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
        Row(children: [
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const My_Profile(),
                ));
              },
              child: Container(
                width: 304,
                height: 90,
                decoration: ShapeDecoration(
                    color: const Color(0xffFFFFFF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(
                            width: 1, color: Colors.transparent))),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 87,
                          width: 301.3,
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      ClipOval(
                                        child: FadeInImage(
                                          height: 45,
                                          width: 45,
                                          image: NetworkImage(image),
                                          fit: BoxFit.cover,
                                          placeholder: const NetworkImage(
                                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSd7ouUaXq_gL4N44vL7zj-NcpCKQDJIoIQzM3FnHnZ5Q&s"),
                                        ),
                                      ),
                                      // ClipOval(
                                      //   child: Image.network(
                                      //     image=="" ?"https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png":image,
                                      //     fit: BoxFit.cover,height: 45,width: 45,),
                                      //   //   child:  _image != null
                                      //   //       ? Image.file(File(_image!.path), fit: BoxFit.fill,)
                                      //   //       : Image.network(image_url , fit: BoxFit.fill , scale: 1.0) ,
                                      // ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        name.toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        width: 90,
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 7,
                                      ),
                                      Text(email.toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ))
        ]),
      ]),
    );
  }
}
