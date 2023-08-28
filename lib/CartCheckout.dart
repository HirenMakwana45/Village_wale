// import 'dart:convert';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:payumoney_pro_unofficial/payumoney_pro_unofficial.dart';
// // import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:village.wale/Model/CartModel.dart';
// import 'package:village.wale/persistance/api_repository.dart';
// import 'package:village.wale/util/AppUtil.dart';
// import 'package:village.wale/util/OrderSuccessScreen.dart';

// import 'HomeScreen.dart';
// import 'Model/ProfileModel.dart';

// class CartCheckout extends StatefulWidget {
//   int _totalAmount = 0;
//   List<Cart> _list = [];
//   String _selectTime;
//   CartCheckout(this._totalAmount, this._list, this._selectTime, {Key? key})
//       : super(key: key);

//   @override
//   _CartCheckout createState() => _CartCheckout();
// }

// class _CartCheckout extends State<CartCheckout> {
//   final TextEditingController _controller = TextEditingController();

//   // Razorpay _razorpay = Razorpay();
//   bool _isOnlineSelect = false;
//   bool _isCODSelect = false;
//   String type = "";
//   String C_id = "";
//   String id = "";

//   bool _isCouponLoading = false;
//   bool _isLoading = false;
//   final coupenController = TextEditingController();
//   String Merchantsalt = "I5SzoJDrdd8rUsweWjJo9ySV0PRHjkBX";
//   String name = "";
//   String email = "";
//   String number = "";
//   String t_id = DateTime.now().millisecondsSinceEpoch.toString();
//   bool _isPaymentProcess = false;

//   @override
//   void initState() {
//     getuserId();

//     // _razorpay = Razorpay();
//     // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

//     List<int> total = [];
//     for (int i = 0; i < widget._list.length; i++) {
//       print("===>PRINT==>" + widget._list[i].quantity.toString());
//       total.add(int.parse(widget._list[i].quantity!) *
//           int.parse((widget._list[i].price!)));
//     }

//     for (int j = 0; j < total.length; j++) {
//       widget._totalAmount += total[j];
//     }

//     super.initState();
//   }

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
//         // walletAmount = int.parse(model.wallet!);
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

//   Future<void> initializePayment() async {
//     final response = await PayumoneyProUnofficial.payUParams(
//         email: email,
//         firstName: name,
//         merchantName: 'Villagewale',
//         isProduction: false,
//         merchantKey: 'gFHRTP',
//         merchantSalt: Merchantsalt,
//         amount: int.parse(_controller.text).toString(),
//         hashUrl:
//             'c972d3540751fd64f9654c0fcca0da253edc01cda2dbc7f718850ee832f019d438cb75f7e2b25c1d998beb2ddcf6f53057053ba2aef44c6d7cb0932930f73727',

//         // 'ffcdbf04fa5beefdcc2dd476c18bc410f02b3968e7f4f54e8f43f1e1a310bb32e3b4dec9305232bb89db5b1d0c009a53bcace6f4bd8ec2f695baf3d43ba730ce', //nodejs code is included. Host the code and update its url here.

//         productInfo: 'Money Add to Wallet',
//         transactionId: t_id,
//         showExitConfirmation: true,
//         showLogs: true, // true for debugging, false for production

//         userCredentials: 'gFHRTP' + email,
//         userPhoneNumber: number);

//     if (response['status'] == PayUParams.success) handlePaymentSuccess();

//     print(response);

//     if (response['status'] == PayUParams.failed)
//       handlePaymentFailure(response['message']);

//     setState(() {
//       _isPaymentProcess = false;
//     });
//   }

//   handlePaymentSuccess() async {
//     //Implement Your Success Logic
//     SharedPreferences _prefs = await SharedPreferences.getInstance();
//     String id = _prefs.getString("id").toString();

//     setState(() {
//       _isLoading = true;
//     });
//     for (int i = 0; i < widget._list.length; i++) {
//       var api = APICallRepository();
//       api
//           .addOrder(
//               id,
//               // widget._list[i].productId.toString(),
//               // widget._list[i].quantity.toString(),
//               // widget._list[i].price.toString(),
//               // "online",
//               // widget._list[i].volume,
//               widget._selectTime,
//               C_id)
//           .then((value) {
//         var json = jsonDecode(value);
//         setState(() {
//           _isLoading = false;
//         });
//         String message = json["messaage"];
//         Navigator.push(
//             context,
//             PageTransition(
//                 type: PageTransitionType.fade, child: OrderSuccessScreen()));
//       }, onError: (error) {
//         setState(() {
//           _isLoading = false;
//         });
//         showCustomToast(error.toString());
//       });
//     }
//     //String message = json["messaage"];
//     Navigator.push(
//         context,
//         PageTransition(
//             type: PageTransitionType.fade, child: OrderSuccessScreen()));

//     // showCustomToast("SUCCESS"+response.paymentId.toString());
//   }

//   handlePaymentFailure(String errorMessage) {
//     //Implement Your Failed Payment Logic
//   }

//   // void openCheckout() async {
//   //   // var options = {
//   //   //   'key': 'rzp_test_NNbwJ9tmM0fbxj',
//   //   //   'amount': widget._totalAmount * 100,
//   //   //   'description': 'Payment',
//   //   //   'external': {
//   //   //     'wallets': ['paytm']
//   //   //   }
//   //   // };

//   //   try {
//   //     // _razorpay.open(options);
//   //   } catch (e) {
//   //     debugPrint(e.toString());
//   //   }
//   // }

//   //****************** */

//   // void _handlePaymentSuccess(PaymentSuccessResponse response) async {
//   //   SharedPreferences _prefs = await SharedPreferences.getInstance();
//   //   String id = _prefs.getString("id").toString();

//   //   setState(() {
//   //     _isLoading = true;
//   //   });
//   //   for (int i = 0; i < widget._list.length; i++) {
//   //     var api = APICallRepository();
//   //     api
//   //         .addOrder(
//   //             id,
//   //             // widget._list[i].productId.toString(),
//   //             // widget._list[i].quantity.toString(),
//   //             // widget._list[i].price.toString(),
//   //             // "online",
//   //             // widget._list[i].volume,
//   //             widget._selectTime,
//   //             C_id)
//   //         .then((value) {
//   //       var json = jsonDecode(value);
//   //       setState(() {
//   //         _isLoading = false;
//   //       });
//   //       String message = json["messaage"];
//   //       Navigator.push(
//   //           context,
//   //           PageTransition(
//   //               type: PageTransitionType.fade, child: OrderSuccessScreen()));
//   //     }, onError: (error) {
//   //       setState(() {
//   //         _isLoading = false;
//   //       });
//   //       showCustomToast(error.toString());
//   //     });
//   //   }
//   //   //String message = json["messaage"];
//   //   Navigator.push(
//   //       context,
//   //       PageTransition(
//   //           type: PageTransitionType.fade, child: OrderSuccessScreen()));

//   //   // showCustomToast("SUCCESS"+response.paymentId.toString());
//   // }

//   // void _handlePaymentError(PaymentFailureResponse response) {
//   //   showCustomToast("Error Message:-" + response.message.toString());
//   // }

//   // void _handleExternalWallet(ExternalWalletResponse response) {
//   //   showCustomToast("WALLET:-" + response.walletName.toString());
//   // }

//   //****************** */

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 // Container(
//                 //   margin: const EdgeInsets.all(20),
//                 //   child: Row(
//                 //     children: [
//                 //       Expanded(
//                 //         child: TextField(
//                 //           controller: coupenController,
//                 //           decoration: const InputDecoration(
//                 //             hintText: 'Enter coupon code',
//                 //           ),
//                 //         ),
//                 //       ),
//                 //       const SizedBox(
//                 //         width: 5,
//                 //       ),
//                 //       !_isCouponLoading
//                 //           ? Container(
//                 //               height: 48,
//                 //               child: ButtonTheme(
//                 //                 buttonColor: const Color(0XFF286953),
//                 //                 child: RaisedButton(
//                 //                   onPressed: () {
//                 //                     // verifyCoupen();
//                 //                     // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => My_subscription()));
//                 //                   },
//                 //                   textColor: Colors.white,
//                 //                   child: const Text(
//                 //                     "Apply",
//                 //                     style: TextStyle(
//                 //                         fontWeight: FontWeight.w500,
//                 //                         fontSize: 16),
//                 //                   ),
//                 //                 ),
//                 //               ),
//                 //             )
//                 //           : Center(
//                 //               child: getProgressBar(),
//                 //             ),
//                 //     ],
//                 //   ),
//                 // ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 Row(
//                   children: const [
//                     SizedBox(
//                       width: 20,
//                     ),
//                     Text(
//                       'Payment Method',
//                       style: TextStyle(
//                           fontFamily: "Poppins",
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(
//                       width: 15,
//                     ),
//                     InkWell(
//                       onTap: () {
//                         setState(() {
//                           type = "online";
//                           _isOnlineSelect = true;
//                           _isCODSelect = false;
//                         });
//                       },
//                       child: Container(
//                         height: 70,
//                         padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
//                         decoration: ShapeDecoration(
//                             color: Colors.white,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10.0),
//                                 side: BorderSide(
//                                     color: !_isOnlineSelect
//                                         ? Colors.white
//                                         : const Color(0XFF286953),
//                                     width: 2))),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(
//                               height: 15,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const SizedBox(
//                                   width: 10,
//                                 ),
//                                 Container(
//                                     alignment: Alignment.centerLeft,
//                                     child: const Text(
//                                       'Online payment',
//                                       style: TextStyle(
//                                           fontFamily: "Poppins",
//                                           fontWeight: FontWeight.w500,
//                                           fontSize: 16),
//                                     )),
//                               ],
//                             ),
//                             const SizedBox(
//                               height: 5,
//                             ),
//                             Row(
//                               children: const [
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Text(
//                                   'UPI/Credit Card,Debit Card,Natbanking etc..',
//                                   style: TextStyle(
//                                       fontFamily: "Poppins", fontSize: 14),
//                                 )
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   // mainAxisSize: MainAxisSize.max,
//                   children: [
//                     const SizedBox(
//                       width: 15,
//                     ),
//                     InkWell(
//                       onTap: () {
//                         setState(() {
//                           type = "Cash On Delivery";
//                           _isCODSelect = true;
//                           _isOnlineSelect = false;
//                         });
//                       },
//                       child: Container(
//                         height: 70,
//                         width: MediaQuery.of(context).size.width - 25,
//                         padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
//                         decoration: ShapeDecoration(
//                             color: Colors.white,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10.0),
//                                 side: BorderSide(
//                                     color: !_isCODSelect
//                                         ? Colors.white
//                                         : const Color(0XFF286953),
//                                     width: 2))),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(
//                               height: 15,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const SizedBox(
//                                   width: 10,
//                                 ),
//                                 Container(
//                                     alignment: Alignment.centerLeft,
//                                     child: const Text(
//                                       'Cash on Delivery',
//                                       style: TextStyle(
//                                           fontFamily: "Poppins",
//                                           fontWeight: FontWeight.w500,
//                                           fontSize: 16),
//                                     )),
//                               ],
//                             ),
//                             const SizedBox(
//                               height: 5,
//                             ),
//                             Row(
//                               children: const [
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Text(
//                                   'Pay on delivery',
//                                   style: TextStyle(
//                                       fontFamily: "Poppins", fontSize: 14),
//                                 )
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(
//                   height: 250,
//                 ),
//                 Container(
//                   margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
//                   child: Row(
//                     children: [
//                       const Text(
//                         "Total Amount",
//                         style: TextStyle(
//                             fontFamily: "Poppins",
//                             fontSize: 15,
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       const Spacer(),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.currency_rupee, size: 15,
//                             // color: Color(0XFF286953),
//                           ),
//                           Text(
//                             widget._totalAmount.toString(),
//                             style: const TextStyle(
//                                 fontFamily: "Poppins",
//                                 fontSize: 15,
//                                 color: Color(0XFF286953)),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 !_isLoading
//                     ? Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           SizedBox(
//                             height: 45.0,
//                             width: MediaQuery.of(context).size.width - 25,
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 if (type != "") {
//                                   if (type == "online") {
//                                     // openCheckout();
//                                   } else {
//                                     // payOnDelivery();
//                                   }
//                                 } else {
//                                   showCustomToast(
//                                       "Please Select Payment Method");
//                                 }

//                                 // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Money_Add_Succesffuly()));
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 primary: const Color(0XFF286953),
//                               ),

//                               // textColor: Colors.white,
//                               child: const Text(
//                                 "Pay Now",
//                                 style: TextStyle(
//                                     fontFamily: "Poppins", color: Colors.white),
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                     : Center(
//                         child: getProgressBar(),
//                       ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void verifyCoupen() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     String id = sharedPreferences.getString("id").toString();
//     String _productId = sharedPreferences.getString("_productId").toString();

//     if (coupenController.text.isEmpty) {
//       showCustomToast("Please enter coupon code");
//       return;
//     }

//     setState(() {
//       _isCouponLoading = true;
//     });

//     // var api = APICallRepository();

//     // api.verifyCoupan(coupenController.text, id, widget._productId).then(
//     //     (value) {
//     //   setState(() {
//     //     _isCouponLoading = false;
//     //     var json = jsonDecode(value);
//     //     String message = json["message"];
//     //     if (message == "Coupon Not Verified") {
//     //       showCustomToast("Invalid Coupon");
//     //     } else {
//     //       showCustomToast("Coupon applied");
//     //     }
//     //   });
//     // }, onError: (error) {
//     //   setState(() {
//     //     _isCouponLoading = false;
//     //   });
//     //   showCustomToast("Something Went Wrong..");
//     // });
//   }

//   // void payOnDelivery() async {
//   //   SharedPreferences _prefs = await SharedPreferences.getInstance();
//   //   String id = _prefs.getString("id").toString();

//   //   var api = APICallRepository();
//   //   api
//   //       .addOrder(id, widget._productId, widget.quentity.toString(),
//   //           widget.normalPrice, "Cash On Delivery")
//   //       .then((value) {
//   //     var json = jsonDecode(value);
//   //     String message = json["messaage"];
//   //     showCustomToast(message);
//   //     Navigator.of(context)
//   //         .push(MaterialPageRoute(builder: (context) => MyHomeScreen()));
//   //   }, onError: (error) {
//   //     showCustomToast(error.toString());
//   //   });

//   //   setState(() {
//   //     _isLoading = true;
//   //   });
//   //   // SharedPreferences _prefs = await SharedPreferences.getInstance();
//   //   // String id = _prefs.getString("id").toString();

//   //   for (int i = 0; i < widget._list.length; i++) {
//   //     var api = APICallRepository();
//   //     api.addOrder(
//   //         id,
//   //         widget._list[i].productId.toString(),
//   //         widget._list[i].quantity.toString(),
//   //         widget._list[i].price.toString(),
//   //         "online",
//   //         widget._list[i].volume,
//   //         widget._selectTime)
//   //       ..then((value) {
//   //         var json = jsonDecode(value);
//   //         setState(() {
//   //           _isLoading = false;
//   //         });
//   //         String message = json["messaage"];
//   //         // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyHomeScreen()));
//   //         Navigator.of(context).push(
//   //             MaterialPageRoute(builder: (context) => OrderSuccessScreen()));
//   //       }, onError: (error) {
//   //         setState(() {
//   //           _isLoading = false;
//   //         });
//   //         showCustomToast(error.toString());
//   //       });
//   //   }
//   // }
// }
