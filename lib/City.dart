import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village.wale/persistance/api_repository.dart';
import 'package:village.wale/util/AppUtil.dart';
import 'package:village.wale/util/util.dart';
import 'HomeScreen.dart';
import 'Map.dart';
import 'Model/CityModel.dart';
import 'Signup.dart';

class CityPage extends StatefulWidget {
  @override
  _MyCityState createState() => _MyCityState();
}
// class MyCity extends StatefulWidget {
//   const MyCity({Key? key}) : super(key: key);
//
//   @override
//   State<MyCity> createState() => _MyCityState();
// }

class _MyCityState extends State<CityPage> {
  bool _isLoading = false;
  var greencolor = const Color(0XFF286953);
  int select_index = 0;
  final getStorage = GetStorage();
  String _cityName = "Mumbai";
  String? _delivery_charge;
  String? TmpCharge;

  List<Cities> list = [];
  @override
  void initState() {
    getAllCity();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: !_isLoading
              ? SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child: const SignupPage()));
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => const SignupPage()));
                          },
                          icon: const Icon(Icons.arrow_back_ios)),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Select City",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 28,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text(
                        "Any grocery iteam deliver to your city now",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      GridView.builder(
                          physics: const ScrollPhysics(),
                          itemCount: list.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisExtent: 120,
                          ),
                          itemBuilder: (context, index) => CardMade(index)),
                      //
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        height: 45,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                primary: greencolor),
                            onPressed: () {
                              callApi();
                            },
                            child: const SizedBox(
                                width: double.infinity,
                                child: const Text(
                                  "Continue",
                                  textAlign: TextAlign.center,
                                ))),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(
                    backgroundColor: greencolor,
                  ),
                ),
        ),
      ),
    );
  }

  void callApi() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isAddressAdd", true);

    print("====>CITY==>" + _cityName.toString());
    sharedPreferences.setString("city", _cityName.toString());

    print(getStorage.read('d_charge'));
    if (_delivery_charge == null) {
      _delivery_charge = _delivery_charge = TmpCharge;

      print("RECIVED" + _delivery_charge.toString());
    }
    setState(() {
      TmpCharge = list[0].deliveryCharge.toString();
      print("BOOM BOOM" + TmpCharge.toString());
      print(TmpCharge);

      _delivery_charge = TmpCharge;
      getStorage.write('d_charge', _delivery_charge);
      print("Dhinchkyauuu");
      print(_delivery_charge);
    });
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.fade,
            child: const Set_delivery_locaton()));
    // Navigator.of(context).push(
    //     MaterialPageRoute(builder: (context) => const Set_delivery_locaton()));
  }

  Widget CardMade(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          select_index = index;
          _cityName = list[index].name.toString();
          TmpCharge = list[index].deliveryCharge.toString();
          print("BOOM BOOM 2 " + TmpCharge.toString());
          print(TmpCharge);

          _delivery_charge = list[index].deliveryCharge.toString();
          getStorage.write('d_charge', _delivery_charge);
          print("Dhinchkyauuu  2 ");
          print(list[index].deliveryCharge.toString());
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: ShapeDecoration(
                      color: index == select_index
                          ? getColorFromHex("#FCDA28")
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(
                              width: 2, color: Color(0xff9D9FA2)))),
                  child: Center(
                    child: Image.network(
                      list[index].photo!,
                      height: 90,
                      width: 110,
                    ),
                    // child: Image.network(noImage,height: 90,width: 110,),
                  ),
                ),
              ),
              Visibility(
                  visible: index == select_index ? true : false,
                  child: Align(
                      alignment: Alignment.topRight,
                      child: Image.asset(
                        "images/correct.png",
                        height: 20,
                        width: 20,
                      )))
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            list[index].name!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  Widget GetContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(width: 2, color: Colors.green))),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Image.asset('images/Image1.png'),
          ),
        ),
      ),
    );
  }

  void getAllCity() {
    setState(() {
      _isLoading = true;
    });
    var api = APICallRepository();
    api.cityList().then((value) {
      setState(() {
        _isLoading = false;

        print("===VALUE==>" + value.toString());

        var model = CityModel.fromJson(jsonDecode(value));
        list.clear();
        list.addAll(model.cities!);

        print("Size==>" + list.length.toString());
      });
    }, onError: (error) {
      setState(() {
        _isLoading = false;
        showCustomToast(error);
      });
    });
  }
}
