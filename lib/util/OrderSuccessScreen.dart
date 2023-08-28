import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:village.wale/MyOrder.dart';

import '../HomeScreen.dart';

class OrderSuccessScreen extends StatefulWidget {
  @override
  _OrderSuccessScreen createState() => _OrderSuccessScreen();
}

class _OrderSuccessScreen extends State<OrderSuccessScreen> {
  String convertedDateTime = "";

  @override
  void initState() {
    Timer(
        const Duration(seconds: 2),
        () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MyHomeScreen()),
            (route) => false));
    super.initState();
  }

  void getDate() async {
    DateTime now = DateTime.now();
    convertedDateTime =
        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";

    // // DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");/**/
    // String formattedDate = DateFormat('kk:mm:ss  EEE d MMM').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/Group 6872.png'),
              const SizedBox(
                height: 40,
              ),
              Container(
                  alignment: Alignment.center,
                  height: 100,
                  child: Column(
                    children: [
                      Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Expanded(
                              child: Text(
                            'Your Order has been accepted',
                            style: TextStyle(
                                fontSize: 23, fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )),
                        ],
                      )),

                      // Center(
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       children: [
                      //
                      //         Text('accepted',style: TextStyle(fontSize: 23,fontWeight: FontWeight.w700),),
                      //       ],
                      //     )
                      // ),
                    ],
                  )),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                  height: 40,
                  child: Column(
                    children: [
                      Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Container(
                                  margin: const EdgeInsets.fromLTRB(7, 0, 7, 0),
                                  child: const Text(
                                    'Your items has been placed and is on it’s way to being processed',
                                    style: TextStyle(fontSize: 15),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ))),
                        ],
                      )),
                    ],
                  )),
              const SizedBox(
                height: 100,
              ),
              Container(
                height: 40,
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        primary: const Color(0XFF286953)),
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const MyHomeScreen()),
                          (route) => false);
                    },
                    child: const SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Back to home",
                          textAlign: TextAlign.center,
                        ))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
