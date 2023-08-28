import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village.wale/Cart2.dart';
import 'package:village.wale/HomeScreen.dart';
import 'package:village.wale/persistance/api_repository.dart';
import 'package:village.wale/util/AppUtil.dart';
import 'package:village.wale/util/util.dart';
import 'package:village.wale/Model/CartModel.dart' as model;

import 'Model/CoupenModel.dart';

class Offers extends StatefulWidget {
  const Offers({Key? key}) : super(key: key);

  final _headerStyle = const TextStyle(
      fontFamily: "Poppins",
      color: Color(0xffffffff),
      fontSize: 15,
      fontWeight: FontWeight.bold);
  final _contentStyleHeader = const TextStyle(
      fontFamily: "Poppins",
      color: Color(0xff999999),
      fontSize: 14,
      fontWeight: FontWeight.w700);
  final _contentStyle = const TextStyle(
      fontFamily: "Poppins",
      color: Color(0xff999999),
      fontSize: 14,
      fontWeight: FontWeight.normal);
  final _loremIpsum =
      '''Lorem ipsum is typically a corrupted version of 'De finibus bonorum et malorum', a 1st century BC text by the Roman statesman and philosopher Cicero, with words altered, added, and removed to make it nonsensical and improper Latin.''';

  @override
  State<Offers> createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  bool _isLoading = false;
  final getStorage = GetStorage();
  String displayCoupon = "";
  String Coupon = "";
  TextEditingController DisplayController_text = TextEditingController();
  var Get_Coupon;
  int? Discount_Price;
  String? Price_limit;
  String? Status;
  String? COUPON;
  List<model.Cart>? cartlist = [];
  List<model.SubscriptionCart> cartsubscribeList = [];
  String? M_Description;

  final _headerStyle = const TextStyle(
      fontFamily: "Poppins",
      color: Color(0xffffffff),
      fontSize: 15,
      fontWeight: FontWeight.bold);
  final _contentStyleHeader = const TextStyle(
      fontFamily: "Poppins",
      color: Color(0xff999999),
      fontSize: 14,
      fontWeight: FontWeight.w700);
  final _contentStyle = const TextStyle(
      fontFamily: "Poppins",
      color: Color(0xff999999),
      fontSize: 14,
      fontWeight: FontWeight.normal);
  final _loremIpsum =
      '''Lorem ipsum is typically a corrupted version of 'De finibus bonorum et malorum', a 1st century BC text by the Roman statesman and philosopher Cicero, with words altered, added, and removed to make it nonsensical and improper Latin.''';
  //TextEditingController Coupon = TextEditingController();

  @override
  void initState() {
    // var Product_Id = getStorage.read('PID');
    // print("Product Id Is -->" + Product_Id);

    //  DisplayController_text = TextEditingController(text: 'Dummy');

    // DisplayController_text.addListener(() {
    //   displayCoupon.val(value).defaultValue
    // },)
    DisplayController_text.addListener(_printLatestValue);

    getOffers();
    var FinalAmount = getStorage.read('Amount');
    print(FinalAmount);

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    DisplayController_text.dispose();
    super.dispose();
  }

  List<model.Cart>? Cartlist = [];
  List<model.SubscriptionCart>? Subscriptcartlist = [];

  List<Coupons> list = [];

  void getOffers() {
    setState(() {
      _isLoading = true;
    });
    var api = APICallRepository();
    api.getOfers().then((value) {
      setState(() {
        _isLoading = false;
        var model = CoupenModel.fromJson(jsonDecode(value));
        list.clear();
        list.addAll(model.coupons!);

        if (list.isEmpty) {
          showCustomToast("No Offer Found");
        }
      });
    }, onError: (error) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          title: const Text(
            'Offers',
            style: TextStyle(
                fontFamily: "Poppins", fontSize: 20, color: Colors.black),
          ),
        ),
        body: !_isLoading
            ? Container(
                color: Colors.white,
                margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Have a coupon code?',
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: DisplayController_text,
                            decoration: const InputDecoration(
                              hintText: 'Enter coupon code',
                            ),
                            onChanged: (text) {
                              print('First text field: $text');
                            },
                            style: const TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          height: 48,
                          child: ButtonTheme(
                            //buttonColor: const Color(0XFF286953),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: const Color(0XFF286953),
                              ),
                              onPressed: () {
                                setState(() {
                                  callapi();
                                });
                                // callapi(list[index].id.toString(),
                                //   list[index].couponCode.toString());
                                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => My_subscription()));
                              },
                              //textColor: Colors.white,
                              child: const Text(
                                "Apply",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Container(
                    //   color: Color(0XffFFFFFF),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Image.asset('images/image 57 (Traced).png'),
                    //       Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text('20% OFF',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                    //           Text("Apply on first purchase",style: TextStyle(fontSize: 16),),
                    //           SizedBox(height: 5,),
                    //           Text("Minimum order value 599",style: TextStyle(fontSize: 12,color: Colors.black12),),
                    //           Text("One time per user",style: TextStyle(fontSize: 12,color: Colors.black12),),
                    //         ],
                    //       ),
                    //       Container(
                    //         height: 120,
                    //         child: Padding(
                    //           padding: const EdgeInsets.symmetric(vertical: 10.0),
                    //           child: Column(
                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               Column(
                    //                 children: [
                    //                   Text('Redeem',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Color(0XFF286953)),),
                    //                 ],
                    //               ),
                    //               Column(
                    //                 children: [
                    //                   Text('*T &C apply',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w400,),),
                    //                 ],
                    //               ),
                    //
                    //             ],
                    //           ),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),

                    Expanded(
                        child: ListView.builder(
                      itemBuilder: (context, index) => getCoupenLayout(index),
                      itemCount: list.length,
                      physics: const AlwaysScrollableScrollPhysics(),
                    ))
                    // SizedBox(height: 10,),
                    // Container(
                    //   color: Color(0XffFFFFFF),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Image.asset('images/image 58.png'),
                    //       Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text('Paytm Voucher',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                    //           Text("On shopping for 1999",style: TextStyle(fontSize: 16),),
                    //           SizedBox(height: 5,),
                    //           Text("Minimum order value 599",style: TextStyle(fontSize: 12,color: Colors.black12),),
                    //           Text("One time per user",style: TextStyle(fontSize: 12,color: Colors.black12),),
                    //         ],
                    //       ),
                    //       Container(
                    //         height: 120,
                    //         child: Padding(
                    //           padding: const EdgeInsets.symmetric(vertical: 10.0),
                    //           child: Column(
                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               Column(
                    //                 children: [
                    //                   Text('Redeem',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Color(0XFF286953)),),
                    //                 ],
                    //               ),
                    //               Column(
                    //                 children: [
                    //                   Text('*T &C apply',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w400,),),
                    //                 ],
                    //               ),
                    //
                    //             ],
                    //           ),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 10,),
                    // Container(
                    //   color: Color(0XffFFFFFF),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Image.asset('images/Group.png'),
                    //       ),
                    //       Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Text('Buy 1 Get 1 Free',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.black12),),
                    //           Text("Apply on first purchase",style: TextStyle(fontSize: 16,color: Colors.black12),),
                    //           SizedBox(height: 5,),
                    //           Text("Minimum order value 599",style: TextStyle(fontSize: 12,color: Colors.black12),),
                    //           Text("One time per user",style: TextStyle(fontSize: 12,color: Colors.black12),),
                    //         ],
                    //       ),
                    //       Container(
                    //         height: 120,
                    //         child: Padding(
                    //           padding: const EdgeInsets.symmetric(vertical: 10.0),
                    //           child: Column(
                    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               Column(
                    //                 children: [
                    //                   Text('Expired',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Color(0XffDC2E45)),),
                    //                 ],
                    //               ),
                    //               Column(
                    //                 children: [
                    //                   Text('*T &C apply',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w400,color: Colors.black12),),
                    //                 ],
                    //               ),
                    //
                    //             ],
                    //           ),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              )
            : Center(
                child: getProgressBar(),
              ),
      ),
    );
  }

  Widget getCoupenLayout(int index) {
    return Column(
      children: [
        Container(
          color: const Color(0XffFFFFFF),
          child: Visibility(
            visible: (list[index].status.toString() != 'Deactive'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.network(
                  list[index].image == "" ? noImage : list[index].image!,
                  height: 80,
                  width: 80,
                ),
                Flexible(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              list[index].heading.toString(),
                              style: const TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                              maxLines: 1,
                            ),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              print("&&&");
                                              print(list[index].id.toString());
                                              String coupon_code = list[index]
                                                  .couponCode
                                                  .toString();
                                              print("COUPON CODE -->" +
                                                  coupon_code.toString());
                                              String C_id =
                                                  list[index].id.toString();
                                              print(C_id);

                                              COUPON = C_id;

                                              print(displayCoupon);
                                              displayCoupon = coupon_code;
                                              print("&&&&&&&");
                                              print(displayCoupon.toString());

                                              displayCoupon;
                                              print("DISPLAY COUPON " +
                                                  displayCoupon);

                                              Get_Coupon =
                                                  DisplayController_text.text =
                                                      displayCoupon.toString();
                                              print("DISPLAY COUPON -=--" +
                                                  Get_Coupon);

                                              Discount_Price = int.parse(
                                                  list[index]
                                                      .discount
                                                      .toString());

                                              Price_limit = list[index]
                                                  .priceLimit
                                                  .toString();
                                              Status =
                                                  list[index].status.toString();
                                              print(
                                                  "Selected Index Discount Price" +
                                                      Discount_Price
                                                          .toString());
                                              print(
                                                  "Selected Index Price Limit " +
                                                      Price_limit.toString());
                                              print("Selected Index Status " +
                                                  Status.toString());
                                              var Minimum_Amount =
                                                  list[index].smallDescription;
                                              M_Description = Minimum_Amount;
                                            });

                                            // setState(() {

                                            //   // var a;
                                            //   // a = list[index].couponCode.toString();
                                            //   // list.add(a);
                                            //   // print(a);
                                            // });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: const Text(
                                              'Redeem',
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0XFF286953)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Text(
                                    //   '*T & C apply',
                                    //   style: TextStyle(
                                    //     fontSize: 10,
                                    //     fontWeight: FontWeight.w400,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            list[index].smallDescription.toString(),
                            style: const TextStyle(
                                fontFamily: "Poppins", fontSize: 16),
                            maxLines: 1,
                          )),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            list[index].description.toString(),
                            style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                color: Colors.black26),
                            maxLines: 1,
                          )),
                      const Visibility(
                          visible: false,
                          child: Text(
                            "One time per user",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                color: Colors.black26),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: (list[index].status.toString() != 'Deactive'),
          child: Accordion(
            maxOpenSections: 2,

            rightIcon: const Text('*T & C apply',
                style: TextStyle(fontFamily: "Poppins", color: Colors.black)),
            flipRightIconIfOpen: false,
            // rightIcon: const Icon(
            //   Icons.keyboard_arrow_down_outlined,
            //   color: Colors.black54,
            // ),
            headerBackgroundColorOpened: Colors.white,
            headerBackgroundColor: Colors.white,
            scaleWhenAnimating: true,
            openAndCloseAnimation: true,
            paddingListTop: 2,

            sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
            sectionClosingHapticFeedback: SectionHapticFeedback.light,
            children: [
              AccordionSection(
                isOpen: false,
                flipRightIconIfOpen: false,

                headerBackgroundColorOpened: Colors.white,
                headerBackgroundColor: Colors.white,

                header: const Text('',
                    style:
                        TextStyle(fontFamily: "Poppins", color: Colors.black)),
                content: Center(
                  child: Text(
                    list[index].description.toString(),
                  ),
                ),
                headerPadding: const EdgeInsets.symmetric(horizontal: 10),
                contentHorizontalPadding: 0,
                contentBorderWidth: 1,
                contentBorderColor: Colors.white,
                contentBackgroundColor: Colors.green.shade100,

                // onOpenSection: () => print('onOpenSection ...'),
                // onCloseSection: () => print('onCloseSection ...'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  callapi() async {
    int AmountM = 0;
    int PRICE_LIMIT = 0;
    int NEWDIS = 0;
    double UPDIS = 0;
    int FUR = 0;
    String message;
//  if (DisplayController_text == null) {
//                                 showCustomToast("please enter couponcode");
//                               }
    //showCustomToast("please enter coupon code");
    if (Price_limit == null) {
      showCustomToast("please enter coupon code");
    } else {
      var FinalAmount = getStorage.read('Amount');
      AmountM = int.parse(FinalAmount.toString());
      print(FinalAmount);

      NEWDIS = AmountM * int.parse(Discount_Price.toString());
      UPDIS = NEWDIS / 100;
      FUR = AmountM.floor() - UPDIS.floor();
      Discount_Price = AmountM - FUR;

      print("Abc");
      print(Discount_Price);
      PRICE_LIMIT = int.parse(Price_limit.toString());
      print(PRICE_LIMIT);
      if (Get_Coupon == null) {
        showCustomToast("Incorrect Coupon Code");
        print("ABC");
      } else if (AmountM < PRICE_LIMIT) {
        showCustomToast("Price Must be $Price_limit");
      } else {
        print("TAAP");
        print("DISPLAY CONTROLLERRRRRR " +
            DisplayController_text.text.toString());
        print("Getting coupon is == >" + Get_Coupon);

        print("TIP");
        String Product_Id = '';

        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        String id = sharedPreferences.getString("id").toString();
        print("ID is ==>" + id.toString());
        print("Before Api Calling " + DisplayController_text.text.toString());
        var api = APICallRepository();
        api
            .verifyCoupan(
          DisplayController_text.text.toString(),
          id.toString(),
        )
            .then((value) {
          var json = jsonDecode(value);
          print(id);
          print("My Coupon is" + Get_Coupon.toString() + "===>");
          print(Get_Coupon);
          print(Product_Id);

          print("VALUE" + value);
          message = json["message"];
          print(message);
          if (message == "Coupon Varified Successfully") {
            showCustomToast("Coupon applied Successfully");

            getStorage.write('Coupon_id', COUPON);
            getStorage.write("DISCOUNT_PRICE", Discount_Price);
            getStorage.write("PriceLIMIT", Price_limit);
            getStorage.write("STATUS", Status);
            print(getStorage.read("DISCOUNT_PRICE"));
            print(getStorage.read("PriceLIMIT"));
            print(getStorage.read("STATUS"));
            print(getStorage.read("Coupon_id"));
            print(
                "+++++++++++++++++++++++++++++++ BINGO +++++++++++++++++++++");
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    child: Cart2(cartlist, cartsubscribeList)));
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) => Cart2(cartlist, cartsubscribeList)));
          } else {
            showCustomToast(message);
          }
        }, onError: (error) {
          showCustomToast("Something Went Wrong");
        });
      }
    }
  }

  void _printLatestValue() {
    print('Second text field: ${DisplayController_text.text}');
  }
}
