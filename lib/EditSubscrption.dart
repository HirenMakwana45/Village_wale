import 'dart:convert';
import 'dart:ffi';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:village.wale/HomeScreen.dart';
import 'package:village.wale/Model/OrderModel.dart';
import 'package:village.wale/Model/SubscriptionModel.dart';
import 'package:village.wale/persistance/api_repository.dart';
import 'package:village.wale/util/AppUtil.dart';
import 'package:intl/intl.dart';

import 'MySubscription.dart';
import 'Wallet.dart';
import 'util/util.dart';

class EditSubscrption extends StatefulWidget {
  Subscriptions _model;
  EditSubscrption(this._model);

  @override
  _EditSubscrption createState() => _EditSubscrption();
}

class _EditSubscrption extends State<EditSubscrption> {
  int quentity = 0;
  List<String> dayList = [];
  List<int> selectedItem = [];

  List<String> mainDateList = [];
  List<String> secondList = [];
  String date = "";
  String? Repeatdays;
  List<String> dailyList = [];
  String subscribeType = "";
  bool _isLoading = false;
  String startDate = "";
  String apistartdate = "";
  String apienddate = "";
  String endDate = "";
  String startdate = "";
  String Substartdate = "";
  int walletAmount = 0;
  bool _isProfileLoading = false;
  double price = 0;
  double DiscountM = 0;
  double DiscountS = 0;
  double MainDiscountPrice = 0;
  double DPRICE = 0;
  double DIS = 0;
  int selectPosition = 0;
  // String volume = "";
  String productvolume = "";
  List<String> volume = [];
  double normal_price = 0;
  double discount_price = 0;
  double secondPrice = 0;
  @override
  void initState() {
    quentity = int.parse(widget._model.productQty!);

    dayList.add("S");
    dayList.add("M");
    dayList.add("T");
    dayList.add("W");
    dayList.add("T");
    dayList.add("F");
    dayList.add("S");

    mainDateList.add("Sunday");
    mainDateList.add("Munday");
    mainDateList.add("Tuesday");
    mainDateList.add("Wednesday");
    mainDateList.add("Thursday");
    mainDateList.add("Friday");
    mainDateList.add("Saturday");

    dailyList.add("Daily");
    dailyList.add("Weekly");
    dailyList.add("Monthly");
    dailyList.add("Alternative");

    price = double.parse(widget._model.productPrice.toString());
    normal_price = double.parse(widget._model.productPrice.toString());
    discount_price = double.parse(widget._model.productDiscount.toString());

    DiscountM = normal_price * discount_price;
    print("DiscountM" + DiscountM.toString());

    DiscountS = DiscountM / 100;
    print(DiscountS);
    MainDiscountPrice = normal_price - DiscountS;
    print(MainDiscountPrice);

    DPRICE = MainDiscountPrice * quentity;
    DIS = MainDiscountPrice;
    secondPrice = double.parse(DIS.toString());
    if (subscribeType == "Daily") {
      selectedItem.clear();

      for (int i = 0; i < 7; i++) {
        selectedItem.add(i);
        secondList.add(mainDateList[i]);
      }
    }

    for (int i = 0; i < getButtonValue(widget._model.repeatDays!).length; i++) {
      for (int j = 0; j < mainDateList.length; j++) {
        if (getButtonValue(widget._model.repeatDays!)[i] == mainDateList[j]) {
          selectedItem.add(j);
          secondList.add(mainDateList[j]);
        }
      }
    }

    subscribeType = widget._model.subscriptionType!.toString();
    setState(() {
      //  productvolume = volume.first.toString();
    });

    super.initState();
  }

  List<String> getButtonValue(String value) {
    List<String> item = [];
    if (value != null) {
      value.split(',').forEach((tag) {
        //  something?
        item.add(tag);
      });
    }

    item.removeLast();
    return item;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: !_isProfileLoading
            ? LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) =>
                    Container(
                  margin: const EdgeInsets.fromLTRB(16, 50, 16, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                      child: My_subscription()));
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) =>
                              //         const My_subscription()));
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Text(
                            'Edit Subscription',
                            style:
                                TextStyle(fontFamily: "Poppins", fontSize: 20),
                          ),
                        ],
                      ),
                      Container(
                        color: const Color(0XffFFFFFF),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                widget._model.productImage.toString() == ""
                                    ? noImage
                                    : widget._model.productImage.toString(),
                                height: 50,
                                width: 100,
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      widget._model.productName.toString(),
                                      style: const TextStyle(
                                          fontFamily: "Poppins", fontSize: 16),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  // Visibility(
                                  //   visible:0 widget._model.offerText=="yes"?false:true,
                                  //   child: Container(
                                  //     decoration: ShapeDecoration(
                                  //         color: const Color(0xffFCDA28),
                                  //         shape: RoundedRectangleBorder(
                                  //             side: BorderSide(
                                  //                 width: 0, color: Color(0xff9D9FA1)))),
                                  //     child: Center(
                                  //         child: Text(widget._model.normalDiscount.toString(),
                                  //             style: TextStyle(
                                  //               fontSize: 14,
                                  //             ))),
                                  //   ),
                                  // ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Visibility(
                                    visible: false,
                                    child: Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
                                      alignment: Alignment.topLeft,
                                      child: const Text(
                                        "1 Ltr",
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(
                                  Icons.currency_rupee,
                                  color: Color(0XFF286953),
                                ),
                                Text(
                                  DPRICE.toString(),
                                  style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0XFF286953)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.shopping_bag_outlined),
                              SizedBox(
                                width: 7,
                              ),
                              Text(
                                'Quantity per day',
                                style: TextStyle(
                                    fontFamily: "Poppins", fontSize: 16),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (quentity != 1) {
                                      // price = normal_price - discount_price;

                                      quentity = quentity - 1;
                                      DPRICE = secondPrice * quentity;
                                      print(DPRICE);
                                      // price=price-int.parse(widget._model.normalPrice.toString());
                                    }
                                  });
                                },
                                child: Image.asset(
                                  'images/Group 76.png',
                                  scale: 1,
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(
                                quentity.toString(),
                                style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    discount_price = double.parse(widget
                                        ._model.productDiscount
                                        .toString());
                                    price = normal_price - discount_price;
                                    //quentity = 1;
                                    print("==>ADD SECOND PRICE=>" +
                                        secondPrice.toString());
                                    quentity = quentity + 1;
                                    //DPRICE = Np * quentity;

                                    DPRICE = secondPrice * quentity;
                                    print(secondPrice);
                                    print(DPRICE);
                                  });
                                },
                                child: Image.asset(
                                  'images/Group 75.png',
                                  scale: 1,
                                  height: 30,
                                  width: 30,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Repeat',
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                          height: 50,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) =>
                                  getRepetLayout(index),
                              itemCount: dayList.length)),
                      // Flexible(child: Container(height:50,child: ListView.builder(scrollDirection: Axis.horizontal,itemBuilder: (context,index)=>getDaily(index),itemCount: dayList.length))),
                      const SizedBox(
                        height: 25,
                      ),
                      SizedBox(
                          height: 40,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => getDaily(index),
                              itemCount: dailyList.length)),

                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Start Date',
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      Card(
                        elevation: 2,
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: InkWell(
                          onTap: () async {
                            DateTime selectedDate = DateTime.now();

                            final DateTime? picked = await showDatePicker(
                              builder: ((context, child) {
                                return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: Color(
                                            0XFF286953), // header background color
                                        onPrimary:
                                            Colors.black45, // header text color
                                        onSurface:
                                            Colors.black, // body text color
                                      ),
                                      textButtonTheme: TextButtonThemeData(
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
                                startDate = DateFormat.yMMMMEEEEd()
                                    .format(selectedDate);

                                print(
                                    "==>ENTRY==> Your Selected Start Date:  $startDate");
                                //startDate = apistartdate;
                                apistartdate = DateFormat('yyyy-MM-dd')
                                    .format(selectedDate);
                                print(apistartdate);
                              });
                            } else {
                              startDate;
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Row(
                              children: [
                                Image.asset(
                                  "images/calender.png",
                                  height: 20,
                                  width: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  startDate.toString() == ""
                                      ? DateTime.now()
                                          .toLocal()
                                          .toIso8601String()
                                          .substring(0, 10)
                                      : startDate,
                                  style: const TextStyle(
                                      fontFamily: "Poppins", fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        'End Date',
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),

                      Card(
                        elevation: 2,
                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: InkWell(
                          onTap: () async {
                            DateTime selectedDate = DateTime.now();

                            final DateTime? picked = await showDatePicker(
                              builder: ((context, child) {
                                return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: Color(
                                            0XFF286953), // header background color
                                        onPrimary:
                                            Colors.black45, // header text color
                                        onSurface:
                                            Colors.black, // body text color
                                      ),
                                      textButtonTheme: TextButtonThemeData(
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
                                endDate = DateFormat.yMMMMEEEEd()
                                    .format(selectedDate);
                                print(
                                    "==>ENTRY==> Your Selected EndDate:  $endDate");
                                apienddate = DateFormat('yyyy-MM-dd')
                                    .format(selectedDate);
                                print(apienddate);
                              });
                            } else {
                              endDate;
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                                  endDate.toString() == ""
                                      ? DateTime.now()
                                          .toLocal()
                                          .toIso8601String()
                                          .substring(0, 10)
                                      : endDate,
                                  style: const TextStyle(
                                      fontFamily: "Poppins", fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Visibility(
                        visible: false,
                        child: Container(
                            decoration: ShapeDecoration(
                                color: const Color(0xffFFFFFF),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    side: const BorderSide(
                                        width: 1, color: Colors.transparent))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                        Icons.account_balance_wallet_outlined),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    const Icon(Icons.currency_rupee_outlined),
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
                                              type: PageTransitionType.fade,
                                              child: Wallet()));
                                      // Navigator.of(context).push(
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             const Wallet()));
                                    },
                                    child: const Text(
                                      'Top Up',
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: Color(0XFF286953),
                                          fontSize: 16),
                                    )),
                              ],
                            )),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      !_isLoading
                          ? SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      primary: const Color(0XFF286953)),
                                  onPressed: () {
                                    updateSub();
                                    // callApi();
                                  },
                                  child: const SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        "Update Subscribe",
                                        textAlign: TextAlign.center,
                                      ))),
                            )
                          : Center(
                              child: getProgressBar(),
                            ),
                    ],
                  ),
                ),
              )
            : Center(
                child: getProgressBar(),
              ),
      ),
    );
  }

  void updateSub() {
    var concaete = StringBuffer();
    secondList.forEach((element) {
      concaete.write(element + "," "");
      print("HUrray");
      print(concaete);

      Repeatdays =
          concaete.toString().substring(0, concaete.toString().length - 1);
      print(Repeatdays);
    });
    // if(volume==""){
    //   showCustomToast("Please Select Volume");
    //   return;
    // }
    if (quentity == 0) {
      showCustomToast("please Select quentity");
      return;
    }

    if (secondList.isEmpty) {
      showCustomToast("Please Select Repet date");
      return;
    }

    if (subscribeType == "") {
      showCustomToast("Please Select Duration");
      return;
    }

    if (startDate == "") {
      showCustomToast("Please select Date");
      return;
    }
    print("hurray");
    print(apienddate);

    // int fprice=quentity! * int.parse(widget._model.productPrice!);
    // if(walletAmount<fprice){
    //
    //   showCustomToast("insuffceint Balance");
    //   return;
    // }

    setState(() {
      _isLoading = true;
    });

    var api = APICallRepository();
    print(apienddate);
    api
        .updateSubscription(widget._model.id.toString(), quentity.toString(),
            apistartdate.toString(), Repeatdays.toString(), subscribeType, "")
        .then((value) {
      setState(() {
        _isLoading = false;
        var json = jsonDecode(value);
        String message = json["message"];
        showCustomToast(message);
        if (message == "Subscription Updated Successfully") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const MyHomeScreen()),
              (route) => false);
        }
      });
    }, onError: (error) {
      setState(() {
        _isLoading = false;
      });
      showCustomToast("Something Went Wrong");
    });
  }

  Widget getDaily(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          selectPosition = index;
          subscribeType = dailyList[index].toString();
        });
      },
      child: Container(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          height: 30,
          margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          decoration: ShapeDecoration(
              color: selectPosition == index
                  ? const Color(0XFF286953)
                  : Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              )),
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              dailyList[index].toString(),
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: selectPosition == index ? Colors.white : Colors.black),
            ),
          ))),
    );
  }

  Widget getRepetLayout(int index) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              if (selectedItem.contains(index)) {
                selectedItem.remove(index);
                secondList.remove(mainDateList[index]);
              } else {
                selectedItem.add(index);
                secondList.add(mainDateList[index]);
              }
            });
          },
          child: Container(
            height: 28,
            width: 28,
            decoration: ShapeDecoration(
                color: selectedItem.contains(index)
                    ? const Color(0XFF286953)
                    : Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    side: BorderSide(
                        width: 1,
                        color: selectedItem.contains(index)
                            ? Colors.green
                            : Colors.black))),
            child: Center(
                child: Text(
              dayList[index].toString(),
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 16,
                  color: selectedItem.contains(index)
                      ? Colors.white
                      : Colors.black),
            )),
          ),
        ),
        const SizedBox(
          width: 7,
        ),
      ],
    );
  }
}
