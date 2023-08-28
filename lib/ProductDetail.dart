import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:page_transition/page_transition.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village.wale/Cart2.dart';
import 'package:village.wale/Model/HomeModel.dart';
import 'package:village.wale/persistance/api_repository.dart';
import 'package:village.wale/util/AppUtil.dart';
import 'AddMoney.dart';
import 'HomeScreen.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:village.wale/Model/CartModel.dart' as model;

import 'Model/CartModel.dart';

class Detail extends StatefulWidget {
  Products _model;
  Detail(this._model);

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  List<Cart>? _list;
  List<SubscriptionCart>? _list2;
  List<model.Cart>? cartlist = [];
  List<model.SubscriptionCart> cartsubscribeList = [];

  var pageIndex = 0;
  double price = 0;
  double secondPrice = 0;
  List<Widget> items = [];
  List<String> volume = [];
  String? type = "Normal";

  // List<String> secondVolume=[];
  String productvolume = "";
  double discountPrice = 0;
  double DPRICE = 0;
  @override
  void initState() {
    setState(() {
      price = double.parse(widget._model.normalPrice.toString());

      //secondPrice = double.parse(widget._model.normalPrice.toString());
      items.add(Image.network(widget._model.image == ""
          ? "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png"
          : widget._model.image!));

      DPRICE = price;

      double mDis =
          price * double.parse(widget._model.normalDiscount.toString());
      double mPrice = mDis / 100;
      double sPrice = DPRICE - mPrice;
      DPRICE = sPrice;
      discountPrice = DPRICE;
      secondPrice = discountPrice;

      //secondPrice = 0;

      if (widget._model.quantityAvailable != null) {
        String name =
            widget._model.quantityAvailable.toString().replaceAll(' ', '');

        // widget._model.quantityAvailable!.split(",").forEach((tag) {
        //   volume.add(tag + " " + widget._model.volume.toString());
        //   // secondVolume.add(tag);
        // });

        name.split(",").forEach((tag) {
          volume.add(tag + " " + widget._model.volume.toString());
          // secondVolume.add(tag);
        });
        productvolume = volume.first.toString();
      }
    });
    super.initState();
  }

  int quentity = 1;
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Builder(builder: (context) {
            return Scaffold(
              body: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ButtonTheme(
                                buttonColor: Colors.white,
                                child: SizedBox(
                                  height: 46,
                                  width: 161.5,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // openBottomSheet();
                                      if (quentity == 0) {
                                        showCustomToast(
                                            "Please Select Atleast one quentity");
                                      } else if (productvolume == "") {
                                        showCustomToast("Please Select Volume");
                                      } else {
                                        Buyonceaddtocart(widget._model.id);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        side: const BorderSide(
                                            color: Color(0XFF286953)),
                                        primary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    child: const Text(
                                      'Buy Once',
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: Color(0XFF286953)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ButtonTheme(
                                  buttonColor: const Color(0XFF286953),
                                  child: SizedBox(
                                    height: 46,
                                    width: 161.5,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        addToCart2(widget._model.id);

                                        // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Cart()));
                                      },
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          primary: const Color(0XFF286953)),
                                      // textColor: Colors.white,),

                                      child: Row(
                                        children: const [
                                          Icon(Icons.shopping_cart_outlined),
                                          Text(
                                            "Add to Cart",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.arrow_back_ios),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MyHomeScreen()));
                                    },
                                  ),
                                  Text(
                                    widget._model.categoryName.toString(),
                                    style: TextStyle(
                                        fontFamily: "Poppins", fontSize: 20),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.fade,
                                          child: Cart2(
                                              cartlist, cartsubscribeList)));
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (context) =>
                                  //         Cart2(cartlist, cartsubscribeList)));
                                },
                                icon: const Icon(Icons.shopping_cart_outlined),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(7, 3, 7, 3),
                                  decoration: ShapeDecoration(
                                      color: const Color(0xffFCDA28),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      )),
                                  child: Center(
                                      child: Text(
                                          widget._model.normalDiscount
                                                  .toString() +
                                              '% Off',
                                          style: const TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 14,
                                          ))),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    share();
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(Icons.share),
                                      SizedBox(
                                        width: 15.w,
                                      ),
                                      // Icon(Icons.favorite_border_outlined),
                                    ],
                                  ),
                                ),
                                widget._model.isfavourite.toString() != "False"
                                    ? InkWell(
                                        onTap: () {
                                          setState(() {
                                            removeFavourite(
                                                widget._model.id.toString());
                                            widget._model.isfavourite = "False";
                                          });
                                        },
                                        child: Image.asset(
                                          "images/select_heart.png",
                                          height: 20,
                                          width: 20,
                                        ))
                                    : InkWell(
                                        onTap: () {
                                          setState(() {
                                            addFavourite(
                                                widget._model.id.toString());
                                            widget._model.isfavourite = "True";
                                          });
                                        },
                                        child: Image.asset(
                                          "images/unselect_heart.png",
                                          height: 20,
                                          width: 20,
                                        ))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CarouselSlider(
                                    items: items,
                                    options: CarouselOptions(
                                      height: 220,
                                      aspectRatio: 16 / 9,
                                      viewportFraction: 0.8,
                                      initialPage: 0,
                                      enableInfiniteScroll: true,
                                      reverse: false,
                                      autoPlay: true,
                                      autoPlayInterval:
                                          const Duration(seconds: 3),
                                      autoPlayAnimationDuration:
                                          const Duration(milliseconds: 800),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enlargeCenterPage: true,
                                      scrollDirection: Axis.horizontal,
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                widget._model.name.toString(),
                                style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  Image.asset('images/Star.png'),
                                  Text(widget._model.rattings.toString()),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: ShapeDecoration(
                                    color: const Color(0XffFEF4D3),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: const BorderSide(
                                            color: Color(0xffFEF4D3)))),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 7, 10, 7),
                                  child: Center(
                                      child: Text(
                                    widget._model.categoryName.toString(),
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        color: getColorFromHex("#CB9C00")),
                                  )),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Wrap(
                            alignment: WrapAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Text(
                                    widget._model.dscription.toString(),
                                    style: const TextStyle(
                                        fontFamily: "Poppins",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5.h,
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
                                            fontFamily: "Poppins",
                                            fontSize: 16)),
                                    radioButtonValue: (value) {
                                      // setState(() {
                                      //   print("&&&&&&" +
                                      //       discountPrice.toString());
                                      //   print(
                                      //       "&&&&&&" + secondPrice.toString());

                                      //   print(
                                      //       "_______________________________________");
                                      //   print("Staring Value Is -->" +
                                      //       value.toString());

                                      //   //value = 0;

                                      //   price = 0;
                                      //   secondPrice = 0;
                                      //   // discountPrice = 1;
                                      //   //secondPrice = 0;

                                      //   // widget._model.normalPrice="0";
                                      //   // productvolume = volume.first.toString();
                                      //   // print(
                                      //   //     "Product Volume By Default is --> " +
                                      //   //         productvolume);
                                      //   productvolume = value.toString();
                                      //   print("Product Volume is Now-->" +
                                      //       productvolume);
                                      //   print("==>" + productvolume.toString());
                                      //   print(value);
                                      //   print("Product  Value Is -->" +
                                      //       productvolume);
                                      //   var str = productvolume;
                                      //   var parts = str.split(" ");
                                      //   print(parts);
                                      //   var fValue = parts[0].trim();
                                      //   var mValue = double.parse(fValue);
                                      //   price = double.parse(widget
                                      //           ._model.normalPrice
                                      //           .toString()) *
                                      //       mValue;
                                      //   //secondPrice = discountPrice;

                                      //   //secondPrice = discountPrice;

                                      //   secondPrice = discountPrice * mValue;

                                      //   // widget._model.normalPrice=price.toString();
                                      //   // print(parts);
                                      //   // print(str);
                                      //   //print(mValue.toString());
                                      //   //print(fValue.toString());
                                      //   // print(quentity);
                                      //   print("==PRICE==>" + price.toString());
                                      //   print("Second price" +
                                      //       secondPrice.toString());
                                      //   print("dicount price" +
                                      //       discountPrice.toString());
                                      //   print("mvalue is " + mValue.toString());

                                      //   quentity = 1;

                                      //   // price=double.parse(widget._model.normalPrice.toString())*quentity;
                                      //   // price=int.parse(widget._model.normalPrice.toString())*quentity;

                                      //   discountPrice = 0;
                                      //   double mDis = price *
                                      //       double.parse(widget
                                      //           ._model.normalDiscount
                                      //           .toString());
                                      //   double mPrice = mDis / 100;
                                      //   double sPrice = discountPrice + mPrice;
                                      //   discountPrice = price - sPrice;
                                      //   print(widget._model.normalDiscount);
                                      //   print(widget._model.normalPrice);
                                      //   print(mPrice);
                                      //   print(sPrice);
                                      //   print(discountPrice);
                                      //   print(
                                      //       "_______________________________________");
                                      // });

                                      setState(() {
                                        discountPrice = DPRICE;

                                        price = 0;
                                        secondPrice = 0;
                                        // widget._model.normalPrice="0";
                                        productvolume = value.toString();
                                        print("==>" + productvolume.toString());

                                        var str = productvolume;
                                        var parts = str.split(" ");
                                        var fValue = parts[0].trim();

                                        var mValue = double.parse(fValue);
                                        price = double.parse(widget
                                                ._model.normalPrice
                                                .toString()) *
                                            mValue;
                                        secondPrice = DPRICE * mValue;
                                        // widget._model.normalPrice=price.toString();

                                        print("==PRICE==>" + price.toString());

                                        quentity = 1;
                                        print("==PRICE==>" + price.toString());
                                        // price=double.parse(widget._model.normalPrice.toString())*quentity;
                                        // price=int.parse(widget._model.normalPrice.toString())*quentity;

                                        discountPrice = 0;
                                        double mDis = price *
                                            double.parse(widget
                                                ._model.normalDiscount
                                                .toString());
                                        double mPrice = mDis / 100;
                                        double sPrice = discountPrice + mPrice;
                                        discountPrice = price - sPrice;
                                      });
                                    },
                                    defaultSelected: volume.first.toString(),
                                    selectedColor: getColorFromHex("#286953"),
                                    unSelectedBorderColor: Colors.transparent,
                                    selectedBorderColor: Colors.transparent,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(
                                      Icons.currency_rupee,
                                      color: Color(0XFF286953),
                                    ),
                                    Text(
                                      discountPrice.toString(),
                                      style: const TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 28.48,
                                          color: Color(0XFF286953)),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(
                                      width: 7,
                                    ),
                                    const Icon(
                                      Icons.currency_rupee,
                                      color: Colors.black,
                                      size: 20,
                                    ),
                                    Text(price.toString(),
                                        style: const TextStyle(
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.lineThrough),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    const SizedBox(
                                      width: 7,
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                print(
                                                    "==>MINUS SECOND PRICE=>" +
                                                        secondPrice.toString());

                                                if (quentity != 1) {
                                                  setState(() {
                                                    quentity = quentity - 1;
                                                    // price=  secondPrice - double.parse(widget._model.normalPrice.toString());
                                                    discountPrice =
                                                        secondPrice * quentity;
                                                  });
                                                }
                                              },
                                              icon: Image.asset(
                                                "images/minus.png",
                                                width: 20,
                                              ),
                                            ),

                                            const SizedBox(
                                              width: 6,
                                            ),
                                            Text(
                                              quentity.toString(),
                                              style: const TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 15),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                // setState(() {
                                                //   print(discountPrice);
                                                //   print("==>ADD SECOND PRICE=>" +
                                                //       secondPrice.toString());
                                                //   quentity = quentity + 1;

                                                //   // price=  secondPrice + double.parse(widget._model.normalPrice.toString());
                                                //   discountPrice =
                                                //       secondPrice * quentity;
                                                //   print(quentity);
                                                //   print(secondPrice);
                                                //   //discountPrice =
                                                // });

                                                setState(() {
                                                  print(
                                                      "==>ADD SECOND PRICE=>" +
                                                          secondPrice
                                                              .toString());
                                                  // discountPrice = DPRICE;
                                                  quentity = quentity + 1;

                                                  // price=  secondPrice + double.parse(widget._model.normalPrice.toString());
                                                  discountPrice =
                                                      secondPrice * quentity;
                                                  print(discountPrice);
                                                  print(secondPrice);
                                                  print(quentity);
                                                });
                                              },
                                              // icon: Icon(Icons.add_circle_outline_outlined)
                                              icon: Image.asset(
                                                "images/plus.png",
                                                width: 20,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 6,
                                            ),
                                            // InkWell(onTap: (){
                                            //   if(quentity!=0){
                                            //     setState((){
                                            //       quentity=quentity-1;
                                            //       // price=  secondPrice - double.parse(widget._model.normalPrice.toString());
                                            //       price=  secondPrice * quentity;
                                            //     });
                                            //   }
                                            // },child:Text("-",style: TextStyle(fontSize: 20),)),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
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
                    "Select Prefer Date & Time",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                ),
                Visibility(
                  visible: false,
                  child: InkWell(
                    onTap: () {
                      print("====>TAP");

                      // DateTimePicker(
                      //   initialValue: '',
                      //   firstDate: DateTime(2000),
                      //   lastDate: DateTime(2100),
                      //   dateLabelText: 'Date',
                      //   onChanged: (val) {
                      //     setState(() {
                      //       // date=val.toString();
                      //     });
                      //     // showCustomToast(val.toString());
                      //   },
                      //   validator: (val) {
                      //     // showCustomToast(val.toString());
                      //   },
                      //   onSaved: (val) {
                      //     setState(() {
                      //       // date=val.toString();
                      //       // showCustomToast(date.toString());
                      //     });
                      //   },
                      // );
                    },
                    child: Card(
                      margin: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                      child: InkWell(
                        onTap: () {
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
                                style: TextStyle(
                                    fontFamily: "Poppins", fontSize: 15),
                              ),
                            ],
                          ),
                        ),
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
                          width: 0,
                          buttonLables: value,
                          unSelectedColor: getColorFromHex("#e4ecd6"),
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
                          selectedColor: getColorFromHex("#286953"),
                          unSelectedBorderColor: Colors.transparent,
                          selectedBorderColor: Colors.transparent,
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
                        if (quentity == 0) {
                          showCustomToast("Please Select Atleast one quentity");
                        } else if (productvolume == "") {
                          showCustomToast("Please Select Volume");
                        } else {
                          // Buyonceaddtocart(widget._model.id);
                          // Navigator.of(context).push(
                          //   MaterialPageRoute<void>(
                          //       builder: (BuildContext context) =>
                          //           Cart2(cartlist, cartsubscribeList)),
                          // );
                        }

                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => Add_money(
                        //         false,
                        //         widget._model.id!,
                        //         quentity,
                        //         price.toString(),
                        //         productvolume,
                        //         selectTime)));
                        // }
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

  Future<void> Buyonceaddtocart(String? id) async {
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

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String userId = _prefs.getString("id").toString();
    var api = APICallRepository();
    api
        .addToCart(
            userId,
            id.toString(),
            quentity.toString(),
            productvolume,
            type.toString(),
            null.toString(),
            null.toString(),
            null.toString(),
            null.toString())
        .then((value) {
      print(value);
      var json = jsonDecode(value);
      var message = json["message"];
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: Cart2(cartlist, cartsubscribeList)));
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //       builder: (BuildContext context) =>
      //           Cart2(cartlist, cartsubscribeList)),
      //  );

      // showCustomToast(message.toString());
    }, onError: (error) {
      showCustomToast(error.toString());
    });
  }

  Future<void> addToCart2(String? id) async {
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

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String userId = _prefs.getString("id").toString();
    var api = APICallRepository();
    api
        .addToCart(
            userId,
            id.toString(),
            quentity.toString(),
            productvolume,
            type.toString(),
            null.toString(),
            null.toString(),
            null.toString(),
            null.toString())
        .then((value) {
      print(value);
      var json = jsonDecode(value);
      var message = json["message"];
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //       builder: (BuildContext context) =>
      //           Cart2(cartlist, cartsubscribeList)),
      // );

      showCustomToast(message.toString());
    }, onError: (error) {
      showCustomToast(error.toString());
    });
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Share',
        text:
            'I am find amazing product in village vila app please download Willage villa Play Store:https://play.google.com/store/apps/details?id=com.example.villagewale');
  }

  void addFavourite(String productId) async {
    String userId = "";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getString("id").toString();

    print("==>USERID==>" + userId.toString());
    print("==>PRODUCT ID==>" + productId.toString());
    var api = APICallRepository();
    api.addFavourite(userId, productId).then((value) {
      var json = jsonDecode(value);
      print("==> Add SEARCH Favourite SUCCESS=>" + json['messaage'].toString());
    }, onError: (error) {
      print("==> Add SEARCH Favourite ERROR=>" + error.toString());
    });
  }

  void removeFavourite(String productId) async {
    String userId = "";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getString("id").toString();
    var api = APICallRepository();
    api.removeFavourite(userId, productId).then((value) {
      var json = jsonDecode(value);
      print("==> REMOVE SEARCH Favourite SUCCESS=>" +
          json['messaage'].toString());
    }, onError: (error) {
      print("==> REMOVE SEARCH Favourite ERROR=>" + error.toString());
    });
  }
}
