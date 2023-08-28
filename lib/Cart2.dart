import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get_storage/get_storage.dart';
import 'package:page_transition/page_transition.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village.wale/Map.dart';
import 'package:village.wale/Model/CartModel.dart';
import 'package:village.wale/persistance/api_repository.dart';
import 'package:village.wale/util/AppUtil.dart';
import 'package:village.wale/util/OrderSuccessScreen.dart';
import 'package:village.wale/util/util.dart';
import 'CartCheckout.dart';
import 'HomeScreen.dart';
import 'LogInPage1.dart';
import 'Map2.dart';
import 'Model/HomeModel.dart';
import 'Model/ProfileModel.dart';
import 'Offer.dart';
import 'package:village.wale/Model/CartModel.dart' as model;
import 'package:intl/intl.dart';

import 'Wallet.dart';

class Cart2 extends StatefulWidget {
  // Cart2( {Key? key}) : super(key: key);
  List<Cart>? _list;
  List<SubscriptionCart>? _list2;
  Cart2(
    this._list,
    this._list2,
  );

  @override
  _Cart2 createState() => _Cart2();
}

class _Cart2 extends State<Cart2> {
  List<model.Cart>? list = [];
  Products? _model;
  List<String> volume = [];
  int HABIBI = 0;
  int incrementtotal = 0;
  int P_TOTAL = 0;
  List<model.SubscriptionCart>? list2 = [];
//  String? Combinelist;
  List<String> value = [
    "06:00 AM - 09:00 AM",
    "09:00 AM - 11:00 AM",
    "11:00 AM - 01:00 PM",
    "01:00 PM - 03:00 PM",
    "03:00 PM - 05:00 PM",
    "05:00 PM - 07:00 PM",
    "07:00 PM - 09:00 PM",
  ];
  String selectTime = "";
  int _totalAmount = 0;
  int removingamount = 0;

  int boombooom = 0;
  int _GetProductTotalAmount = 0;
  int _SubscriptionTotalAmount = 0;

  int TotalSub = 0;
  int UpdatedPrice = 0;
  double T_G_Price = 0;
  int _RemovingUpdatePrice = 0;
  String? PAY_AMOUNT;
  String? PAY_AMOUNT2;
  int totalbalance = 0;
  final address1 = TextEditingController();
  final address2 = TextEditingController();
  String date = "";
  int newprice = 0;
  int new_price = 0;
  String _address = "";
  String _address2 = "";
  String _addressString = "";
  String? changeaddress = "";
  bool _isLoading = true;
  double price = 0;
  final getStorage = GetStorage();
  double walletAmount = 0;
  bool _isProfileLoading = false;
  double secondPrice = 0;
  final TextEditingController _controller = TextEditingController();
  bool _isPaymentProcess = false;
  String? transaction_status;
  String? transaction_type;
  int Discount_Price = 0;
  double PERCENTAGE = 0;
  String? Coupon_ID;
  int FunctionalityDiscount = 0;
  bool Clicked1 = false;
  bool Clicked2 = false;

  String? SHOW;

  String? price_Limit;
  int service_charge = 0;
  String? Status;
  int incre_amount = 0;
  int decre_amount = 0;
  int remove_amount = 0;
  int service_amount = 0;
  int pm = 0;

  String? Startdate;
  String? Enddate;
  int FinalDate = 0;

  //TextEditingController _dateController = TextEditingController();

  Future refresh() async {
    setState(() {
      removeCart(id);

      // getCartDetail();
      print("Page Refresh 1Current Price --> " + newprice.toString());
    });
  }

  @override
  void initState() {
    // var product_new_price = _model!.normalPrice.toString();

    // secondPrice = double.parse(product_new_price);
    //_controller.text = "100";

    var subtype = getStorage.read("subscriptiontype");
    var repeatdays = getStorage.read("concate");
    Startdate = getStorage.read("startdate");
    Enddate = getStorage.read("enddate");

    var service_fee = getStorage.read("d_charge");

    print(service_fee);

    setState(() {
      Discount_Price = 0;
      // print("AHa");
      // print(service_amount);
      //DIp = 0;

      price_Limit = getStorage.read("PriceLIMIT");
      Status = getStorage.read("STATUS");
      // Coupon_ID = getStorage.read("Coupon_id");

      print("======");
      //print(DIp);
      print(Discount_Price);
      // if (DIp == null) {
      //   Discount_Price = 0;
      // } else {
      print("TOTAL AMOUNT IS" + _totalAmount.toString());
      print("After that Price limit " + price_Limit.toString());

      print("+++++++++++++++++++");
      print(Discount_Price);
      //
      // }

      print(Discount_Price);

      print(repeatdays);
      print(Startdate);
      print(Enddate);

// Should return 1, but returns 0.

      print(subtype);
      print(Discount_Price);
      print(price_Limit);
      print(Status);

      List<int> total = [];
      for (int i = 0; i < widget._list!.length; i++) {
        print("===>PRINT==>" + widget._list![i].quantity.toString());
        total.add(int.parse(widget._list![i].quantity!) *
            int.parse((widget._list![i].discountPrice!)));
      }

      // print("Discount Price Is -->" + list![1].discountPrice.toString());
      // for (int i = 0; i < widget._list2!.length; i++) {
      //   print("===>PRINT==>" + widget._list2![i].quantity.toString());
      //   total.add(int.parse(widget._list2![i].quantity!) *
      //       int.parse((widget._lis![i].price!)));
      // }

      int mAmount = 0;
      for (int j = 0; j < total.length; j++) {
        _totalAmount += total[j];
      }
      print(_totalAmount);
      _totalAmount * 10;
      print(mAmount);
      mAmount = _totalAmount * 10;
      // _totalAmount = mAmount;
      // _totalAmount + newprice;
      getId();
      getAddress();
      getCartDetail();

      refresh();
      var service_fee = getStorage.read("d_charge");

      setState(() {
        if (service_amount == 0) {
          service_amount = int.parse(service_fee.toString());
        } else {
          service_amount = 0;
        }
      });
      // }
    });

    //Discount_Price = getStorage.read("DISCOUNT_PRICE");

    super.initState();
  }

  String id = "";

  void getId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    id = sharedPreferences.getString("id").toString();

    print("===>ID=>$id");
    if (this.mounted) {
      // check whether the state object is in tree
      setState(() {
        _isProfileLoading = true; // make changes here
      });
    }

    // setState(() {

    // });
    var api = APICallRepository();
    api.getProfile(id).then((value) {
      var model = ProfileModel.fromJson(jsonDecode(value));
      if (this.mounted) {
        // check whether the state object is in tree
        setState(() {
          _isProfileLoading = false;
          walletAmount = double.parse(model.wallet!);
          print("WALLET AMOUNT IS HERE -->" + walletAmount.toString());
        });
      }
      // setState(() {

      // });
    }, onError: (error) {
      if (this.mounted) {
        // check whether the state object is in tree
        setState(() {
          _isProfileLoading = false; // make changes here
        });
      }
    });
  }

  void getAddress() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _address = sharedPreferences.getString("address").toString();
      _address2 = sharedPreferences.getString("address2").toString();

      // 2 value
      // address 1 , address2

      // store in _addressString
      print(address1.text.toString());
      print(address2.text.toString());

      if (_addressString == address2.text.toString()) {
        _addressString = _address2;
      } else {
        _addressString = _address;
      }

      // _addressString = _address;
      // _addressString = _address2;

      // changeaddress = _addressString;
      //_addressString = _address2;
      address1.text = _address;
      address2.text = _address2 == "" || _address2 == "null"
          ? "No Address Found"
          : _address2;
    });
  }

  var greencolor = const Color(0XFF286953);
  CircularProgressIndicator getProgressBar() {
    return CircularProgressIndicator(
      color: greencolor,
    );
  }

  // Future<bool> _onWillPop() async {
  //   // This dialog will exit your app on saying yes
  //   return (await showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: const Text('Are you sure?'),
  //           content: const Text('Do you want to exit from cart'),
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () => Navigator.of(context).pop(false),
  //               child: const Text('No'),
  //             ),
  //             TextButton(
  //               onPressed: () => Navigator.of(context).pop(true),
  //               child: const Text('Yes'),
  //             ),
  //           ],
  //         ),
  //       )) ??
  //       false;
  // }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          // Navigator.of(context).push(
          //     MaterialPageRoute(builder: (context) => const MyHomeScreen()));
          return false;
        },
        child: Scaffold(
          body: SafeArea(
            child: Builder(builder: (context) {
              if (_isLoading) {
                return Center(
                  child: getProgressBar(),
                );
              } else {
                return Container(
                  //  color: Color(0xffFCFDFF),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: MyHomeScreen()));
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) =>
                                //         const MyHomeScreen()));
                              },
                            ),
                            const Text(
                              'Cart',
                              style: TextStyle(
                                  fontFamily: "Poppins", fontSize: 20),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Visibility(
                          visible: list!.isEmpty ? false : true,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: const Text(
                                  'Product Summary',
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Text(
                                "(${list!.length} Items)",
                                style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Visibility(
                          visible: list!.isEmpty ? false : true,
                          child: ListView.builder(
                            primary: false,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) =>
                                getProductSummary(index),
                            itemCount: list!.length,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Visibility(
                          visible: list2!.isEmpty ? false : true,
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 4.0),
                                child: Text(
                                  'Subscription Summary',
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Text(
                                '(${list2!.length.toString()} items)',
                                style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Visibility(
                          visible: list2!.isEmpty ? false : true,
                          child: ListView.builder(
                            primary: false,
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, index) =>
                                getSubscraptionSummary(index),
                            itemCount: list2!.length,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),

                        // Select Prefered Date & Time Here
                        Visibility(
                          visible:
                              list2!.isEmpty && list!.isEmpty ? false : true,
                          child: Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(left: 4.0),
                                child: Text(
                                  'Select Prefered Date & Time',
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible:
                              list2!.isEmpty && list!.isEmpty ? false : true,
                          child: Card(
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(5)),
                            margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                            //elevation: 3,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                Card(
                                  elevation: 2,
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: InkWell(
                                    onTap: () async {
                                      DateTime selectedDate = DateTime.now();

                                      final DateTime? picked =
                                          await showDatePicker(
                                        builder: ((context, child) {
                                          return Theme(
                                              data: Theme.of(context).copyWith(
                                                colorScheme:
                                                    const ColorScheme.light(
                                                  primary: Color(
                                                      0XFF286953), // header background color
                                                  onPrimary: Colors
                                                      .black45, // header text color
                                                  onSurface: Colors
                                                      .black, // body text color
                                                ),
                                                textButtonTheme:
                                                    TextButtonThemeData(
                                                  style: TextButton.styleFrom(
                                                    primary: const Color(
                                                        0XFF286953), // button text color
                                                  ),
                                                ),
                                              ),
                                              child: child!);
                                        }),
                                        context: context,
                                        firstDate: DateTime(2015, 8),
                                        lastDate: DateTime(2101),
                                        initialDate: selectedDate,
                                      );
                                      if (picked != null) {
                                        setState(() {
                                          selectedDate = picked;
                                          date = DateFormat.yMMMMEEEEd()
                                              .format(selectedDate);
                                          print(
                                              "==>ENTRY==> Your Selected Date:  $date");
                                        });
                                      } else {
                                        selectedDate;
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 10, 10),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "images/calender.png",
                                            height: 20,
                                            width: 20,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            date.toString() == ""
                                                ? "Saturday, 26 March, 2022 "
                                                : date,
                                            style: const TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 15),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          const Icon(Icons
                                              .keyboard_arrow_down_outlined),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomRadioButton(
                                          spacing: 1.0,
                                          padding: 5,
                                          wrapAlignment:
                                              WrapAlignment.spaceEvenly,
                                          elevation: 0,
                                          autoWidth: true,
                                          radius: 20,
                                          enableShape: true,
                                          shapeRadius: 50,
                                          absoluteZeroSpacing: false,
                                          buttonLables: value,
                                          buttonValues: value,
                                          buttonTextStyle:
                                              const ButtonTextStyle(
                                                  selectedColor: Colors.white,
                                                  unSelectedColor:
                                                      Color(0XFF286953),
                                                  textStyle: TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 12)),
                                          radioButtonValue: (value) {
                                            if (kDebugMode) {
                                              print(value);
                                            }

                                            setState(() {
                                              selectTime = value.toString();
                                            });

                                            print("This Is a Selected Time" +
                                                selectTime);
                                          },
                                          unSelectedColor:
                                              getColorFromHex("#e4ecd6"),
                                          selectedColor:
                                              getColorFromHex("#286953"),
                                          unSelectedBorderColor:
                                              Colors.transparent,
                                          selectedBorderColor:
                                              Colors.transparent,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Accordion(
                                //     maxOpenSections: 1,
                                //     headerBackgroundColorOpened: Colors.white,
                                //     scaleWhenAnimating: true,
                                //     openAndCloseAnimation: true,
                                //     headerPadding: const EdgeInsets.symmetric(
                                //         vertical: 7, horizontal: 5),
                                //     children: [
                                //       AccordionSection(
                                //         isOpen: false,
                                //         rightIcon: const Icon(
                                //           Icons.arrow_drop_down,
                                //           color: Colors.black,
                                //         ),
                                //         leftIcon: const CircleAvatar(
                                //           backgroundColor: Colors.transparent,
                                //           child: Icon(
                                //             Icons.calendar_today_outlined,
                                //             color: Colors.black,
                                //           ),
                                //         ),
                                //         headerBackgroundColor: Colors.white,
                                //         headerBackgroundColorOpened: Colors.white,
                                //         header: Text(
                                //           date,
                                //           style: const TextStyle(
                                //               fontSize: 14,
                                //               fontFamily: 'Urbanist',
                                //               color: Color(0Xff2B3448)),
                                //         ),
                                //         content: Column(
                                //           children: [
                                //             Row(
                                //               children: [
                                //                 Expanded(
                                //                   child: TextButton(
                                //                     onPressed: () {},
                                //                     style: TextButton.styleFrom(
                                //                       //<-- SEE HERE

                                //                       backgroundColor:
                                //                           const Color(0XffFFFFFF),
                                //                       side: const BorderSide(
                                //                           width: 1.0,
                                //                           color:
                                //                               Color(0XffE1DFDD)),
                                //                     ),
                                //                     child: const Text(
                                //                       '08:00 AM - 11:00 AM',
                                //                     ),
                                //                   ),
                                //                 ),
                                //                 const SizedBox(
                                //                   width: 10,
                                //                 ),
                                //                 Expanded(
                                //                   child: TextButton(
                                //                     onPressed: () {},
                                //                     style: TextButton.styleFrom(
                                //                       //<-- SEE HERE
                                //                       backgroundColor:
                                //                           const Color(0XffFFFFFF),
                                //                       side: const BorderSide(
                                //                           width: 1.0,
                                //                           color:
                                //                               Color(0XffE1DFDD)),
                                //                     ),
                                //                     child: const Text(
                                //                       '11:00 AM - 01:00 PM',
                                //                       style: TextStyle(
                                //                           color:
                                //                               Color(0xff959595)),
                                //                     ),
                                //                   ),
                                //                 ),
                                //               ],
                                //             ),
                                //             Row(
                                //               children: [
                                //                 Expanded(
                                //                   child: TextButton(
                                //                     onPressed: () {},
                                //                     style: TextButton.styleFrom(
                                //                       //<-- SEE HERE
                                //                       backgroundColor:
                                //                           const Color(0XffFFFFFF),
                                //                       side: const BorderSide(
                                //                           width: 1.0,
                                //                           color:
                                //                               Color(0XffE1DFDD)),
                                //                     ),
                                //                     child: const Text(
                                //                       '01:00 PM - 03:00 PM',
                                //                       style: TextStyle(),
                                //                     ),
                                //                   ),
                                //                 ),
                                //                 const SizedBox(
                                //                   width: 10,
                                //                 ),
                                //                 Expanded(
                                //                   child: TextButton(
                                //                     onPressed: () {},
                                //                     style: TextButton.styleFrom(
                                //                       //<-- SEE HERE
                                //                       backgroundColor:
                                //                           const Color(0XffFFFFFF),
                                //                       side: const BorderSide(
                                //                           width: 1.0,
                                //                           color:
                                //                               Color(0XffE1DFDD)),
                                //                     ),
                                //                     child: const Text(
                                //                       '03:00 PM - 05:00 PM',
                                //                       style: TextStyle(),
                                //                     ),
                                //                   ),
                                //                 ),
                                //               ],
                                //             ),
                                //             Row(
                                //               children: [
                                //                 Expanded(
                                //                   child: TextButton(
                                //                     onPressed: () {},
                                //                     style: TextButton.styleFrom(
                                //                       //<-- SEE HERE
                                //                       backgroundColor:
                                //                           const Color(0XffFFFFFF),
                                //                       side: const BorderSide(
                                //                           width: 1.0,
                                //                           color:
                                //                               Color(0XffE1DFDD)),
                                //                     ),
                                //                     child: const Text(
                                //                       '05:00 PM - 07:00 PM',
                                //                       style: TextStyle(),
                                //                     ),
                                //                   ),
                                //                 ),
                                //                 const SizedBox(
                                //                   width: 10,
                                //                 ),
                                //                 Expanded(
                                //                   child: TextButton(
                                //                     onPressed: () {},
                                //                     style: TextButton.styleFrom(
                                //                       //<-- SEE HERE
                                //                       backgroundColor:
                                //                           const Color(0XffFFFFFF),
                                //                       side: const BorderSide(
                                //                           width: 1.0,
                                //                           color:
                                //                               Color(0XffE1DFDD)),
                                //                     ),
                                //                     child: const Text(
                                //                       '07:00 PM - 09:00 PM',
                                //                       style: TextStyle(),
                                //                     ),
                                //                   ),
                                //                 ),
                                //               ],
                                //             ),
                                //           ],
                                //         ),
                                //         // content: Text(_loremIpsum, style: _contentStyle),
                                //         // contentHorizontalPadding: 20,
                                //         // contentBorderWidth: 1,
                                //         // onOpenSection: () => print('onOpenSection ...'),
                                //         // onCloseSection: () => print('onCloseSection ...'),
                                //         contentHorizontalPadding: 0,
                                //         contentBorderWidth: 0,
                                //       ),
                                //     ]),

                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Visibility(
                          visible:
                              list2!.isEmpty && list!.isEmpty ? false : true,
                          child: Card(
                            elevation: 2,
                            margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Image.asset(
                                    "images/reward.png",
                                    height: 35,
                                    width: 30,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  const Expanded(
                                      child: Text(
                                    "Add to your Promocode",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 15,
                                        color: Colors.black),
                                  )),
                                  InkWell(
                                    child: Text(
                                      "Apply",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 15,
                                          color: getColorPrimary()),
                                    ),
                                    onTap: () {
                                      getStorage.write('Amount', PAY_AMOUNT);
                                      print("AMOUNT ISSS ===>");
                                      print(getStorage.read('Amount'));
                                      // var Product_Id =
                                      //     list2![0].productId.toString();
                                      //  getStorage.write("PID", Product_Id);
                                      //print(Product_Id);
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType.fade,
                                              child: const Offers()));
                                      // Navigator.of(context).push(
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             const Offers()));
                                    },
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Visibility(
                          visible:
                              list2!.isEmpty && list!.isEmpty ? false : true,
                          child: Card(
                            elevation: 2,
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              decoration: ShapeDecoration(
                                color: const Color(0xffFFFFFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              7, 0, 0, 0),
                                          child: const Text(
                                            'Amount to pay',
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.currency_rupee,
                                              size: 18,
                                            ),
                                            Text(
                                              // if I set _total amount then Subcription Part was Automaticaly Set With Total everytime
                                              // newprice.toString() +
                                              //     _totalAmount.toString(),
                                              PAY_AMOUNT = "${_totalAmount}",

                                              style: const TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              7, 0, 0, 0),
                                          child: const Text(
                                            'Service fee',
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.currency_rupee,
                                              size: 18,
                                            ),
                                            Text(
                                              service_amount.toString(),
                                              style: const TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              7, 0, 0, 0),
                                          child: const Text(
                                            'Discount',
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              '-',
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  color: Color(0XFF286953)),
                                            ),
                                            const Icon(Icons.currency_rupee,
                                                size: 18,
                                                color: const Color(0XFF286953)),
                                            Text(
                                              // SHOW = "${D}"
                                              Discount_Price.toString(),
                                              style: const TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  color:
                                                      const Color(0XFF286953)),
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Total',
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 3,
                                            ),
                                            const Icon(Icons.currency_rupee,
                                                size: 18,
                                                color: Color(0XFF286953)),
                                            Text(
                                              PAY_AMOUNT2 =
                                                  "${_totalAmount + service_amount - Discount_Price}",
                                              style: const TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  color: Color(0XFF286953)),
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: Discount_Price != 0,
                                    child: Container(
                                      decoration: const ShapeDecoration(
                                          color: Color(0xffFCDA28),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(0),
                                                bottomRight:
                                                    Radius.circular(0)),
                                          )),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                                'images/Group 37736.png'),
                                            const Text(
                                              'You have saved ',
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            ),
                                            const Icon(Icons.currency_rupee,
                                                size: 15),
                                            Expanded(
                                              child: Text(
                                                Discount_Price.toString() +
                                                    ' on this order',
                                                style: const TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Visibility(
                          visible:
                              list2!.isEmpty && list!.isEmpty ? false : true,
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 1, color: getColorPrimary())),
                            padding: const EdgeInsets.all(0),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Expanded(
                                        child: Text(
                                      "Delivered To",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    InkWell(
                                        onTap: () {
                                          _bottomsheet(context);
                                        },
                                        child: Text(
                                          "Change",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontSize: 15,
                                              color: getColorPrimary()),
                                        )),
                                    const SizedBox(
                                      width: 20,
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
                                      width: 20,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 3, 0, 0),
                                          child: Image.asset(
                                            "images/location.png",
                                            height: 30,
                                            width: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Expanded(
                                        child: Text(
                                      _addressString.toString() == "" ||
                                              _addressString.toString() ==
                                                  "null"
                                          ? "No Address Found"
                                          : _addressString.toString(),
                                      style: const TextStyle(
                                          fontFamily: "Poppins",
                                          color: Colors.black,
                                          fontSize: 17),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  decoration: const ShapeDecoration(
                                      color: Color(0xffFFFFFF),
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              width: 0,
                                              color: Color(0XFF286953)))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons
                                              .account_balance_wallet_outlined),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          const Icon(
                                              Icons.currency_rupee_outlined),
                                          Text(
                                            walletAmount.toString(),
                                            style: const TextStyle(
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    type:
                                                        PageTransitionType.fade,
                                                    child: const Wallet()));
                                          },
                                          child: const Text(
                                            'Top Up',
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                color: Color(0XFF286953),
                                                fontSize: 16),
                                          )),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 80,
                                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  decoration: BoxDecoration(
                                    color: getColorPrimary(),
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 13,
                                          ),
                                          Text(
                                            "Grand Total",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                color:
                                                    getColorFromHex("#BDD879"),
                                                fontSize: 20),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "₹" + PAY_AMOUNT2.toString(),
                                            style: const TextStyle(
                                                fontFamily: "Poppins",
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                        ],
                                      ),

                                      const Spacer(),
                                      InkWell(
                                        onTap: () {
                                          if (_addressString ==
                                              "No Address Found") {
                                            showCustomToast(
                                                "No address found pls select other address");
                                            return;
                                          }
                                          callApi();
                                          // Navigator.of(context).push(
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             CartCheckout(
                                          //                 UpdatedPrice,
                                          //                 widget._list!,
                                          //                 selectTime)));
                                        },
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          height: 65,
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 0),
                                          margin: const EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    height: 13,
                                                  ),
                                                  Text(
                                                    "Pay now",
                                                    style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      color: getColorFromHex(
                                                          "#000000"),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    PAY_AMOUNT2.toString(),
                                                    style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        color:
                                                            getColorPrimary(),
                                                        fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Image.asset(
                                                "images/dark_arrow.png",
                                                height: 20,
                                                width: 20,
                                              ),
                                              // SizedBox(width: 10,),
                                              // Text("Next",style: TextStyle(color:Colors.white,fontSize: 20),),
                                              // Spacer(),
                                              // Image.asset("images/next.png",height: 30,width: 30,),
                                              // SizedBox(width: 10,),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Spacer(),
                                      // Image.asset("images/next.png",height: 30,width: 30,),
                                      // SizedBox(width: 10,),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible:
                              list2!.isEmpty && list!.isEmpty ? true : false,
                          child: Center(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Flexible(
                                      child: Text(
                                          "Looks Like you have not added anything to your cart. Go ahead & explore top categories."),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            }),
          ),
        ),
      );

  Widget getSubscraptionSummary(int index) {
    //print("///////THIS Is A SubScription SUMMARY");
    double SubscriptionsecondPrice = 0;
    double Subscriptionmprice = 0;
    double Subscriptionprice = 0;

    double FinalSubscriptionprice = 0;
    String? Sdate;
    String? Edate;
    int FDate = 0;

    if (list2![index].volume.toString() != "" ||
        list2![index].volume.toString() != "null") {
      var str = list2![index].volume.toString();
      var parts = str.split(" ");
      var fValue = parts[0].trim();

      Sdate = list2![index].startDate.toString();
      Edate = list2![index].endDate.toString();
      DateTime dateTimeCreatedAt = DateTime.parse(Sdate.toString());

      DateTime dateTimeNow = DateTime.parse(Edate.toString());

      FDate = dateTimeNow.difference(dateTimeCreatedAt).inDays + 1;
      print("Days Difference " + FDate.toString());
      // int price= int.parse(list![index].price.toString()) * int.parse(list![index].quantity.toString());
      Subscriptionmprice =
          double.parse(list2![index].discountPrice.toString()) *
              double.parse(fValue);
      SubscriptionsecondPrice =
          double.parse(list2![index].discountPrice.toString()) *
              double.parse(fValue);
      Subscriptionprice =
          Subscriptionmprice * int.parse(list2![index].quantity.toString());
      FinalSubscriptionprice = Subscriptionprice * FDate;
      print(Subscriptionprice * FDate);
      print(FinalSubscriptionprice);

      FinalDate = FDate;
    }
    getStorage.write('SUBPIRCE', Subscriptionmprice);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        list2![index].productImage.toString() == "" ||
                                list2![index].productImage.toString() == "null"
                            ? noImage
                            : list2![index].productImage.toString(),
                        scale: 1.2,
                        width: 100,
                        height: 100,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          list2![index].productName.toString(),
                          style: const TextStyle(
                              fontFamily: "Poppins", fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          decoration: const ShapeDecoration(
                              color: Color(0xffFCDA28),
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 0, color: Color(0xff9D9FA1)))),
                          child: Center(
                              child: Text(
                                  '${list2![index].discount.toString()} % Off',
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 14,
                                  ))),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          list2![index].volume.toString(),
                          style: const TextStyle(
                              fontFamily: "Poppins", fontSize: 14),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        // Row(
                        //   children: [
                        //     IconButton(
                        //         onPressed: () {
                        //           // if (list2![index].quantity != "0") {
                        //           //   // setState(() {
                        //           //   //   int quentity =
                        //           //   //       int.parse(list2![index].quantity!) -
                        //           //   //           1;
                        //           //   //   list2![index].quantity =
                        //           //   //       quentity.toString();

                        //           //   //   // price=price - int.parse(list![index].price.toString());
                        //           //   //   Subscriptionprice =
                        //           //   //       SubscriptionsecondPrice * quentity;
                        //           //   // });
                        //           // }
                        //         },
                        //         icon: Image.asset("images/remove.png")),
                        //     const SizedBox(
                        //       width: 3,
                        //     ),
                        //     Text(
                        //       list2![index].quantity.toString(),
                        //       style: const TextStyle(
                        //           fontSize: 12, fontWeight: FontWeight.w500),
                        //     ),
                        //     const SizedBox(
                        //       width: 3,
                        //     ),
                        //     IconButton(
                        //         onPressed: () {
                        //           setState(() {
                        //             int quentity =
                        //                 int.parse(list2![index].quantity!) + 1;
                        //             list2![index].quantity =
                        //                 quentity.toString();
                        //             // price=price + int.parse(list![index].price.toString());
                        //             Subscriptionprice =
                        //                 SubscriptionsecondPrice * quentity;
                        //           });
                        //         },
                        //         icon: Image.asset("images/add.png")),
                        //   ],
                        // ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    // IconButton(
                    //     onPressed: () {
                    //       Navigator.of(context)
                    //           .push(MaterialPageRoute(
                    //         builder: (context) => Cart(),
                    //       ));
                    //     },
                    //     icon: Image.asset(
                    //         "images/Group 37743.png")),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     const Icon(
                    //       Icons.currency_rupee,
                    //       color: Color(0XFF286953),
                    //     ),
                    //     Text(
                    //       list2![index].price.toString(),
                    //       style: const TextStyle(
                    //           fontSize: 18,
                    //           fontWeight: FontWeight.w500,
                    //           color: Color(0XFF286953)),
                    //     ),
                    //   ],
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            Text(
                              "₹ " + FinalSubscriptionprice.toString(),
                              style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0XFF286953)),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            RefreshIndicator(
                              onRefresh: refresh,
                              child: InkWell(
                                child: const ImageIcon(
                                  AssetImage(
                                    "images/ic_delete9.png",
                                  ),
                                  color: Color(0XFF286953),
                                ),
                                onTap: () {
                                  setState(() {
                                    subremoveCart(list2![index].id!);
                                    list2!.removeAt(index);

                                    UpdatedPrice = 0;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),

                            // InkWell(
                            //   child: Image.asset("images/ic_delete.png",
                            //       height: 30, width: 30),
                            //   onTap: () {
                            //     setState(() {
                            //       removeCart(list2![index].productId!);
                            //       list2!.removeAt(index);
                            //     });
                            //   },
                            // )
                          ],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.shopping_bag_outlined),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Quantity per day',
                      style: TextStyle(fontFamily: "Poppins", fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          // if (list2![index].quantity != "0") {
                          //   setState(() {
                          //     int quentity =
                          //         int.parse(list2![index].quantity!) - 1;
                          //     list2![index].quantity = quentity.toString();

                          //     // price=price - int.parse(list![index].price.toString());
                          //     Subscriptionprice =
                          //         SubscriptionsecondPrice * quentity;
                          //   });
                          // }
                        },
                        icon: Image.asset("images/cart_minus.png")),
                    Text(
                      list2![index].quantity.toString(),
                      style: const TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    IconButton(
                        onPressed: () {
                          // setState(() {
                          //   int quentity =
                          //       int.parse(list2![index].quantity!) + 1;
                          //   list2![index].quantity = quentity.toString();
                          //   // price=price + int.parse(list![index].price.toString());
                          //   Subscriptionprice =
                          //       SubscriptionsecondPrice * quentity;
                          // });
                        },
                        icon: Image.asset("images/cart_add.png")),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Repeat',
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ButtonTheme(
                          buttonColor: const Color(0XFF286953),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                side:
                                    const BorderSide(color: Color(0XFF286953)),
                                primary: const Color(0XFF286953),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            // shape: RoundedRectangleBorder(
                            //     side: const BorderSide(
                            //         color: Color(0XFF286953),
                            //         width: 1,
                            //         style: BorderStyle.solid),
                            //     borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              list2![index].subscriptionType.toString(),
                              style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Color(0xffFFFFFF)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // removingpricerefresh() {
  //   bool is_Loading = true;
  //   setState(() {
  //     print("++++++++++++++++++++++++++++++++++++++++++++++");

  //     // refresh();
  //     //  getCartDetail();
  //     print("Final Price is hurray");
  //   });
  // }

  Widget getProductSummary(int index) {
    double qu;
    // print("///////THIS Is A Product SUMMARY");

    double secondPrice = 0;
    double mprice = 0;
    double price = 0;
    if (list![index].volume.toString() != "" ||
        list![index].volume.toString() != "null") {
      var str = list![index].volume.toString();
      var parts = str.split(" ");
      var fValue = parts[0].trim();
      // print("Fvalu is " + fValue);

      // print(list);
      // int price= int.parse(list![index].price.toString()) * int.parse(list![index].quantity.toString());
      mprice = double.parse(list![index].discountPrice.toString()) *
          double.parse(fValue);
      secondPrice = double.parse(list![index].discountPrice.toString()) *
          double.parse(fValue);
      price = mprice * double.parse(list![index].quantity.toString());
      //newprice = price.toInt() + _GetProductTotalAmount;
      print("Current Product Price Is : " + price.toString());
      print("Current Get Product Total Price is :" +
          _GetProductTotalAmount.toString());
      //print("NEW PRICE -->" + newprice.toString());
      print("___________________");
      print("MPRICE" + mprice.toString());
      print("Secondprice" + secondPrice.toString());
      print("Price Is " + price.toString());
      print("___________________");
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Image.network(
                    list![index].productImage! == ""
                        ? noImage
                        : list![index].productImage!,
                    fit: BoxFit.cover,
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                        alignment: Alignment.topLeft,
                        child: Text(
                          list![index].productName.toString(),
                          style: const TextStyle(
                              fontFamily: "Poppins", fontSize: 16),
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          list![index].volume.toString(),
                          style: const TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                              color: Color(0xff8C8C8C)),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          // remove  Button
                          RefreshIndicator(
                            onRefresh: refresh,
                            child: IconButton(
                                onPressed: () {
                                  if (list![index].quantity != "1") {
                                    setState(() {
                                      int quentity =
                                          int.parse(list![index].quantity!) - 1;
                                      list![index].quantity =
                                          quentity.toString();
                                      decrement();
                                      // // price=price - int.parse(list![index].price.toString());
                                      // UpdatedPrice =
                                      //     secondPrice.toInt() * quentity;
                                      // new_price = UpdatedPrice;

                                      // print("^^^^" +
                                      //     _GetProductTotalAmount.toString());
                                      // print("Total Amount is  :" +
                                      //     _totalAmount.toString());
                                      // print("PAY NOW AMOUNT" +
                                      //     PAY_AMOUNT.toString());
                                      // print("New Price is Here For removing :" +
                                      //     new_price.toString());
                                      // print(UpdatedPrice);
                                      // //  print(price);
                                      // print("Removing Prices" +
                                      //     _RemovingUpdatePrice.toString());

                                      //print(price);
                                    });
                                  }
                                },
                                icon: Image.asset(
                                  "images/minus.png",
                                  width: 20,
                                )),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(
                            list![index].quantity.toString(),
                            style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            width: 3,
                          ),

                          /// Add Button
                          RefreshIndicator(
                            onRefresh: refresh,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  int quentity =
                                      int.parse(list![index].quantity!) + 1;
                                  list![index].quantity = quentity.toString();

                                  // // price=price + int.parse(list![index].price.toString());
                                  // // for (int i = 0;
                                  // //     i <
                                  // //         int.parse(list![i]
                                  // //             .discountPrice
                                  // //             .toString());
                                  // //     i++) {
                                  // //   print("hulalallalalalala");
                                  // //   print(int.parse(list![i]
                                  // //           .discountPrice
                                  // //           .toString()) *
                                  // //       int.parse(
                                  // //           list![i].quantity.toString()));
                                  // // }

                                  // UpdatedPrice =
                                  //     secondPrice.toInt() * quentity;
                                  // newprice =
                                  //     _GetProductTotalAmount + price.toInt();
                                  // print("^^^^" +
                                  //     _GetProductTotalAmount.toString());
                                  // print("Price Is -->" +
                                  //     price.toString()); //100
                                  // print("Current Price -->" +
                                  //     UpdatedPrice.toString()); //200
                                  // print("*****");
                                  // print("New Price -->" +
                                  //     newprice.toString()); //200
                                  // print("Get Product Amount when Adding " +
                                  //     _GetProductTotalAmount
                                  //         .toString()); //100
                                  // print(PAY_AMOUNT); //245
                                  // print("Subscriptional Total Amount : -->" +
                                  //     _SubscriptionTotalAmount.toString());
                                  // print("Total Amount To Pay" +
                                  //     _totalAmount.toString());
                                  // print("rEMOVING pRICE" +
                                  //     _RemovingUpdatePrice.toString());

                                  // totalbalance = price.toInt() + _totalAmount;
                                  // print("Total Balance is " +
                                  //     totalbalance.toString());

                                  // print(price);
                                  increment();
                                });
                              },
                              icon: Image.asset(
                                "images/plus.png",
                                width: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                RefreshIndicator(
                  onRefresh: refresh,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          Text(
                            "₹ " + price.toString(),
                            style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color(0XFF286953)),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          RefreshIndicator(
                            onRefresh: refresh,
                            child: InkWell(
                              child: ImageIcon(
                                AssetImage(
                                  "images/ic_delete9.png",
                                ),
                                color: Color(0XFF286953),
                              ),
                              onTap: () {
                                setState(() {
                                  removeCart(list![index].id!);
                                  list!.removeAt(index);
                                  print("Totallly Hurrrrrruy  " +
                                      _totalAmount.toString());

                                  // removingpricerefresh();
                                  // UpdatedPrice = 0;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // String id = "";

  void getCartDetail() async {
    setState(() {
      _isLoading = true;
    });

    List<int> total2 = [];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    id = sharedPreferences.getString("id").toString();

    var api = APICallRepository();
    api.getCart(id.toString()).then((value) {
      setState(() {
        _isLoading = false;

        print("==RESPONSE=>" + value.toString());
        var model = CartModel.fromJson(jsonDecode(value));

        list!.clear();
        list!.addAll(model.cart!);
        list2!.clear();
        list2!.addAll(model.subscriptionCart!);

        List<int> total = [];
        for (int i = 0; i < list!.length; i++) {
          print("===>PRINT==>" + list![i].quantity.toString());
          total.add(
              int.parse(list![i].volume!.replaceAll(RegExp(r'[^0-9]'), '')) *
                  int.parse((list![i].discountPrice!)) *
                  int.parse(list![i].quantity.toString()));
          print(list!.length);
          print(total);
        }

        for (int j = 0; j < total.length; j++) {
          print("Price in loop" + price.toString());
          price += total[j];
        }
        print("***************");
        print("Total Amount Get :" + total.toString());

        print("Product Total When User Enter In Cart" + total.toString());
        print("Price === >" + price.toString());

        P_TOTAL = price.floor();

        print(
            "Total Amount Get Summary : " + _GetProductTotalAmount.toString());

        var SUB = getStorage.read('SUBPIRCE');
        print("SUB" + SUB.toString());

        list2!.clear();
        if (list2 != "null") {
          list2!.addAll(model.subscriptionCart!);
        }
        for (int i = 0; i < list2!.length; i++) {
          // if (flag) {}
          Startdate = list2![i].startDate.toString();
          Enddate = list2![i].endDate.toString();
          DateTime dateTimeCreatedAt = DateTime.parse(Startdate.toString());

          DateTime dateTimeNow = DateTime.parse(Enddate.toString());

          FinalDate = dateTimeNow.difference(dateTimeCreatedAt).inDays + 1;
          print("SOMETHING : ==>" + FinalDate.toString());
          total2.add(
              int.parse(list2![i].volume!.replaceAll(RegExp(r'[^0-9]'), '')) *
                  int.parse(list2![i].quantity.toString()) *
                  FinalDate *
                  int.parse(list2![i].discountPrice! == "null"
                      ? ""
                      : list2![i].discountPrice!));
          print("-->" + list2![i].volume!.replaceFirst('Ltr', ''));
          print(list2!.length);
          print(list2![i].quantity);
          print(list2![i].discountPrice);
        }

        print("Total Is : " + total2.toString());
        print("Get Cart : " + newprice.toString());

        for (int j = 0; j < total2.length; j++) {
          _SubscriptionTotalAmount += total2[j];
          // TotalSub = _SubscriptionTotalAmount * FinalDate;
          // print("After Calculation Original Subscription Total is " +
          //     TotalSub.toString());
        }

        // print("Total Amount Sub :" + total.toString());
        print(_SubscriptionTotalAmount);
        print("FINAL DATE IS ==> " + FinalDate.toString());

        // int.parse(boombooom.toString());
        // print("BOOOM BOOM RECEIVED");

        // _totalAmount = boombooom;

        print("RECEVING BOOMRAH AFTER MY AMOUNT IS");

        _totalAmount = price.floor() + _SubscriptionTotalAmount;

        print(_totalAmount);

        // IF DIP WAS GETTING NULL THAN RUNTIME ISSUE GENERATING
        print(
            "==================================================================================");
        var DIp;

        if (DIp != null) {
          Discount_Price = 0;

          print(DIp);
        } else {
          DIp = getStorage.read("DISCOUNT_PRICE");
          if (DIp != null) {
            print("HEYYYYYYYY YP " + _totalAmount.toString());
            //PERCENTAGE = _totalAmount * DIp / 100;
            print(DIp);
            print(PERCENTAGE);
            //  Discount_Price = _totalAmount - PERCENTAGE.floor();

            print(Discount_Price);
            FunctionalityDiscount = DIp;
            Discount_Price = FunctionalityDiscount;
          } else {
            Discount_Price = 0;
          }
          if (price_Limit == null) {
            pm = int.parse(price_Limit.toString());
            pm = 0;
          } else {
            pm = int.parse(price_Limit.toString());
          }
          if (_totalAmount <= int.parse(pm.toString())) {
            Discount_Price = 0;
            //showCustomToast("price must be" + price_Limit.toString());
          }
        }

        ////
        // if (_totalAmount >= int.parse(price_Limit.toString())){
        //   Discount_Price = DP;
        // }
        // else{
        //   Discount_Price =0;
        // }
        print(_totalAmount);
        print("Total Amount Is here Hurray");
        if (list!.isEmpty) {
          // showCustomToast("No Product Found...");
        }

        if (list2!.isEmpty) {
          // showCustomToast("No Subscribed Product Found");
        }
      });

      //UpdatedPrice = sharedPreferences.getInt("UpdatedPrice")!.toInt();
      //print(UpdatedPrice);
    }, onError: (error) {
      setState(() {
        _isLoading = false;
      });

      showCustomToast(error.toString());
    });
  }

  void increment() async {
    List<int> HABIBIAL = [];
    List<int> UPDATEQUANTITY = [];
    //var sum = 0;
    var A = 0;
    String? incre_update_id;
    String? incre_update_quantity;

    for (int i = 0; i < list!.length; i++) {
      print("ID IS -->" + list![i].id.toString());
      print("Quantitiy Is -->" + list![i].quantity.toString());

      incre_update_id = list![i].id.toString();
      incre_update_quantity = list![i].quantity.toString();
      print("*****************************");
      print("Lets Check this");
      print(incre_update_id);
      print(incre_update_quantity);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      id = sharedPreferences.getString("id").toString();
      print("At Api Call id Is " + incre_update_id.toString());
      print("at Api Call Quantity is " + incre_update_quantity.toString());

      var api = APICallRepository();
      api
          .updateCart(
              incre_update_id.toString(), incre_update_quantity.toString())
          .then((value) {
        var json = jsonDecode(value);

        String? message = json["message"];
        // showCustomToast(message.toString());
      });

      print("===>PRINT==>" + list![i].quantity.toString());
      HABIBIAL.add(int.parse((list![i].discountPrice!)) *
          int.parse(list![i].volume!.replaceAll(RegExp(r'[^0-9]'), '')) *
          int.parse(list![i].quantity.toString()));
      print(list!.length);
      print("Huleleleel");
      print(HABIBIAL);

      for (int j = 0; j < HABIBIAL.length; j++) {
        print("LENGTH iS " + HABIBIAL.length.toString());

        num sum = 0;
        for (num e in HABIBIAL) {
          sum += e;
        }
        incre_amount = sum.toInt();
        // print("Sum is " + sum.toString());
        print("Wallle Walle");
        print(sum);
        print("ALALALLALALA");
        print(incre_amount);

        _totalAmount = incre_amount + _SubscriptionTotalAmount;
        if (price_Limit == null) {
          pm = 0;
        } else {
          pm = int.parse(price_Limit.toString());
        }
        if (_totalAmount >= int.parse(pm.toString())) {
          Discount_Price = 0;
          var DIp = getStorage.read("DISCOUNT_PRICE");
          if (DIp == null) {
            Discount_Price = 0;
          } else {
            Discount_Price = 0;
          }

          // Discount_Price = DIp;
          //showCustomToast("price must be" + price_Limit.toString());
        }
        print("final Amount is here");
        print(_totalAmount);
      }
    }
  }

  void decrement() async {
    List<int> HABIBIAL = [];
    List<int> ALLL = [];
    //var sum = 0;
    var A = 0;
    String? decre_update_id;
    String? decre_update_quantity;

    for (int i = 0; i < list!.length; i++) {
      print("ID IS -->" + list![i].id.toString());
      print("Quantitiy Is -->" + list![i].quantity.toString());

      decre_update_id = list![i].id.toString();
      decre_update_quantity = list![i].quantity.toString();

      print("*****************************");
      print("Lets Check this");
      print(decre_update_id);
      print(decre_update_quantity);

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      id = sharedPreferences.getString("id").toString();
      print("At Api Call id Is " + decre_update_id.toString());
      print("at Api Call Quantity is " + decre_update_quantity.toString());

      var api = APICallRepository();
      api
          .updateCart(
              decre_update_id.toString(), decre_update_quantity.toString())
          .then((value) {
        var json = jsonDecode(value);

        String? message = json["message"];
        // showCustomToast(message.toString());
      });
      print("===>PRINT==>" + list![i].quantity.toString());
      print(HABIBIAL);
      HABIBIAL.add(int.parse((list![i].discountPrice!)) *
          int.parse(list![i].volume!.replaceAll(RegExp(r'[^0-9]'), '')) *
          int.parse(list![i].quantity.toString()));
      print(HABIBIAL);
      print(list!.length);
      // ALLL = HABIBIAL.removeAt(list![i]);
      print(HABIBIAL);
      print(HABIBIAL.length);
      print("Decrement Amount");
      // HABIBIAL.removeLast();
      print(HABIBIAL);

      for (int j = 0; j < HABIBIAL.length; j++) {
        print("LENGTH iS " + HABIBIAL.length.toString());

        num sum = 0;
        for (num e in HABIBIAL) {
          sum += e;
        }
        decre_amount = sum.toInt();
        // print("Sum is " + sum.toString());
        print("Decrement function is working ");
        print(sum);
        print("Decremnt Amount is here");
        print(decre_amount);
        _totalAmount = decre_amount + _SubscriptionTotalAmount;

        var DIp = getStorage.read("DISCOUNT_PRICE");
        var C_id = getStorage.read("Coupon_id");

        Coupon_ID = C_id;
        if (DIp == null) {
          Discount_Price = 0;
        } else {
          Discount_Price = 0;
        }
        if (price_Limit == null) {
          // pm = int.parse(price_Limit.toString());
          pm = 0;
        } else {
          pm = int.parse(price_Limit.toString());
        }
        if (_totalAmount <= int.parse(pm.toString())) {
          Discount_Price = 0;
          //showCustomToast("price must be" + price_Limit.toString());
        }

        print("final Amount is here");
        print(_totalAmount);
      }
    }
  }

  // void isloading() {
  //   final timer = Timer(
  //     const Duration(seconds: 2),
  //     () {
  //       // Navigate to your favorite place
  //     },
  //   );
  // }

  void removeCart(String id) {
    // _isLoading = true;
//     if (!_isLoading) {
//       Future.delayed(const Duration(milliseconds: 500), () {
// // Here you can write your code

//         setState(() {
//           getProgressBar();
//         });
//       });
//     } else {}
    setState(() {
      //  Discount_Price = 0;
      print("=====>ID==>" + id.toString());

      var api = APICallRepository();
      api.removeCart(id).then((value) {
        var json = jsonDecode(value);

        String message = json["message"];
        //showCustomToast(message.toString());

        List<int> HABIBIAL = [];
        List<int> ALLL = [];
        //var sum = 0;
        var A = 0;

        for (int i = 0; i < list!.length; i++) {
          print("===>PRINT==>" + list![i].quantity.toString());
          print(HABIBIAL);
          HABIBIAL.add(int.parse((list![i].discountPrice!)) *
              int.parse(list![i].volume!.replaceAll(RegExp(r'[^0-9]'), '')) *
              int.parse(list![i].quantity.toString()));
          print(HABIBIAL);
          print(list!.length);
          // ALLL = HABIBIAL.removeAt(list![i]);
          print(HABIBIAL);
          print(HABIBIAL.length);
          print("Decrement Amount");
          // HABIBIAL.removeLast();
          print(HABIBIAL);

          for (int j = 0; j < HABIBIAL.length; j++) {
            print("LENGTH iS " + HABIBIAL.length.toString());

            num sum = 0;
            for (num e in HABIBIAL) {
              sum += e;
            }
            remove_amount = sum.toInt();
            // print("Sum is " + sum.toString());
            print("HURRRRAY function is working ");
            print(sum);
            print("HURRRRAY Amount is here");
            print(remove_amount);
            _totalAmount = remove_amount + _SubscriptionTotalAmount;

            print("Totallly Hurrrrrruy" + _totalAmount.toString());
            print("BINGOOOOO");
            print(_totalAmount);

            boombooom = _totalAmount;
            print("BOOOM BOOM Bumrah" + boombooom.toString());
            //_isLoading = false;
          }
        }
      }, onError: (error) {
        showCustomToast("$error");
      });
    });
    // getCartDetail();
    setState(() {
      // Discount_Price = 0;
      // if (_totalAmount >= int.parse(price_Limit.toString())) {
      //   Discount_Price = 0;
      // } else if (_totalAmount <= int.parse(price_Limit.toString())) {
      //   Discount_Price = 0;
      // }
      print(Discount_Price);
    });
    print("new total Amount");
    print(_totalAmount);

    refreshing();

    //boombooom = _totalAmount;
  }

  void subremoveCart(String id) {
    setState(() {
      //  Discount_Price = 0;
      print("=====>ID==>" + id.toString());

      var api = APICallRepository();
      api.removeCart(id).then((value) {
        var json = jsonDecode(value);

        String message = json["message"];
        showCustomToast(message.toString());
        // if (list2 == null) {
        //   _totalAmount = P_TOTAL;
        //   print('_totalAmount ' + _totalAmount.toString());
        // }
        print("=========================IDHOVJVXJH V ===================");

        List<int> HABIBIAL = [];
        List<int> ALLL = [];
        //var sum = 0;
        var A = 0;

        for (int i = 0; i < list2!.length; i++) {
          Startdate = list2![i].startDate.toString();
          Enddate = list2![i].endDate.toString();
          DateTime dateTimeCreatedAt = DateTime.parse(Startdate.toString());

          DateTime dateTimeNow = DateTime.parse(Enddate.toString());

          FinalDate = dateTimeNow.difference(dateTimeCreatedAt).inDays + 1;
          print("AT SUBSCRUIPTION FINAL DATE IS: ==>" + FinalDate.toString());

          print("===>PRINT==>" + list2![i].quantity.toString());
          print(HABIBIAL);
          HABIBIAL.add(int.parse((list2![i].discountPrice!)) *
              int.parse(list2![i].volume!.replaceAll(RegExp(r'[^0-9]'), '')) *
              FinalDate *
              int.parse(list2![i].quantity.toString()));
          print(HABIBIAL);
          print(list2!.length);
          // ALLL = HABIBIAL.removeAt(list![i]);
          print(HABIBIAL);
          print(HABIBIAL.length);

          // HABIBIAL.removeLast();
          print(HABIBIAL);

          print("LENGTH iS " + HABIBIAL.length.toString());

          num sum = 0;
          for (num e in HABIBIAL) {
            sum += e;
          }
          remove_amount = sum.toInt();
          print("What Is removing " + remove_amount.toString());
          print(remove_amount);
          // print("Sum is " + sum.toString());
          print("BAM BAM BOLE ");
          print(sum);
          print("DHINKHYAUUUUUUUUU");
          print(remove_amount);

          _totalAmount = P_TOTAL + remove_amount;

          print("Price Total Is == >" + P_TOTAL.toString());
          print("Subscription Price Is ==> " +
              _SubscriptionTotalAmount.toString());

          print("Totallly Hurrrrrruy" + _totalAmount.toString());
          print("BINGOOOOO");
          print(_totalAmount);

          boombooom = _totalAmount;
          print("BOOOM BOOM Bumrah" + boombooom.toString());

          // if(i ==0 ){

          // }

          //_isLoading = false;
        }
        if (list2!.isEmpty) {
          print("THY CHE BRO");
          _totalAmount = P_TOTAL;
        } else {
          print("Sry bro");
        }

        print(P_TOTAL);
        print(
            "===================================================================================");
        print("OTOT" + _totalAmount.toString());
      }, onError: (error) {
        showCustomToast("$error");
      });
    });
    // getCartDetail();
    setState(() {
      // Discount_Price = 0;
      // if (_totalAmount >= int.parse(price_Limit.toString())) {
      //   Discount_Price = 0;
      // } else if (_totalAmount <= int.parse(price_Limit.toString())) {
      //   Discount_Price = 0;
      // }
      print(Discount_Price);
    });
    print("new total Amount");
    print(_totalAmount);

    refreshing();

    //boombooom = _totalAmount;
  }

  void refreshing() {
    _isLoading = true;
    Future.delayed(const Duration(seconds: 5), () {
      CircularProgressIndicator(
        color: greencolor,
      );
      getId();
      setState(() {});

      //  Discount_Price = 0;

      // Discount_Price = 0;

      _isLoading = false;
    });
  }

  Container openDatePicker() {
    print("==>TAP");
    return Container(
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.dateAndTime,
        onDateTimeChanged: (value) {
          print("Your Selected Date: ${value.day}");
        },
      ),
    );
  }

  // _product() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(vertical: 5),
  //     width: double.infinity,
  //     // height: 105,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(4),
  //       // boxShadow:  [
  //       //   BoxShadow(
  //       //     blurRadius: 2,
  //       //     color: Colors.black12,
  //       //   )
  //       // ]
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
  //       child: Row(
  //         children: [
  //           Image.asset(
  //             'images/image 40.png',
  //             scale: 0.9,
  //           ),
  //           const SizedBox(
  //             width: 5,
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const Text(
  //                   'Swadist Soyabean Oil',
  //                   style: TextStyle(color: Colors.black, fontSize: 18),
  //                 ),
  //                 // SizedBox(height: 8,),
  //                 const Text(
  //                   '1 ltr',
  //                   style: TextStyle(
  //                       color: Color(
  //                         0xff8C8C8C,
  //                       ),
  //                       fontSize: 16),
  //                 ),
  //                 const SizedBox(
  //                   height: 5,
  //                 ),
  //                 Row(
  //                   children: [
  //                     GestureDetector(
  //                       child: Image.asset('images/Group 76.png'),
  //                     ),
  //                     const SizedBox(
  //                       width: 8,
  //                     ),
  //                     const Text(
  //                       '1',
  //                       style: TextStyle(fontSize: 20),
  //                     ),
  //                     const SizedBox(
  //                       width: 8,
  //                     ),
  //                     Image.asset('images/Group 75.png')
  //                     // GestureDetector(
  //                     //   child: CircleAvatar(
  //                     //     backgroundColor: Color(0XFF286953),
  //                     //     child: Image.asset('images/Group 75.png')
  //                     //   ),
  //                     // )
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //           const SizedBox(
  //             width: 12,
  //           ),
  //           Row(
  //             children: const [
  //               Icon(
  //                 Icons.currency_rupee,
  //                 size: 15,
  //                 color: Color(0XFF286953),
  //               ),
  //               Text(
  //                 '190.00',
  //                 style: TextStyle(
  //                     fontSize: 18,
  //                     color: Color(0XFF286953),
  //                     fontWeight: FontWeight.w500),
  //               ),
  //             ],
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
  // void _bottomsheet(BuildContext context) {
  //   showBottomSheet(
  //       backgroundColor: Colors.white,
  //       context: context,
  //       shape: const RoundedRectangleBorder(
  //         // <-- SEE HERE
  //         borderRadius: BorderRadius.vertical(
  //           top: Radius.circular(25.0),
  //         ),
  //       ),
  //       builder: (context) {
  //         return Container(
  //           margin: const EdgeInsets.fromLTRB(16, 20, 16, 15),
  //           width: double.infinity,

  //           //height: MediaQuery.of(context).size.height * 0.46,
  //           child: SingleChildScrollView(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const Text(
  //                   'Select Address',
  //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  //                 ),
  //                 const SizedBox(
  //                   height: 15,
  //                 ),
  //                 // SizedBox(
  //                 //   height: 60,
  //                 //   child: TextField(
  //                 //       controller: emailController,
  //                 //       keyboardType: TextInputType.text,
  //                 //       style: const TextStyle(
  //                 //         color: Colors.black,
  //                 //       ),
  //                 //       decoration: InputDecoration(
  //                 //         focusedBorder: OutlineInputBorder(
  //                 //           borderSide: const BorderSide(color: Colors.green),
  //                 //           borderRadius: BorderRadius.circular(10),
  //                 //         ),
  //                 //         enabledBorder: OutlineInputBorder(
  //                 //           borderSide: const BorderSide(color: Colors.green),
  //                 //           borderRadius: BorderRadius.circular(10),
  //                 //         ),
  //                 //         floatingLabelStyle:
  //                 //             TextStyle(color: getColorPrimary()),
  //                 //         filled: true,
  //                 //         fillColor: const Color(0xffEFF1F4),
  //                 //         prefixIcon: Icon(
  //                 //           Icons.location_on_outlined,
  //                 //           color: getColorFromHex("#9D9FA2"),
  //                 //         ),
  //                 //         border: OutlineInputBorder(
  //                 //           borderSide:
  //                 //               const BorderSide(color: Color(0xffAAAAAA)),
  //                 //           borderRadius: BorderRadius.circular(10),
  //                 //         ),
  //                 //         labelText: "Email Address",
  //                 //         hintStyle: const TextStyle(
  //                 //           color: Color(0xffAAAAAA),
  //                 //           fontSize: 13,
  //                 //         ),
  //                 //       )),
  //                 // ),

  //                 const SizedBox(
  //                   height: 10,
  //                 ),
  //                 SizedBox(
  //                   height: 60,
  //                   child: TextField(
  //                       //  controller: addressController,
  //                       keyboardType: TextInputType.multiline,
  //                       style: const TextStyle(
  //                         color: Colors.black,
  //                       ),
  //                       decoration: InputDecoration(
  //                         focusedBorder: OutlineInputBorder(
  //                           borderSide: const BorderSide(color: Colors.green),
  //                           borderRadius: BorderRadius.circular(10),
  //                         ),
  //                         enabledBorder: OutlineInputBorder(
  //                           borderSide: const BorderSide(color: Colors.green),
  //                           borderRadius: BorderRadius.circular(10),
  //                         ),
  //                         floatingLabelStyle:
  //                             TextStyle(color: getColorPrimary()),
  //                         filled: true,
  //                         fillColor: const Color(0xffEFF1F4),
  //                         prefixIcon: Icon(
  //                           Icons.other_houses_outlined,
  //                           color: getColorFromHex("#9D9FA2"),
  //                         ),
  //                         border: OutlineInputBorder(
  //                           borderSide:
  //                               const BorderSide(color: Color(0xffAAAAAA)),
  //                           borderRadius: BorderRadius.circular(10),
  //                         ),
  //                         labelText: "Complete Address",
  //                         hintStyle: const TextStyle(
  //                           color: Color(0xffAAAAAA),
  //                           fontSize: 13,
  //                         ),
  //                       )),
  //                 ),
  //                 const SizedBox(
  //                   height: 10,
  //                 ),
  //                 SizedBox(
  //                   height: 60,
  //                   child: TextField(
  //                       // controller: newarbyController,
  //                       keyboardType: TextInputType.text,
  //                       style: const TextStyle(
  //                         color: Colors.black,
  //                       ),
  //                       decoration: InputDecoration(
  //                         focusedBorder: OutlineInputBorder(
  //                           borderSide: const BorderSide(color: Colors.green),
  //                           borderRadius: BorderRadius.circular(10),
  //                         ),
  //                         enabledBorder: OutlineInputBorder(
  //                           borderSide: const BorderSide(color: Colors.green),
  //                           borderRadius: BorderRadius.circular(10),
  //                         ),
  //                         floatingLabelStyle:
  //                             TextStyle(color: getColorPrimary()),
  //                         filled: true,
  //                         fillColor: const Color(0xffEFF1F4),
  //                         prefixIcon: Icon(
  //                           Icons.maps_home_work_outlined,
  //                           color: getColorFromHex("#9D9FA2"),
  //                         ),
  //                         border: OutlineInputBorder(
  //                           borderSide:
  //                               const BorderSide(color: Color(0xffAAAAAA)),
  //                           borderRadius: BorderRadius.circular(10),
  //                         ),
  //                         labelText: "Nearby Landmark (Optional)",
  //                         hintStyle: const TextStyle(
  //                           color: Color(0xffAAAAAA),
  //                           fontSize: 13,
  //                         ),
  //                       )),
  //                 ),
  //                 const SizedBox(
  //                   height: 10,
  //                 ),
  //                 SizedBox(
  //                   height: 60,
  //                   child: TextFormField(
  //                     maxLength: 6,
  //                     // controller: pincodeController,
  //                     keyboardType: TextInputType.number,
  //                     style: const TextStyle(
  //                       color: Colors.black,
  //                     ),
  //                     decoration: InputDecoration(
  //                       focusedBorder: OutlineInputBorder(
  //                         borderSide: const BorderSide(color: Colors.green),
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                       enabledBorder: OutlineInputBorder(
  //                         borderSide: const BorderSide(color: Colors.green),
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                       floatingLabelStyle: TextStyle(color: getColorPrimary()),
  //                       counterText: "",
  //                       filled: true,
  //                       fillColor: const Color(0xffEFF1F4),
  //                       prefixIcon: Icon(
  //                         Icons.maps_home_work_outlined,
  //                         color: getColorFromHex("#9D9FA2"),
  //                       ),
  //                       border: OutlineInputBorder(
  //                         borderSide:
  //                             const BorderSide(color: Color(0xffAAAAAA)),
  //                         borderRadius: BorderRadius.circular(10),
  //                       ),
  //                       labelText: "PIN Code",
  //                       hintStyle: const TextStyle(
  //                         color: Color(0xffAAAAAA),
  //                         fontSize: 13,
  //                       ),
  //                     ),
  //                     validator: (value) {
  //                       if (value!.isEmpty) {
  //                         return "password cannot be empty";
  //                       } else if (value.length < 6) {
  //                         return "password length should be atleast 6";
  //                       }
  //                       return null;
  //                     },
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   height: 15,
  //                 ),
  //                 !_isLoading
  //                     ? SizedBox(
  //                         height: 45,
  //                         width: double.infinity,
  //                         child: ButtonTheme(
  //                           shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(10)),
  //                           child: ElevatedButton(
  //                             style: ElevatedButton.styleFrom(
  //                               primary: const Color(0XFF286953),
  //                             ),
  //                             onPressed: () {
  //                               callApi();
  //                             },
  //                             //textColor: Colors.white,
  //                             child: const Text(
  //                               "Save Address",
  //                               style: TextStyle(
  //                                   fontSize: 16, fontWeight: FontWeight.w500),
  //                             ),
  //                           ),
  //                         ),
  //                       )
  //                     : Center(child: getProgressBar()),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  void _bottomsheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            //color: Colors.white,
            // height: 320,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Select Address',
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        // setState(() {
                        //   Clicked1 = !Clicked1;
                        //   Clicked2 = false;
                        // });
                        // _addressString = address1.text.toString();
                        // Navigator.of(context).pop();
                      });
                    },
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: getColorFromHex("#EFF1F4"),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              Clicked1 = !Clicked1;
                              //Clicked2 = false;
                              _addressString = address1.text.toString();
                              Navigator.of(context).pop();
                              print(_addressString);
                              getAddress();
                            });
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => Set_delivery_locaton()));
                          },
                          child: TextField(
                            maxLines: 3,
                            keyboardType: TextInputType.multiline,
                            style: const TextStyle(
                                fontFamily: "Poppins", color: Colors.black),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Address 1',
                            ),
                            controller: address1,
                            enabled: false,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        // Clicked1 = false;
                        // Clicked2 = !Clicked2;
                        // _addressString = address2.text.toString();
                        // Navigator.of(context).pop();
                      });
                    },
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: getColorFromHex("#EFF1F4"),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              Clicked2 = !Clicked2;
                              _addressString = address2.text.toString();

                              Navigator.of(context).pop();
                              print(_addressString);
                            });
                            // Clicked1 = false;

                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => Address2()));
                          },
                          child: TextField(
                            maxLines: 3,
                            keyboardType: TextInputType.multiline,
                            style: const TextStyle(
                                fontFamily: "Poppins", color: Colors.black),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Address 2',
                            ),
                            controller: address2,
                            enabled: false,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ButtonTheme(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0XFF286953)),
                        onPressed: () {
                          // callApi();
                        },
                        //  textColor: Colors.white,
                        child: const Text(
                          "Save Address",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void callApi() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("id").toString();

    getStorage.read("");
    var subtype = getStorage.read("subscriptiontype");
    var concate = getStorage.read("concate");
    var startdate = getStorage.read("startdate");
    var enddate = getStorage.read("enddate");
    // var product_new_price = _model!.normalPrice.toString();
    // var product_quantity = _model!.quantityAvailable.toString();

    // secondPrice = double.parse(product_new_price);

    print(concate);
    print(startdate);
    print(enddate);
    print(subtype);

    // var concaete = StringBuffer();
    // secondList.forEach((element) {
    //   concaete.write("$element,");
    // });

    // print(
    //     "===>CONCATE RESPONSE==>${concaete.toString().substring(0, concaete.toString().length - 1)}");

    if (walletAmount == 0) {
      showCustomToast("No Wallet Balance");
      return;
    }
    // }
    // if (productvolume == "") {
    //   showCustomToast("Please Select Volume");
    //   return;
    // }
    // if (quentity == 0) {
    //   showCustomToast("please Select quentity");
    //   return;
    // }

    // if (secondList.isEmpty) {
    //   showCustomToast("Please Select Repet date");
    //   return;
    // }

    // if (subscribeType == "") {
    //   showCustomToast("Please Select Duration");
    //   return;
    // }

    if (date == "") {
      showCustomToast("Please select Date");
      return;
    }
    if (selectTime == "") {
      showCustomToast("Please select Time");
      return;
    }
    // if (endDate == "") {
    //   showCustomToast("Please select End Date");
    //   return;
    // }

    // secondPrice = double.parse(product_new_price);
    // int fprice = int.parse(product_quantity) * int.parse(product_new_price);
    // if (walletAmount < fprice) {
    //   showCustomToast("insuffceint Balance");
    //   return;
    // }

    // setState(() {
    //   _isLoading = true;
    // });

    if (list2 == null) {
      print("===>id$id");
      print("===>Product id=>${list2![0].productId}");
      print("===>Product id=>${list2![0].quantity}");
      print("===>Product id=>$concate");
      print("===>SUBSCRIBE TYPE==>$subtype");
      print("===DATE==>$startdate");
      print("====EndDate==>$enddate");
      print("Select date & time is -->" + date.toString());

      var Product_Id = list2![0].productId.toString();
      getStorage.write("PID", Product_Id);
      print(Product_Id);

      var api = APICallRepository();
      api
          .addSubscrption(
        id.toString(),
        '',
        list2![0].quantity.toString(),
        startdate.toString(),
        concate.toString().substring(0, concate.toString().length - 1),
        subtype.toString(),
        enddate.toString(),
        price.toString(),
        list2![0].volume.toString(),
      )
          .then((value) {
        print(value);
        setState(() {
          _isLoading = false;
        });
      }, onError: (error) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        showCustomToast(error.toString());
      });
    }

    //print("Combine String is ==>" + Combinelist.toString());

    var api = APICallRepository();
    String? B;
    api.addOrder(id, selectTime.toString(), Coupon_ID.toString()).then((value) {
      var json = jsonDecode(value);
      print(value);

      String message = json["messaage"];
      if (message == "Not Sufficient Balance in Wallet") {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade, child: const Wallet()));
        showCustomToast("Payment Failed");
      } else {
        getStorage.remove("DISCOUNT_PRICE");
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade, child: OrderSuccessScreen()));
      }
      showCustomToast(message.toString());
      if (message == "Order added Successfully") {
        transaction_status = "Success";
      } else {
        transaction_status = "Failed";
      }
      print(message);
      if (message == json["messaage"]) {
        print(" ==>" + id);
        print(" ==>" + price.toString());
        //print(" ==>" + Combinelist.toString());
        print(" ==>" + transaction_status.toString());

        List<String> FINALE = [];
        List<int> COMBILE = [];
        //var sum = 0;
        var A = 0;

        for (var i = 0; i < list!.length; i++) {
          print("===>PRINT==>" + list![i].productName.toString());
          print(FINALE);
          FINALE.add(list![i].productName.toString());
          print(FINALE);
          print(list!.length);
          list![i].discountPrice.toString();

          int Transaction_Price = 0;
          Transaction_Price = ((int.parse(list![0].discountPrice.toString())) *
              (int.parse(list![i].quantity.toString())) *
              (int.parse(list![i].volume!.replaceAll(RegExp(r'[^0-9]'), ''))));
          // Transaction_Price = int.parse(
          //   list![i].discountPrice.toString() *
          //       int.parse(list![i].volume!.replaceAll(RegExp(r'[^0-9]'), '')) *
          //       int.parse(list![i].quantity.toString()),
          // );
          print("TRANSACTION PRICE IS " + Transaction_Price.toString());

          print(
              "------------------------------------------------------------------");
          print("HUrray " + list![i].discountPrice.toString());
          print(int.parse(list![i].volume!.replaceAll(RegExp(r'[^0-9]'), '')));
          print(int.parse(list![i].quantity.toString()));
          // ALLL = HABIBIAL.removeAt(list![i]);
          print(FINALE);
          print(FINALE.length);
          print("Decrement Amount");
          // HABIBIAL.removeLast();
          print(FINALE);

          print("BAM ===> " + B.toString());

          api
              .addUserTransation(
            id,
            Transaction_Price.toString(),
            list![0].productId.toString(),
            transaction_status.toString(),
            "Order " + list![i].productName.toString(),
            // Combinelist.toString(),
          )
              .then((value) {
            print("This Is Value ==>" + value);
            setState(() {
              _isPaymentProcess = false;
            });
          }, onError: (error) {
            setState(() {
              _isPaymentProcess = false;
            });

            showCustomToast(error.toString());
            print("ERROR " + error.toString());
            showCustomToast("Payment Failed");
          });
        }

        print(FINALE);
        // print(list![0].productName);
        print(list![0].productId);
        // print(list2![0].productName);
        // print(list2![0].productName);

        // print(" ==>" + id);

        //var api = APICallRepository();

        // showCustomToast("Payment Failed");
      }
    }, onError: (error) {
      setState(() {
        _isLoading = false;
      });
      showCustomToast(error.toString());
    });
  }

  // Future<void> addToCart(String? id) async {
  //   if (widget._model.status != "Available") {
  //     showCustomToast("This product is currently not avalible");
  //     return;
  //   }
  //   if (productvolume == "") {
  //     showCustomToast("Please select volume");
  //     return;
  //   }
  //   if (quentity == 0) {
  //     showCustomToast("Please Add Some Quenity");
  //     return;
  //   }

  //   SharedPreferences _prefs = await SharedPreferences.getInstance();
  //   String userId = _prefs.getString("id").toString();
  //   var api = APICallRepository();
  //   api
  //       .addToCart(userId, id.toString(), quan.toString(), productvolume,
  //           Sub.toString())
  //       .then((value) {
  //     var json = jsonDecode(value);
  //     var message = json["message"];

  //     // showCustomToast(message.toString());
  //   }, onError: (error) {
  //     showCustomToast(error.toString());
  //   });
  //   // Navigator.of(context).push(
  //   //   MaterialPageRoute(
  //   //       builder: (BuildContext context) =>
  //   //           Cart2(cartlist, cartsubscribeList)),
  //   // );
  // }

  // setState(() {
  //   double fprice = secondPrice * quentity;
  //   walletAmount = walletAmount - fprice;
  //   _isLoading = false;
  // });

  // print("==>RESPONSE==>$value");
  // var json = jsonDecode(value);
  // var message = json["messaage"];

  // if (message == "Not Sufficient Balance in Wallet") {
  //   Navigator.of(context)
  //       .push(MaterialPageRoute(builder: (context) => const Wallet()));
  // }
  // showCustomToast(message.toString());

  //String message = json["messaage"];
  // Navigator.of(context)
  //     .push(MaterialPageRoute(builder: (context) => OrderSuccessScreen()));

  // showCustomToast("SUCCESS"+response.paymentId.toString());
}
