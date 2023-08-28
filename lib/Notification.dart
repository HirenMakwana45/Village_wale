import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village.wale/persistance/api_repository.dart';
import 'package:village.wale/util/AppUtil.dart';

import 'HomeScreen.dart';
import 'MyProfile.dart';
import 'Wallet.dart';
import 'package:village.wale/Model/NotificationModel.dart' as model;

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  void initState() {
    getNotificationList();
    super.initState();
  }

  bool _isLoading = false;
  List<model.Notifications> list = [];
  void getNotificationList() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userId = sharedPreferences.getString("id").toString();

    var api = APICallRepository();
    api.getNotificationList(userId).then((value) {
      setState(() {
        _isLoading = false;
        var notification = model.NotificationModel.fromJson(jsonDecode(value));
        list.clear();
        list.addAll(notification.notification!);
      });
    }, onError: (error) {
      setState(() {
        _isLoading = false;
      });
      showCustomToast("Something Went Wrong");
    });
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
                currentIndex: 2,
                elevation: 40,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: const Color(0XFF286953),
                unselectedItemColor: Colors.grey,
                selectedFontSize: 0,
                unselectedFontSize: 0,
                onTap: (value) {
                  if (value == 0) {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: MyHomeScreen()));
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => const MyHomeScreen()));
                  }
                  if (value == 1) {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade, child: Wallet()));
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => const Wallet()));
                  }
                  if (value == 3) {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            child: My_Profile()));
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => const My_Profile()));
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
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              'Notifications',
              style: TextStyle(
                  fontFamily: "Poppins", fontSize: 20, color: Colors.black),
            ),
          ),
          body: !_isLoading
              ? Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          padding: const EdgeInsets.all(5),
                          itemCount: list.length,
                          itemBuilder: (context, index) =>
                              GetNotification(index)),
                    )
                  ],
                )
              : Center(
                  child: getProgressBar(),
                ),
        );
      }),
    );
  }

  Widget GetNotification(int index) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: const Icon(
          Icons.wallet,
          color: Colors.green,
        ),
        title: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        list[index].orderId.toString(),
                        style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        list[index].date.toString(),
                        style: const TextStyle(
                            fontFamily: "Poppins", fontSize: 11),
                      ),
                    ],
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      child: Wrap(
                        children: [
                          Text(
                            "Your Order is " +
                                list[index].orderStatus.toString() +
                                " ",
                            // " Please check everything is okay",
                            style: const TextStyle(
                                fontFamily: "Poppins", color: Colors.black26),
                          )
                        ],
                        alignment: WrapAlignment.start,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
