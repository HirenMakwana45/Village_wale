import 'dart:async';
import 'dart:convert';

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village.wale/Model/HomeModel.dart';
import 'package:village.wale/Model/ProfileModel.dart';
import 'package:village.wale/Wallet.dart';
import 'package:village.wale/persistance/api_repository.dart';
import 'package:village.wale/util/AppUtil.dart';
import 'package:village.wale/util/util.dart';
import 'package:intl/intl.dart';

import 'Cart2.dart';
import 'HomeScreen.dart';
import 'LogInPage1.dart';
import 'MySubscription.dart';
import 'package:village.wale/Model/CartModel.dart' as model;

class MySubscription extends StatefulWidget {
  Products _model;

  MySubscription(this._model, {Key? key}) : super(key: key);

  @override
  State<MySubscription> createState() => _MySubscriptionState();
}

class _MySubscriptionState extends State<MySubscription> {
  int quentity = 1;
  String? repeatdays;
  List<String> dayList = [];
  List<int> selectedItem = [];

  List<String> mainDateList = [];
  List<String> secondList = [];
  List<model.Cart>? cartlist = [];
  List<model.SubscriptionCart> cartsubscribeList = [];
  String date = "";
  String endDate = "";
  String startDate = "";
  String apistartdate = "";
  String apienddate = "";
  String? type = "Subscription";

  List<String> dailyList = [];
  String subscribeType = "Daily";
  bool _isLoading = false;
  final dateController = TextEditingController();
  double walletAmount = 0;
  double price = 0;
  double normal_price = 0;
  double discount_price = 0;
  bool _isProfileLoading = false;
  double secondPrice = 0;
  List<String> volume = [];
  double ORIGINALPRICE = 0;

  double DiscountM = 0;
  double DiscountS = 0;
  double MainDiscountPrice = 0;

  // List<String> secondVolume=[];
  String productvolume = "";
  double P = 0;
  final getStorage = GetStorage();
  double DPRICE = 0;
  double Np = 0;
  @override
  void initState() {
    getId();

    String name =
        widget._model.quantityAvailable.toString().replaceAll(' ', '');

    // widget._model.quantityAvailable!.split(",").forEach((tag) {
    //   volume.add(tag + " " + widget._model.volume.toString());
    //   // secondVolume.add(tag);
    // });

    name.split(",").forEach((tag) {
      volume.add("$tag ${widget._model.volume}");
      // secondVolume.add(tag);
    });

    dayList.add("S");
    dayList.add("M");
    dayList.add("T");
    dayList.add("W");
    dayList.add("T");
    dayList.add("F");
    dayList.add("S");

    mainDateList.add("Sunday");
    mainDateList.add("Monday");
    mainDateList.add("Tuesday");
    mainDateList.add("Wednesday");
    mainDateList.add("Thursday");
    mainDateList.add("Friday");
    mainDateList.add("Saturday");

    dailyList.add("Daily");
    dailyList.add("Weekly");
    dailyList.add("Monthly");
    dailyList.add("Alternative");

    normal_price = double.parse(widget._model.normalPrice.toString());
    discount_price = double.parse(widget._model.normalDiscount.toString());
    print(normal_price);
    print(discount_price);

    price = normal_price - discount_price;
    Np = normal_price;
    print("Starting price" + Np.toString());
    DPRICE = price;
    print(normal_price);
    print(discount_price);
    print("Discounted Price Is" + DPRICE.toString());

    DiscountM = normal_price * discount_price;
    print("DiscountM" + DiscountM.toString());

    DiscountS = DiscountM / 100;
    print(DiscountS);
    MainDiscountPrice = normal_price - DiscountS;
    print(MainDiscountPrice);
    DPRICE = MainDiscountPrice;

    // discount_price = DPRICE;
    secondPrice = double.parse(DPRICE.toString());
    print("Second Price" + secondPrice.toString());
    double mDis = price * double.parse(widget._model.normalDiscount.toString());
    print(mDis);

    //price = double.parse(widget._model.normalPrice.toString());
    if (subscribeType == "Daily") {
      selectedItem.clear();

      for (int i = 0; i < 7; i++) {
        selectedItem.add(i);
        secondList.add(mainDateList[i]);
      }
    }
    setState(() {
      productvolume = volume.first.toString();
    });
    super.initState();
  }

  String id = "";

  void getId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    id = sharedPreferences.getString("id").toString();

    print("===>ID=>$id");
    setState(() {
      _isProfileLoading = true;
    });
    var api = APICallRepository();
    api.getProfile(id).then((value) {
      var model = ProfileModel.fromJson(jsonDecode(value));
      setState(() {
        _isProfileLoading = false;
        walletAmount = double.parse(model.wallet!);
      });
    }, onError: (error) {
      setState(() {
        _isProfileLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: !_isProfileLoading
            ? LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) =>
                    SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(12, 50, 12, 10),
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
                                        child: const MyHomeScreen()));
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) =>
                                //         const MyHomeScreen()));
                              },
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            const Text(
                              'Create Subscription',
                              style: TextStyle(
                                  fontFamily: "Poppins", fontSize: 20),
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
                                  widget._model.image.toString() == ""
                                      ? noImage
                                      : widget._model.image.toString(),
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
                                      margin: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        widget._model.name.toString(),
                                        style: const TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 16),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Visibility(
                                      visible: true,
                                      child: Wrap(
                                        children: [
                                          Container(
                                            alignment: Alignment.topLeft,
                                            width: 70,
                                            decoration: const ShapeDecoration(
                                                color: Color(0xffFCDA28),
                                                shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        width: 0,
                                                        color: Color(
                                                            0xff9D9FA1)))),
                                            child: Center(
                                                child: Text(
                                                    "${widget._model.normalDiscount}% off",
                                                    style: const TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 14,
                                                    ))),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),

                                    //     Container(
                                    //       margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    //       alignment: Alignment.topLeft,
                                    //       child: Text(
                                    // "1 ltr",
                                    //         style: TextStyle(fontSize: 14),
                                    //       ),
                                    //     ),
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
                                    size: 20,
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
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  const Icon(
                                    Icons.currency_rupee,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  Text(Np.toString(),
                                      style: const TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18,
                                          color: Colors.black,
                                          decoration:
                                              TextDecoration.lineThrough),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        const Text(
                          'Volume',
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomRadioButton(
                                  spacing: 1.0,
                                  padding: 5,
                                  wrapAlignment: WrapAlignment.spaceEvenly,
                                  elevation: 0,
                                  autoWidth: true,
                                  radius: 20,
                                  width: 0,
                                  enableShape: true,
                                  shapeRadius: 50,
                                  absoluteZeroSpacing: false,
                                  unSelectedColor: getColorFromHex("#e4ecd6"),
                                  buttonLables: volume,
                                  buttonValues: volume,
                                  buttonTextStyle: const ButtonTextStyle(
                                      selectedColor: Colors.white,
                                      unSelectedColor: Color(0XFF286953),
                                      textStyle: TextStyle(
                                          fontFamily: "Poppins", fontSize: 16)),
                                  radioButtonValue: (value) {
                                    setState(() {
                                      // discount_price = DPRICE;
                                      print("Staring Value Is -->" +
                                          value.toString());
                                      print("Default Volume Is --> " +
                                          volume.first.toString());
                                      //value =
                                      price = 0;
                                      secondPrice = 0;

                                      print("First Volume Is -->" +
                                          volume.first.toString());
                                      // widget._model.normalPrice="0";
                                      productvolume = value.toString();
                                      print(
                                          "==>Product Volume For Subscription $productvolume");

                                      var str = productvolume;
                                      var parts = str.split(" ");
                                      var fValue = parts[0].trim();

                                      var mValue = double.parse(fValue);

                                      normal_price = double.parse(
                                          widget._model.normalPrice.toString());
                                      Np = normal_price;
                                      discount_price = double.parse(widget
                                          ._model.normalDiscount
                                          .toString());

                                      DiscountM = normal_price * discount_price;
                                      print("DiscountM" + DiscountM.toString());

                                      DiscountS = DiscountM / 100;
                                      print(DiscountS);
                                      MainDiscountPrice =
                                          normal_price - DiscountS;
                                      print(MainDiscountPrice);
                                      DPRICE = MainDiscountPrice;

                                      print(normal_price);
                                      print(discount_price);

                                      print("Discounted Price" +
                                          DPRICE.toString());

                                      // discount_price = double.parse(widget
                                      //     ._model.normalDiscount
                                      //     .toString());
                                      // print(discount_price);
                                      // price = normal_price - discount_price;

                                      // price = DPRICE * mValue;

                                      // price = double.parse(widget
                                      //         ._model.normalPrice
                                      //         .toString()) *
                                      //     mValue;
                                      // DPRICE = secondPrice * mValue;
                                      secondPrice = DPRICE * mValue;
                                      DPRICE = secondPrice;
                                      print("secondprice" +
                                          secondPrice.toString());
                                      print("Mvalue" + mValue.toString());
                                      print("Dprice" + DPRICE.toString());

                                      Np = Np * mValue;

                                      // widget._model.normalPrice=price.toString();

                                      print("==PRICE==>$price");

                                      quentity = 1;
                                      discount_price = 0;
                                      double mDis = price *
                                          double.parse(widget
                                              ._model.normalDiscount
                                              .toString());
                                      double mPrice = mDis / 100;
                                      double sPrice = discount_price + mPrice;
                                      discount_price = price - sPrice;

                                      // price=double.parse(widget._model.normalPrice.toString())*quentity;
                                      // price=int.parse(widget._model.normalPrice.toString())*quentity;
                                    });
                                  },
                                  defaultSelected: volume.first,
                                  selectedColor: getColorFromHex("#286953"),
                                  unSelectedBorderColor: Colors.transparent,
                                  selectedBorderColor: Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 25,
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
                                    'images/minus.png',
                                    scale: 1,
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  quentity.toString(),
                                  style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      discount_price = double.parse(widget
                                          ._model.normalDiscount
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
                                    'images/plus.png',
                                    scale: 1,
                                    height: 20,
                                    width: 20,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),

                        const SizedBox(
                          height: 25,
                        ),
                        const Text(
                          'Repeat',
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 10,
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
                                itemBuilder: (context, index) =>
                                    getDaily(index),
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
                                          onPrimary: Colors
                                              .black45, // header text color
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
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                                    startDate.toString() == ""
                                        ? "Saturday, 26 March, 2022 "
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
                                          onPrimary: Colors
                                              .black45, // header text color
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
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                                        ? "Saturday, 26 March, 2022 "
                                        : endDate,
                                    style: const TextStyle(
                                        fontFamily: "Poppins", fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.10,
                        ),
                        Container(
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
                                              child: const Wallet()));
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
                        const SizedBox(
                          height: 7,
                        ),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  primary: const Color(0XFF286953)),
                              onPressed: () {
                                // callApi();
                                addToCart(widget._model.id);
                              },
                              child: const SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    "Subscribe",
                                    textAlign: TextAlign.center,
                                  ))),
                        )
                        // : Center(
                        //     child: getProgressBar(),
                        //   ),
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: getProgressBar(),
              ),
      ),
    );
  }

  int selectPosition = 0;
  Widget getDaily(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          selectPosition = index;
          subscribeType = dailyList[index].toString();

          if (index == 0 || index == 1 || index == 2) {
            selectedItem.clear();
            secondList.clear();

            for (int i = 0; i < 7; i++) {
              selectedItem.add(i);
              secondList.add(mainDateList[i]);
            }
            // dailyList.addAll(dailyList);
            // mainDateList.addAll(mainDateList);
          }

          if (index == 3) {
            selectedItem.clear();
            secondList.clear();

            for (int i = 0; i < 7; i++) {
              if (i == 0 || i == 2 || i == 4 || i == 6) {
                selectedItem.add(i);
                secondList.add(mainDateList[i]);
              }
            }
          }
        });
      },
      child: Container(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          height: 30,
          margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          decoration: ShapeDecoration(
              color: selectPosition == index
                  ? getColorFromHex("#286953")
                  : getColorFromHex("#e4ecd6"),
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
          width: 15,
        ),
      ],
    );
  }

  Future<void> addToCart(String? id) async {
    if (widget._model.status != "Available") {
      showCustomToast("This product is currently not avalible");
      return;
    }
    if (productvolume == "") {
      showCustomToast("Please select volume");
      return;
    }
    if (quentity == 0) {
      showCustomToast("Please Add Some Quenity");
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
    if (endDate == "") {
      showCustomToast("Please select End Date");
      return;
    }
    var concaete = StringBuffer();
    secondList.forEach((element) {
      concaete.write("$element," "");
    });

    repeatdays =
        concaete.toString().substring(0, concaete.toString().length - 1);
    print("Repeat Days Is ==>" +
        concaete.toString().substring(0, concaete.toString().length - 1));
    print(
        "===>CONCATE RESPONSE==>${concaete.toString().substring(0, concaete.toString().length - 1)}");
    print(subscribeType);

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String userId = _prefs.getString("id").toString();
    var api = APICallRepository();
    api
        .addToCart(
      userId,
      id.toString(),
      quentity.toString(),
      productvolume.toString(),
      type.toString(),
      apistartdate.toString(),
      apienddate.toString(),
      subscribeType.toString(),
      repeatdays.toString(),
    )
        .then((value) {
      print(value);
      var json = jsonDecode(value);
      var message = json["message"];

      getStorage.write("subscriptiontype", subscribeType.toString());
      getStorage.write("concate", repeatdays.toString());
      getStorage.write("startdate", apistartdate.toString());
      getStorage.write("enddate", apienddate.toString());

      getStorage.read('subscriptiontype');
      getStorage.read('concate');
      getStorage.read('startdate');
      getStorage.read('enddate');
      showCustomToast('Subscription added to cart');
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: Cart2(cartlist, cartsubscribeList)));
      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => Cart2(cartlist, cartsubscribeList)));

      // showCustomToast(message.toString());
    }, onError: (error) {
      showCustomToast(error.toString());
    });
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //       builder: (BuildContext context) =>
    //           Cart2(cartlist, cartsubscribeList)),
    // );
  }

  // void callApi() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   String id = sharedPreferences.getString("id").toString();

  //   var concaete = StringBuffer();
  //   secondList.forEach((element) {
  //     concaete.write("$element,");
  //   });

  //   print(
  //       "===>CONCATE RESPONSE==>${concaete.toString().substring(0, concaete.toString().length - 1)}");

  //   // if(walletAmount==0){
  //   //   showCustomToast("No Wallet Balance");
  //   //   return;
  //   //
  //   // }
  //   if (productvolume == "") {
  //     showCustomToast("Please Select Volume");
  //     return;
  //   }
  //   if (quentity == 0) {
  //     showCustomToast("please Select quentity");
  //     return;
  //   }

  //   if (secondList.isEmpty) {
  //     showCustomToast("Please Select Repet date");
  //     return;
  //   }

  //   if (subscribeType == "") {
  //     showCustomToast("Please Select Duration");
  //     return;
  //   }

  //   if (startDate == "") {
  //     showCustomToast("Please select Date");
  //     return;
  //   }
  //   if (endDate == "") {
  //     showCustomToast("Please select End Date");
  //     return;
  //   }

  //   //
  //   // int fprice=quentity! * int.parse(widget._model.normalPrice!);
  //   // if(walletAmount<fprice){
  //   //
  //   //   showCustomToast("insuffceint Balance");
  //   //   return;
  //   // }

  //   setState(() {
  //     _isLoading = true;
  //   });

  //   print("===>id$id");
  //   print("===>Product id=>${widget._model.id}");
  //   print("===>Product id=>$quentity");
  //   print("===>Product id=>$concaete");
  //   print("===>SUBSCRIBE TYPE==>$subscribeType");
  //   print("===DATE==>$apistartdate");
  //   print("====EndDate==>$apienddate");

  //   Future<void> addToCart(String? id) async {
  //     if (widget._model.status != "Available") {
  //       showCustomToast("This product is currently not avalible");
  //       return;
  //     }
  //     if (productvolume == "") {
  //       showCustomToast("Please select volume");
  //       return;
  //     }
  //     if (quentity == 0) {
  //       showCustomToast("Please Add Some Quenity");
  //       return;
  //     }

  //     SharedPreferences _prefs = await SharedPreferences.getInstance();
  //     String userId = _prefs.getString("id").toString();
  //     var api = APICallRepository();
  //     api
  //         .addToCart(userId, id.toString(), quentity.toString(), productvolume,
  //             type.toString())
  //         .then((value) {
  //       var json = jsonDecode(value);
  //       var message = json["message"];

  //       // showCustomToast(message.toString());
  //     }, onError: (error) {
  //       showCustomToast(error.toString());
  //     });
  //     // Navigator.of(context).push(
  //     //   MaterialPageRoute(
  //     //       builder: (BuildContext context) =>
  //     //           Cart2(cartlist, cartsubscribeList)),
  //     // );
  //   }

  //   // api
  //   //     .addSubscrption(
  //   //         id.toString(),
  //   //         widget._model.id.toString(),
  //   //         quentity.toString(),
  //   //         apistartdate,
  //   //         concaete.toString().substring(0, concaete.toString().length - 1),
  //   //         subscribeType,
  //   //         apienddate,
  //   //         price.toString(),
  //   //         productvolume)
  //   //     .then((value) {
  //   //   print(value);
  //   //   // setState(() {
  //   //   //   double fprice = secondPrice * quentity;
  //   //   //   walletAmount = walletAmount - fprice;
  //   //   //   _isLoading = false;
  //   //   // });

  //   //   setState(() {
  //   //     _isLoading = false;
  //   //   });

  //   //   print("==>RESPONSE==>$value");
  //   //   var json = jsonDecode(value);
  //   //   var message = json["messaage"];

  //   //   if (message == "Not Sufficient Balance in Wallet") {
  //   //     Navigator.of(context)
  //   //         .push(MaterialPageRoute(builder: (context) => const Wallet()));
  //   //   }
  //   //   showCustomToast(message.toString());
  //   // }, onError: (error) {
  //   //   setState(() {
  //   //     _isLoading = false;
  //   //   });
  //   //   showCustomToast(error.toString());
  //   // });
  // }
}
