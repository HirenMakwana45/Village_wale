import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
// import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';
// import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';

// import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village.wale/HomeScreen.dart';
// import 'package:village.wale/payutest.dart';
import 'package:village.wale/persistance/api_repository.dart';
import 'package:village.wale/util/AppUtil.dart';

import 'SplashMondeyAdded.dart';

class Add_money extends StatefulWidget {
  bool isPayment;
  String _productId;
  String normalPrice;
  int quentity;
  String productVolume;
  String _selectTime;

  Add_money(this.isPayment, this._productId, this.quentity, this.normalPrice,
      this.productVolume, this._selectTime);

  @override
  State<Add_money> createState() => _Add_moneyState();
}

class _Add_moneyState extends State<Add_money> {
  final TextEditingController _controller = TextEditingController();

  // Razorpay _razorpay = Razorpay();
  bool _isOnlineSelect = false;
  String C_id = "";
  bool _isCODSelect = false;
  String type = "";
  bool _isLoading = false;
  bool _isCouponLoading = false;
  final coupenController = TextEditingController();
  // late PayUCheckoutProFlutter _checkoutPro;
  // PayUCheckoutProProtocol? delegate;

  @override
  void initState() {
    // _checkoutPro = PayUCheckoutProFlutter(delegate!);

    // _razorpay = Razorpay();

    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    super.initState();
  }

  showAlertDialog(BuildContext context, String title, String content) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: new Text(content),
            ),
            actions: [okButton],
          );
        });
  }

  @override
  generateHash(Map response) {
    // Pass response param to your backend server
    // Backend will generate the hash which you need to pass to SDK
    // hashResponse: is the response which you get from your server
    Map hashResponse = {};
    // _checkoutPro!.hashGenerated(hash: hashResponse);
  }

  @override
  onPaymentSuccess(dynamic response) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String id = _prefs.getString("id").toString();
    setState(() {
      _isLoading = true;
    });

    print("===>" + id);
    print("===>" + widget._productId);
    print("===>" + widget.quentity.toString());
    print("===>" + widget.normalPrice);
    var api = APICallRepository();
    api
        .addOrder(
            id,

            // widget._productId,
            // widget.quentity.toString(),
            // widget.normalPrice,
            // "online",
            // widget.productVolume,
            widget._selectTime,
            C_id)
        .then((value) {
      var json = jsonDecode(value);
      String message = json["messaage"];
      showCustomToast(message);
      setState(() {
        _isLoading = false;
      });
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade, child: const MyHomeScreen()));
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => const MyHomeScreen()));
    }, onError: (error) {
      setState(() {
        _isLoading = false;
      });
      showCustomToast(error.toString());
    });
    showAlertDialog(context, "onPaymentSuccess", response.toString());
  }

  @override
  onPaymentFailure(dynamic response) {
    showAlertDialog(context, "onPaymentFailure", response.toString());
  }

  @override
  onPaymentCancel(Map? response) {
    showAlertDialog(context, "onPaymentCancel", response.toString());
  }

  @override
  onError(Map? response) {
    showAlertDialog(context, "onError", response.toString());
  }

  // openCheckout() {
  //   _checkoutPro!.openCheckoutScreen(
  //     payUPaymentParams: PayUParams.createPayUPaymentParams(widget.normalPrice),
  //     payUCheckoutProConfig: PayUParams.createPayUConfigParams(),
  //   );
  //   // var options = {
  //   //   'key': 'rzp_test_NNbwJ9tmM0fbxj',
  //   //   'amount': double.parse(widget.normalPrice) * 100,
  //   //   'description': 'Payment',
  //   //   'external': {
  //   //     'wallets': ['paytm']
  //   //   }
  // }

  //   try {
  //     // _razorpay.open(options);
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) async {
  //   SharedPreferences _prefs = await SharedPreferences.getInstance();
  //   String id = _prefs.getString("id").toString();
  //   setState(() {
  //     _isLoading = true;
  //   });

  //   print("===>" + id);
  //   print("===>" + widget._productId);
  //   print("===>" + widget.quentity.toString());
  //   print("===>" + widget.normalPrice);
  //   var api = APICallRepository();
  //   api
  //       .addOrder(
  //           id,

  //           // widget._productId,
  //           // widget.quentity.toString(),
  //           // widget.normalPrice,
  //           // "online",
  //           // widget.productVolume,
  //           widget._selectTime,
  //           C_id)
  //       .then((value) {
  //     var json = jsonDecode(value);
  //     String message = json["messaage"];
  //     showCustomToast(message);
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     Navigator.push(
  //         context,
  //         PageTransition(
  //             type: PageTransitionType.fade, child: const MyHomeScreen()));
  //     // Navigator.of(context)
  //     //     .push(MaterialPageRoute(builder: (context) => const MyHomeScreen()));
  //   }, onError: (error) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     showCustomToast(error.toString());
  //   });
  //   // showCustomToast("SUCCESS"+response.paymentId.toString());
  // }

  // void _handlePaymentError(PaymentFailureResponse response) {
  //   showCustomToast("Error Message:-" + response.message.toString());
  // }

  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   showCustomToast("WALLET:-" + response.walletName.toString());
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50.0,
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: coupenController,
                        decoration: const InputDecoration(
                          hintText: 'Enter coupon code',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    !_isCouponLoading
                        ? Container(
                            height: 48,
                            child: ButtonTheme(
                              buttonColor: const Color(0XFF286953),
                              child: ElevatedButton(
                                onPressed: () {
                                  verifyCoupen();
                                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => My_subscription()));
                                },
                                //textColor: Colors.white,
                                child: const Text(
                                  "Apply",
                                  style: TextStyle(
                                      fontFamily: "Poppins", fontSize: 16),
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: getProgressBar(),
                          ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: const [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Payment Method',
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        type = "online";
                        _isOnlineSelect = true;
                        _isCODSelect = false;
                      });
                    },
                    child: Container(
                      height: 70,
                      padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                      decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                  color: !_isOnlineSelect
                                      ? Colors.white
                                      : const Color(0XFF286953),
                                  width: 2))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                  alignment: Alignment.centerLeft,
                                  child: const Text(
                                    'Online payment',
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: const [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'UPI/Credit Card,Debit Card,Natbanking etc..',
                                style: TextStyle(
                                    fontFamily: "Poppins", fontSize: 14),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                //mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        type = "Cash On Delivery";
                        _isCODSelect = true;
                        _isOnlineSelect = false;
                      });
                    },
                    child: Container(
                      height: 70,
                      width: 360,
                      margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                  color: !_isCODSelect
                                      ? Colors.white
                                      : const Color(0XFF286953),
                                  width: 2))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                  alignment: Alignment.centerLeft,
                                  child: const Text(
                                    'Cast on Delivery',
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: const [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Pay on delivery',
                                style: TextStyle(
                                    fontFamily: "Poppins", fontSize: 14),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 250,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Row(
                  children: [
                    const Text(
                      "Total Amount",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      "\$" + widget.normalPrice,
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 15,
                          color: Color(0XFF286953)),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ButtonTheme(
                    height: 45.0,
                    minWidth: 380,
                    buttonColor: const Color(0XFF286953),
                    child: ElevatedButton(
                      onPressed: () {
                        if (type != "") {
                          if (type == "online") {
                            // openCheckout();
                          } else {
                            payOnDelivery();
                          }
                        } else {
                          showCustomToast("Please Select Payment Method");
                        }

                        // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Money_Add_Succesffuly()));
                      },
                      //textColor: Colors.white,
                      child: const Text(
                        "Pay Now",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void verifyCoupen() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("id").toString();

    if (coupenController.text.isEmpty) {
      showCustomToast("Please enter coupon code");
      return;
    }

    setState(() {
      _isCouponLoading = true;
    });
    var api = APICallRepository();
    api
        .verifyCoupan(
      coupenController.text,
      id,
    )
        .then((value) {
      setState(() {
        _isCouponLoading = false;
        var json = jsonDecode(value);
        String message = json["message"];
        if (message == "Coupon Not Verified") {
          showCustomToast("Invalid Coupon");
        } else {
          showCustomToast("Coupon applied");
        }
      });
    }, onError: (error) {
      setState(() {
        _isCouponLoading = false;
      });
      showCustomToast("Something Went Wrong..");
    });
  }

  void payOnDelivery() async {
    setState(() {
      _isLoading = false;
    });
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String id = _prefs.getString("id").toString();

    var api = APICallRepository();
    api
        .addOrder(
            id,

            // widget._productId,
            // widget.quentity.toString(),
            // widget.normalPrice,
            // "Cash On Delivery",
            // widget.productVolume,
            widget._selectTime,
            C_id)
        .then((value) {
      var json = jsonDecode(value);
      setState(() {
        _isLoading = false;
      });
      String message = json["messaage"];
      showCustomToast(message);
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade, child: const MyHomeScreen()));
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => const MyHomeScreen()));
    }, onError: (error) {
      setState(() {
        _isLoading = false;
      });
      showCustomToast(error.toString());
    });
  }
}

// class PayUTestCredentials {
//   static const merchantKey = "<ADD YOUR MERCHANT KEY>";
//   static const iosSurl = "<ADD YOUR iOS SURL>";
//   static const iosFurl = "<ADD YOUR iOS FURL>";
//   static const androidSurl = "<ADD YOUR ANDROID SURL>";
//   static const androidFurl = "<ADD YOUR ANDROID FURL>";
//   static const merchantAccessKey = "<ADD YOUR MERCHNAT ACCESS KEY>"; // Optional
//   static const sodexoSourceId = "<ADD YOUR SODEXO SOURCE ID>"; // Optional
// }

// var siParams = {
//   PayUSIParamsKeys.isFreeTrial: true,
//   PayUSIParamsKeys.billingAmount: '1', //REQUIRED
//   PayUSIParamsKeys.billingInterval: 1, //REQUIRED
//   PayUSIParamsKeys.paymentStartDate: '2023-04-20', //REQUIRED
//   PayUSIParamsKeys.paymentEndDate: '2023-04-30', //REQUIRED
//   PayUSIParamsKeys.billingCycle:
//       'daily', //REQUIRED //Can be any of 'daily','weekly','yearly','adhoc','once','monthly'
//   PayUSIParamsKeys.remarks: 'Test SI transaction',
//   PayUSIParamsKeys.billingCurrency: 'INR',
//   PayUSIParamsKeys.billingLimit: 'ON', //ON, BEFORE, AFTER
//   PayUSIParamsKeys.billingRule: 'MAX', //MAX, EXACT
// };
// var additionalParam = {
//   PayUAdditionalParamKeys.udf1: "udf1",
//   PayUAdditionalParamKeys.udf2: "udf2",
//   PayUAdditionalParamKeys.udf3: "udf3",
//   PayUAdditionalParamKeys.udf4: "udf4",
//   PayUAdditionalParamKeys.udf5: "udf5",
//   PayUAdditionalParamKeys.merchantAccessKey:
//       PayUTestCredentials.merchantAccessKey,
//   PayUAdditionalParamKeys.sourceId: PayUTestCredentials.sodexoSourceId,
// };
// var spitPaymentDetails = [
//   {
//     "type": "absolute",
//     "splitInfo": {
//       "imAJ7I": {"aggregatorSubTxnId": "Testchild123", "aggregatorSubAmt": "5"},
//       "qOoYIv": {"aggregatorSubTxnId": "Testchild098", "aggregatorSubAmt": "5"},
//     }
//   }
// ];
