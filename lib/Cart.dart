import 'dart:convert';

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village.wale/Model/CartModel.dart' as model;
import 'package:village.wale/persistance/api_repository.dart';
import 'package:village.wale/util/AppUtil.dart';
import 'package:village.wale/util/util.dart';

import 'Cart2.dart';
import 'CartCheckout.dart';
import 'HomeScreen.dart';
import 'LogInPage1.dart';
import 'Model/CartModel.dart';
import 'ProductDetail.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<model.Cart>? list = [];
  List<model.SubscriptionCart> subscribeList = [];

  bool _isLoading = false;
  String date = "";

  int _totalAmount = 0;
  @override
  void initState() {
    getCartDetail();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_isLoading
          ? Container(
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const MyHomeScreen()));
                        },
                      ),
                      const Text(
                        'Cart',
                        style: TextStyle(fontFamily: "Poppins", fontSize: 20),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Stack(children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  Cart2(list, subscribeList)));
                        },
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 50,
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                            decoration: BoxDecoration(
                                color: getColorPrimary(),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  "Next",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colors.white,
                                      fontSize: 20),
                                ),
                                const Spacer(),
                                Image.asset(
                                  "images/next.png",
                                  height: 30,
                                  width: 30,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Visibility(
                            visible: list!.isEmpty ? false : true,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Row(
                                children: [
                                  const Text(
                                    'Product Summary',
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  Text(
                                    list!.length.toString() + " Items",
                                    style: const TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),

                          Flexible(
                            flex: 1,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) =>
                                  getProductSummary(index),
                              itemCount: list!.length,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: subscribeList.isEmpty ? false : true,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  'Subscription Summary',
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  '(${subscribeList.length.toString()} items)',
                                  style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),

                          Flexible(
                            flex: 1,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) =>
                                  getSubscraptionSummary(index),
                              itemCount: subscribeList.length,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // Visibility(
                          //   visible: true,
                          //   child: Column(children: [
                          //     Padding(
                          //       padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          //       child: Row(
                          //         children: [
                          //           Text(
                          //             'Subscription Summary',
                          //             style: TextStyle(
                          //                 fontSize: 18, fontWeight: FontWeight.w500),
                          //           ),
                          //           SizedBox(
                          //             width: 7,
                          //           ),
                          //           Text(
                          //             '(1 items)',
                          //             style: TextStyle(
                          //                 fontSize: 16, fontWeight: FontWeight.w400),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //     // SizedBox(
                          //     //   height: 10.h,
                          //     // ),
                          //
                          //
                          //   ],),
                          // ),

                          // SizedBox(
                          //   height: 10,
                          // ),

                          // Visibility(
                          //   visible: list!.isEmpty?false:true,
                          //   child: SizedBox(
                          //     height: 50,
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: [
                          //         ElevatedButton(
                          //           style: ElevatedButton.styleFrom(
                          //             primary: Colors.white,
                          //             shape: RoundedRectangleBorder(
                          //                 borderRadius: BorderRadius.circular(10),
                          //                 side: BorderSide(color: Color(0XFF286953))),
                          //           ),
                          //           child: Row(
                          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               Row(
                          //                 children: [
                          //                   Icon(
                          //                     Icons.shopping_bag_outlined,
                          //                     color: Color(0XFF286953),
                          //                   ),
                          //                   Text(
                          //                     "Checkout",
                          //                     style:
                          //                     TextStyle(color: Color(0XFF286953)),
                          //                   )
                          //                 ],
                          //               ),
                          //               Icon(
                          //                 Icons.arrow_forward_ios,
                          //                 color: Color(0XFF286953),
                          //               )
                          //             ],
                          //           ),
                          //           onPressed: () {
                          //
                          //             openBottomSheet();
                          //
                          //           },
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ]),
                  ),
                ],
              ),
            )
          : Center(child: getProgressBar()),
    );
  }

  Widget getSubscraptionSummary(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: Card(
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
                          subscribeList[index].productImage.toString() == "" ||
                                  subscribeList[index]
                                          .productImage
                                          .toString() ==
                                      "null"
                              ? noImage
                              : subscribeList[index].productImage.toString(),
                          scale: 1.2,
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subscribeList[index].productName.toString(),
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
                                    '${subscribeList[index].discount.toString()} % Off',
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 14,
                                    ))),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            subscribeList[index].volume.toString(),
                            style: const TextStyle(
                                fontFamily: "Poppins", fontSize: 14),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.currency_rupee,
                            color: Color(0XFF286953),
                          ),
                          Text(
                            subscribeList[index].price.toString(),
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
                          onPressed: () {},
                          icon: Image.asset("images/cart_minus.png")),
                      Text(
                        subscribeList[index].quantity.toString(),
                        style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                      IconButton(
                          onPressed: () {},
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
                              // shape: RoundedRectangleBorder(
                              //     side: const BorderSide(
                              //         color: Color(0XFF286953),
                              //         width: 1,
                              //         style: BorderStyle.solid),
                              //     borderRadius: BorderRadius.circular(20)),
                              child: Text(
                                subscribeList[index]
                                    .subscriptionType
                                    .toString(),
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
      ),
    );
  }

  Widget getProductSummary(int index) {
    double qu;

    double secondPrice = 0;
    double mprice = 0;
    double price = 0;
    if (list![index].volume.toString() != "" ||
        list![index].volume.toString() != "null") {
      var str = list![index].volume.toString();
      var parts = str.split(" ");
      var fValue = parts[0].trim();

      // int price= int.parse(list![index].price.toString()) * int.parse(list![index].quantity.toString());
      mprice =
          double.parse(list![index].price.toString()) * double.parse(fValue);
      secondPrice =
          double.parse(list![index].price.toString()) * double.parse(fValue);
      price = mprice * int.parse(list![index].quantity.toString());
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
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
                          IconButton(
                              onPressed: () {
                                if (list![index].quantity != "0") {
                                  setState(() {
                                    int quentity =
                                        int.parse(list![index].quantity!) - 1;
                                    list![index].quantity = quentity.toString();

                                    // price=price - int.parse(list![index].price.toString());
                                    price = secondPrice * quentity;
                                  });
                                }
                              },
                              icon: Image.asset("images/remove.png")),
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
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  int quentity =
                                      int.parse(list![index].quantity!) + 1;
                                  list![index].quantity = quentity.toString();
                                  // price=price + int.parse(list![index].price.toString());
                                  price = secondPrice * quentity;
                                });
                              },
                              icon: Image.asset("images/add.png")),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
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
                        InkWell(
                          child: Image.asset("images/ic_delete.png",
                              height: 30, width: 30),
                          onTap: () {
                            setState(() {
                              removeCart(list![index].id!);
                              list!.removeAt(index);
                            });
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void removeCart(String id) {
    print("=====>ID==>" + id.toString());
    var api = APICallRepository();
    api.removeCart(id).then((value) {
      var json = jsonDecode(value);
      String message = json["message"];
      showCustomToast(message.toString());
    }, onError: (error) {
      showCustomToast("$error");
    });
  }

  String id = "";

  void getCartDetail() async {
    setState(() {
      _isLoading = true;
    });

    List<int> total = [];
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

        subscribeList.clear();

        List<int> total = [];
        for (int i = 0; i < list!.length; i++) {
          print("===>PRINT==>" + list![i].quantity.toString());
          total.add(
              int.parse(list![i].quantity!) * int.parse((list![i].price!)));
        }

        for (int j = 0; j < total.length; j++) {
          _totalAmount += total[j];
        }

        if (subscribeList != null) {
          subscribeList.addAll(model.subscriptionCart!);
        }
        for (int i = 0; i < list!.length; i++) {
          total.add(int.parse(list![i].quantity!) *
              int.parse(list![i].price!.toString() == "null"
                  ? "0"
                  : list![i].price!.toString()));
        }

        for (int j = 0; j < total.length; j++) {
          _totalAmount += total[j];
        }

        if (list!.isEmpty) {
          showCustomToast("No Product Found...");
        }

        if (subscribeList.isEmpty) {
          showCustomToast("No Subscribed Product Found");
        }
      });
    }, onError: (error) {
      setState(() {
        _isLoading = false;
      });

      showCustomToast(error.toString());
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

  List<String> value = ["06:00 AM - 09:00 AM", "11:00 AM - 01:00 PM"];
  String selectTime = "";
  void openBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 160,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: const Text(
                    "Select Prefer  Time",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                ),
                Card(
                  child: InkWell(
                    onTap: () {
                      openDatePicker();
                      DateTimePicker(
                        initialValue: '',
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        dateLabelText: 'Date',
                        onChanged: (val) {
                          setState(() {
                            // date=val.toString();
                          });
                          // showCustomToast(val.toString());
                        },
                        validator: (val) {
                          // showCustomToast(val.toString());
                        },
                        onSaved: (val) {
                          setState(() {
                            // date=val.toString();
                            // showCustomToast(date.toString());
                          });
                        },
                      );
                      openDatePicker();
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
                          const Text(
                            "Saturday 26 March, 2022",
                            style:
                                TextStyle(fontFamily: "Poppins", fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
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
                          enableShape: true,
                          shapeRadius: 50,
                          absoluteZeroSpacing: false,
                          unSelectedColor: Theme.of(context).canvasColor,
                          buttonLables: value,
                          buttonValues: value,
                          buttonTextStyle: const ButtonTextStyle(
                              selectedColor: Colors.white,
                              unSelectedColor: Color(0XFF286953),
                              textStyle: TextStyle(
                                  fontFamily: "Poppins", fontSize: 16)),
                          radioButtonValue: (value) {
                            if (kDebugMode) {
                              print(value);
                            }

                            setState(() {
                              selectTime = value.toString();
                            });
                          },
                          selectedColor: const Color(0XFF286953),
                          unSelectedBorderColor: const Color(0XFF286953),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: const Color(0XFF286953)),
                      onPressed: () {
                        List<int> total = [];

                        for (int j = 0; j < total.length; j++) {
                          _totalAmount += total[j];
                        }
                        // Navigator.push(
                        //     context,
                        //     PageTransition(
                        //         type: PageTransitionType.fade,
                        //         child: CartCheckout(
                        //             _totalAmount, list!, selectTime)));

                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) =>
                        //         CartCheckout(_totalAmount, list!, selectTime)));
                      },
                      child: const SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Process",
                            textAlign: TextAlign.center,
                          ))),
                )
              ],
            ),
          );
        });
  }
}
