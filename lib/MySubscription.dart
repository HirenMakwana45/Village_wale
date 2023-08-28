import 'dart:convert';
import 'dart:math';

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village.wale/EditSubscrption.dart';
import 'package:village.wale/HomeScreen.dart';
import 'package:village.wale/persistance/api_repository.dart';
import 'package:village.wale/util/AppUtil.dart';
import 'package:village.wale/util/util.dart';

import 'Model/SubscriptionModel.dart';

class My_subscription extends StatefulWidget {
  const My_subscription({Key? key}) : super(key: key);

  @override
  State<My_subscription> createState() => _My_subscriptionState();
}

class _My_subscriptionState extends State<My_subscription> {
  Subscriptions? subscriptions;
  List<Subscriptions> list = [];
  String? WeekdaysChar;

  bool _isLoading = false;
  String? firstname;
  String? Normal_Amount;
  String? PAY_AMOUNT;

  String? DAYNAME;
  double normal_price = 0;
  double price = 0;
  List<String> dayList = [];

  List<String> dailyList = [];
  List<String> mainDateList = [];
  List<String> secondList = [];
  double discount_price = 0;
  double MainDiscountPrice = 0;
  double DiscountM = 0;
  double DiscountS = 0;
  double DPRICE = 0;
  List<String> RepeatDaysList = [];
  String? p;
  @override
  void initState() {
    getSubscrptionList();

    setState(() {
      // normal_price = double.parse(subscriptions!.productPrice!);
      // discount_per = double.parse(subscriptions!.productDiscount!);
      // print(normal_price);
    });
    //List<String> dlist = DAYNAME!.split(",");
    // price = double.parse(widget._model.productPrice.toString());
    // normal_price = double.parse(widget._model.productPrice.toString());
    // discount_price = double.parse(widget._model.productDiscount.toString());

    // p = subscriptions!.productPrice.toString();
    print("DHINCHKYAUUUU" + p.toString());
    DiscountM = normal_price * discount_price;
    print("DiscountM" + DiscountM.toString());

    DiscountS = DiscountM / 100;
    print(DiscountS);
    MainDiscountPrice = normal_price - DiscountS;
    print(MainDiscountPrice);
    DPRICE = MainDiscountPrice;

    print("##########");
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0XffF5F5F5),
        appBar: AppBar(
          backgroundColor: const Color(0XffF5F5F5),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          title: const Text(
            'My subscription',
            style: TextStyle(fontFamily: "Poppins", color: Colors.black),
          ),
        ),
        body: !_isLoading
            ? Padding(
                padding: const EdgeInsets.all(6.0),
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    // scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => getItem(index),
                    itemCount: list.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true),
              )
            : Center(child: getProgressBar()));
  }

  // List<Subscriptions> getDaylist(String value) {
  //   if (value != null) {
  //     value.split(',').forEach((tag) {
  //       //  something?
  //       DAYNAME = Daylist.toString();
  //       //Daylist.add(tag);
  //     });
  //     print("DAY : -->" + DAYNAME.toString());

  //     //print(list.first.repeatDays);
  //   }

  //   // item.removeLast();
  //   return Daylist;
  // }

  Widget getItem(int index) {
    return Column(
      children: [
        Visibility(
          visible: list.isEmpty ? false : true,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeInImage(
                            width: 120,
                            image: NetworkImage(
                                list[index].productImage.toString() == "null" ||
                                        list[index].productImage.toString() ==
                                            ""
                                    ? noImage
                                    : list[index].productImage.toString()),
                            fit: BoxFit.cover,
                            placeholder: const NetworkImage(
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSd7ouUaXq_gL4N44vL7zj-NcpCKQDJIoIQzM3FnHnZ5Q&s"),
                          ),
                          // Image.network(list[index].productImage.toString() == ""?noImage:list[index].productImage.toString(),width: 120,height: 50,fit: BoxFit.cover,),
                          Flexible(
                            flex: 3,
                            child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(list[index].productName.toString()),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 3.0),
                                          child: GestureDetector(
                                            onTap: (() {
                                              setState(() {
                                                if (list[index].isPause!) {
                                                  list[index].isPause = false;
                                                  resumeSubscrption(
                                                      list[index]);
                                                  showCustomToast('Resume');
                                                } else {
                                                  pauseSubscrption(list[index]);
                                                  showCustomToast('Pause');
                                                  list[index].isPause = true;
                                                }
                                              });
                                            }),
                                            child: !list[index].isPause!
                                                ? Image.asset(
                                                    "images/Pause.png",
                                                    scale: 3.6,
                                                  )
                                                : Image.asset(
                                                    "images/play-button2.png",
                                                    scale: 3.6,
                                                    width: 26,
                                                    height: 26,
                                                    color:
                                                        const Color(0XFF286953),
                                                  ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 3.0),
                                          child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        type: PageTransitionType
                                                            .fade,
                                                        child: EditSubscrption(
                                                            list[index])));
                                                // Navigator.of(context).push(
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             EditSubscrption(
                                                //                 list[index])));
                                              },
                                              child: Image.asset(
                                                "images/Edit1.png",
                                                scale: 3.6,
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 3.0),
                                          child: InkWell(
                                              onTap: () {
                                                deleteSubscrption(
                                                    list[index].id.toString());
                                                setState(() {
                                                  list.removeAt(index);
                                                  print(index);
                                                });
                                              },
                                              child: Image.asset(
                                                "images/RemoveB.png",
                                                scale: 3.6,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.currency_rupee_outlined,
                                          size: 16,
                                        ),
                                        Text(
                                            PAY_AMOUNT =
                                                "${int.parse(list[index].productPrice.toString()) * int.parse(list[index].productQty.toString())}",
                                            style: const TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 16)),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.grey,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.currency_rupee_outlined,
                                          size: 16,
                                          color: Color(0XFF286953),
                                        ),
                                        Text(
                                          PAY_AMOUNT =
                                              "${double.parse(list[index].discountPrice.toString()) * double.parse(list[index].productQty.toString())}",
                                          style: const TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 18,
                                            color: const Color(0XFF286953),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "   Qty: ",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              color: Colors.grey),
                                        ),
                                        Text(list[index].productQty.toString(),
                                            style: const TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 16)),
                                      ],
                                    ),
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //     IconButton(
                                //         onPressed: () {
                                //           setState(() {
                                //             setState(() {
                                //               if (list[index].isPause!) {
                                //                 list[index].isPause = false;
                                //                 resumeSubscrption(list[index]);
                                //               } else {
                                //                 pauseSubscrption(list[index]);
                                //                 list[index].isPause = true;
                                //               }
                                //             });
                                //           });
                                //         },
                                //         icon: !list[index].isPause!
                                //             ? const Icon(
                                //                 Icons.pause_circle_outline_outlined,
                                //                 color: Colors.yellow,
                                //               )
                                //             : const Icon(
                                //                 Icons.play_arrow,
                                //                 color: Colors.red,
                                //               )),
                                //     IconButton(
                                //         onPressed: () {
                                //           Navigator.of(context).push(
                                //               MaterialPageRoute(
                                //                   builder: (context) =>
                                //                       EditSubscrption(list[index])));
                                //         },
                                //         icon: const Icon(
                                //           Icons.edit,
                                //           color: Colors.green,
                                //         )),
                                //     IconButton(
                                //         onPressed: () {
                                //           setState(() {
                                //             list.removeAt(index);
                                //           });
                                //           deleteSubscrption(
                                //               list[index].id.toString());
                                //         },
                                //         icon: const Icon(
                                //           Icons.delete_forever_outlined,
                                //           color: Colors.red,
                                //         )),
                                //   ],
                                // ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                    ],
                  ),
                  Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            const Text(
                              "Repeat : ",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.grey,
                                  fontSize: 16),
                            ),
                            Text(list[index].subscriptionType!,
                                style: const TextStyle(
                                    fontFamily: "Poppins", fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SingleChildScrollView(
                        child: CustomRadioButton(
                          height: 30,
                          width: 120,
                          spacing: 0.5,
                          elevation: 0,
                          autoWidth: false,
                          radius: 20,
                          enableShape: true,
                          shapeRadius: 50,
                          absoluteZeroSpacing: false,
                          unSelectedColor: Theme.of(context).canvasColor,
                          buttonLables: getButtonValue(list[index].repeatDays!),
                          buttonValues: getButtonValue(list[index].repeatDays!),
                          buttonTextStyle: const ButtonTextStyle(
                              selectedColor: Colors.white,
                              unSelectedColor: Color(0XFF286953),
                              textStyle: TextStyle(
                                  fontFamily: "Poppins", fontSize: 16)),
                          radioButtonValue: (value) {
                            print(
                                "This is Selected Day --> " + value.toString());
                            print(value.toString().characters.first);
                            print("***********");
                            // print(list[index]
                            //     .repeatDays!
                            //     .toString()
                            //     .characters
                            //     .first);
                          },
                          selectedColor: const Color(0XFF286953),
                          unSelectedBorderColor: const Color(0XFF286953),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<String> getButtonValue(String value) {
    List<String> item = [];
    if (value != null) {
      value.split(',').forEach((tag) {
        //  something?
        firstname = item.toString();
        item.add(tag);
      });
      print(item);
      print("This Is List Of Days : -->" + firstname.toString());
      print("HURRAy");

      //  print(ArryString);

      //print(list.first.repeatDays);
    }

    item.removeLast();
    return item;
  }

  // List<String> getdayindex(String value) {
  //   List<String> daylist = [];
  //   if (value != null) {
  //     value.split(',').forEach((tag) {
  //       //  something?
  //       firstname = daylist.toString();
  //       daylist.add(tag);
  //     });
  //     print("List Of Days : -->" + firstname.toString());

  //     //print(list.first.repeatDays);
  //   }

  //   daylist.removeLast();
  //   return daylist;
  // }

  void deleteSubscrption(String id) {
    var api = APICallRepository();
    api.deleteSubscription(id).then((value) {
      var json = jsonDecode(value);
      String message = json["message"];
      showCustomToast(message);
    }, onError: (error) {
      showCustomToast("Something Went Wrong");
    });
  }

  void pauseSubscrption(Subscriptions list) {
    print(list.id.toString());
    print(list.productQty);
    print(list.startDate);
    print(list.repeatDays);
    print(list.subscriptionType);
    //print(list.status);
    String? pause = 'Pause';
    print(pause);
    var api = APICallRepository();
    api
        .updateSubscription(list.id.toString(), list.productQty!,
            list.startDate!, list.repeatDays!, list.subscriptionType!, pause)
        .then((value) {
      var json = jsonDecode(value);
      String message = json["message"];
      print("Paused");
      print(value);
      //showCustomToast(message);
    }, onError: (error) {
      showCustomToast("Something Went Wrong");
    });
  }

  void resumeSubscrption(Subscriptions list) {
    print(list.id.toString());
    print(list.productQty);
    print(list.startDate);
    print(list.repeatDays);
    print(list.subscriptionType);
    // print(list.status);
    String? active = 'Active';
    print(active);
    var api = APICallRepository();
    api
        .updateSubscription(list.id.toString(), list.productQty!,
            list.startDate!, list.repeatDays!, list.subscriptionType!, active)
        .then((value) {
      var json = jsonDecode(value);
      print(value);
      print('Resume');
      String message = json["message"];
      //showCustomToast(message);
    }, onError: (error) {
      showCustomToast("Something Went Wrong");
    });
  }

  void getSubscrptionList() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String id = _prefs.getString("id").toString();

    APICallRepository api = APICallRepository();

    api.getAllScbscrption(id).then((value) {
      setState(() {
        _isLoading = false;
        var model = SubscriptionModel.fromJson(jsonDecode(value));
        list.clear();
        list.addAll(model.subscriptions!);
        // DAYNAME = list.first.repeatDays.toString();
        //List<String> dlist = DAYNAME!.split(",");
        print(model.subscriptions!.length);
        print("--------");
        //  print(dlist);
        // print(list.first.repeatDays!.characters.first);
        // print(dlist.toString().length);
        // for (int i = 0; i < dlist.length; i++) {
        //   var abc = dlist[i];
        //   print(abc.characters.first.toString());
        // }
        print("--------");
      });
      if (list.isEmpty) {
        showCustomToast("No Order Found");
        // Navigator.of(context).pop();
      }
    }, onError: (error) {
      setState(() {
        _isLoading = false;
      });
      showCustomToast(error.toString());
    });
  }
}
