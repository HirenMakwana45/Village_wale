import 'dart:async';
import 'package:flutter/material.dart';
import 'package:village.wale/Cart2.dart';
import 'package:village.wale/OrederDetails.dart';
import 'package:village.wale/Wallet.dart';
import 'CreateSubscription.dart';
import 'HomeScreen.dart';
import 'package:intl/intl.dart';
import 'package:village.wale/Model/CartModel.dart' as model;

class Money_Add_Succesffuly extends StatefulWidget {
  const Money_Add_Succesffuly({Key? key}) : super(key: key);

  @override
  State<Money_Add_Succesffuly> createState() => _Money_Add_SuccesffulyState();
}

class _Money_Add_SuccesffulyState extends State<Money_Add_Succesffuly> {
  List<model.Cart>? cartlist = [];
  List<model.SubscriptionCart> cartsubscribeList = [];
  void initState() {
    super.initState();

    getDate();

    Timer(
        const Duration(seconds: 3),
        () =>

            //  Navigator.pop(context));

            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Wallet())));
  }

  String convertedDateTime = "";

  void getDate() async {
    DateTime now = DateTime.now();
    convertedDateTime =
        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";

    print("Hurrray ");
    print(now);
    print(convertedDateTime);
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
                          Text(
                            'Money Add To Wallet',
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 25,
                                fontWeight: FontWeight.w700),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      )),
                      Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            'Succesffuly',
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 25,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      )),
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
                        children: const [
                          Text('Your transaction has completed',
                              style: TextStyle(
                                  fontFamily: "Poppins", fontSize: 15)),
                        ],
                      )),
                      Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'successfully at ' + convertedDateTime.toString(),
                            maxLines: 2,
                          ),
                        ],
                      )),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
