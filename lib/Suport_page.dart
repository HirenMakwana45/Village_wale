import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

import 'HomeScreen.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 3,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade, child: MyHomeScreen()));
                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (context) => MyHomeScreen()));
              },
            ),
            backgroundColor: Colors.white,
            title: Text(
              "Help",
              style: TextStyle(
                  fontFamily: "Poppins",
                  color: Color(0xff212223),
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text(
                    "WhatsApp & Phone",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0XFF286953)),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: _callNumber,
                          child: Icon(
                            Icons.call,
                            size: 25,
                            color: const Color(0XFF286953),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          onTap: _callNumber,
                          child: Text(
                            "9898959693",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black26),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text(
                    "Support",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0XFF286953),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: _sendingMails,
                          child: Icon(
                            Icons.mail,
                            size: 25,
                            color: Color(0XFF286953),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          onTap: _sendingMails,
                          child: Text(
                            "team@mechodal.com",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black26),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _callNumber() async {
    const number = '9898959693'; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  _sendingMails() async {
    var url = Uri.parse("mailto:team@mechodal.com");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
