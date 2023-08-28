import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village.wale/HomeScreen.dart';

class Refer extends StatefulWidget {
  const Refer({Key? key}) : super(key: key);

  @override
  _Refer createState() => _Refer();
}

class _Refer extends State<Refer> {
  String referCode = "";
  @override
  void initState() {
    getReferCode();
    super.initState();
  }

  void getReferCode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      referCode = sharedPreferences.getString("referCode").toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyHomeScreen()));
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          title: const Text(
            'Refer & Earn',
            style: TextStyle(
                fontFamily: "Poppins", fontSize: 20, color: Colors.black),
          ),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) =>
              Container(
            margin: const EdgeInsets.fromLTRB(16, 20, 16, 50),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('images/Group 4534318.png'),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black12,
                  ),
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 1),
                      const Text(
                        'Your Refferal Code',
                        style: TextStyle(fontFamily: "Poppins", fontSize: 14),
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                referCode,
                                style: const TextStyle(
                                    fontFamily: "Poppins",
                                    color: Color(0XFF286953)),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Clipboard.setData(
                                        ClipboardData(text: referCode));
                                  },
                                  icon: const Icon(
                                    Icons.copy,
                                    color: Color(0XFF286953),
                                  )),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: const Color(0XFF286953)),
                      onPressed: () {
                        share();
                      },
                      child: const SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Share Code",
                            textAlign: TextAlign.center,
                          ))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Share',
        text:
            'I am find amazing product in village vila app please download Willage villa Play Store:https://play.google.com/store/apps/details?id=com.example.villagewale \n Pls Use Below Code: $referCode');
  }
}
