import 'dart:convert';

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village.wale/Cart2.dart';
import 'package:village.wale/Model/OrderModel.dart';
import 'package:village.wale/Model/ProfileModel.dart';
import 'package:village.wale/persistance/api_repository.dart';
import 'package:village.wale/util/AppUtil.dart';
import 'package:village.wale/util/OrderSuccessScreen.dart';
import 'package:village.wale/util/util.dart';
import 'package:village.wale/Model/CartModel.dart' as model;

import 'AddMoney.dart';
import 'MyOrder.dart';
import 'Wallet.dart';

class Order_details extends StatefulWidget {
  Orders _model;
  Order_details(this._model);

  @override
  State<Order_details> createState() => _Order_detailsState();
}

class _Order_detailsState extends State<Order_details> {
  List<model.Cart>? cartlist = [];
  List<model.SubscriptionCart> cartsubscribeList = [];

  String name = "";
  String email = "";
  String address = "";
  String number = "";
  bool _isLoading = false;
  final getStorage = GetStorage();
  String? Transaction_Id;
  String? service_fee;
  int service_amount = 0;
  int Discountprice = 0;
  String? TOTAL_AMOUNT;
  String? transaction_status;
  double height = 0;
  String convertedDateTime = "";

  int total_amount = 0;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    total_amount = int.parse(widget._model.totalAmount.toString());
    print("hurray " + total_amount.toString());
    Transaction_Id = getStorage.read('T_id');
    service_fee = getStorage.read("d_charge");

    service_amount = int.parse(service_fee.toString());
    print("Hurray received Transaction Id " + Transaction_Id.toString());
    print("Hurray received service_fee Id " + service_fee.toString());

    getProfile();
    statuscall();
    super.initState();
  }

  void getProfile() async {
    String id = "";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    id = sharedPreferences.getString("id").toString();
    setState(() {
      _isLoading = true;
    });
    var api = APICallRepository();
    api.getProfile(id).then((value) {
      setState(() {
        _isLoading = false;
        var model = ProfileModel.fromJson(jsonDecode(value));
        name = model.name.toString();
        email = model.gmail.toString();
        address = model.address.toString();
        number = model.mobileNo.toString();
      });
    }, onError: (error) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  statuscall() async {
    setState(() {
      height = 30;
    });
    await Future.delayed(Duration(seconds: 2), () {
      setState(() {
        height = -30;
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
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const My_Oders()));
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          title: Text(
            'Order ' + widget._model.orderId.toString(),
            style: const TextStyle(
                fontFamily: "Poppins", fontSize: 20, color: Colors.black),
          ),
        ),
        body: !_isLoading
            ? LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) =>
                    Container(
                  margin: const EdgeInsets.fromLTRB(16, 15, 16, 15),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: const [
                          Text(
                            'Order Status',
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ]),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Image.asset('images/Group 37762.png'),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Order confirmed',
                                  style: TextStyle(
                                      fontFamily: "Poppins", fontSize: 16),
                                ),
                                // Text('11 April, 2022 10:30 AM',style: TextStyle(color: Colors.black12),),
                              ],
                            ),
                          ],
                        ),
                        Visibility(
                          child: GestureDetector(
                            onTap: statuscall,
                            child: AnimatedContainer(
                              width: 2,
                              height: 2,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                //  borderRadius: _borderRadius,
                              ),
                              duration: Duration(seconds: 2),
                              curve: Curves.linear,
                            ),
                          ),
                          visible:
                              widget._model.status == "Accepted" ? true : false,
                        ),
                        Visibility(
                          visible:
                              widget._model.status == "Accepted" ? true : false,
                          child: Row(
                            children: [
                              Image.asset('images/Group 37760.png'),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Processing',
                                    style: TextStyle(
                                        fontFamily: "Poppins", fontSize: 16),
                                  ),
                                  // Text('11 April, 2022 10:30 AM',style: TextStyle(color: Colors.black12),),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          child: const SizedBox(
                            height: 20,
                          ),
                          visible: widget._model.status == "Completed"
                              ? true
                              : false,
                        ),
                        Visibility(
                          visible: widget._model.status != "Completed"
                              ? false
                              : true,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset('images/Group 37760.png'),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Processing',
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 16),
                                      ),
                                      // Text('11 April, 2022 10:30 AM',style: TextStyle(color: Colors.black12),),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Image.asset('images/Group 37761.png'),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Delivered',
                                        style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 16),
                                      ),
                                      // Text('11 April, 2022 10:30 AM',style: TextStyle(color: Colors.black12),),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          'Delievred To',
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: ShapeDecoration(
                              color: const Color(0xffFFFFFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  name.toString(),
                                  style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      address.toString(),
                                      style: const TextStyle(
                                          fontFamily: "Poppins", fontSize: 16),
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.call_sharp),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        number.toString(),
                                        style: const TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 16),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          'Products',
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: ShapeDecoration(
                              color: const Color(0xffFFFFFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                        widget._model.productImage.toString() ==
                                                    "" ||
                                                widget._model.productImage
                                                        .toString() ==
                                                    "null"
                                            ? noImage
                                            : widget._model.productImage
                                                .toString(),
                                        scale: 4,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            widget._model.productName
                                                .toString(),
                                            style: const TextStyle(
                                                fontFamily: "Poppins",
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.currency_rupee,
                                                      size: 15,
                                                    ),
                                                    Text(
                                                      widget._model.totalAmount
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontFamily: "Poppins",
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    const Text(
                                                      ' / kg',
                                                      style: TextStyle(
                                                          fontFamily: "Poppins",
                                                          color:
                                                              Colors.black12),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  'Qty: ',
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      color: Colors.black),
                                                ),
                                                Text(widget._model.quantity
                                                    .toString()),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                const Icon(
                                                  Icons.currency_rupee,
                                                  size: 15,
                                                  color: Color(0XFF286953),
                                                ),
                                                Text(
                                                  widget._model.totalAmount
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0XFF286953),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(height: 10,),
                        // Container(
                        //   decoration: ShapeDecoration(
                        //       color: Color(0xffFFFFFF),
                        //       shape: RoundedRectangleBorder (
                        //         borderRadius: BorderRadius.circular(10.0),
                        //       )
                        //   ),
                        //   child: Column(
                        //     children: [
                        //       Row(
                        //         children: [
                        //           Padding(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child: Image.asset('images/image 40.png',scale: 3,),
                        //           ),
                        //           Column(
                        //             crossAxisAlignment: CrossAxisAlignment.start,
                        //             children: [
                        //               Row(
                        //                 children: [
                        //                   Text('Swadist Soyabean Oil',style: TextStyle(fontSize: 16),),
                        //                 ],
                        //               ),
                        //               SizedBox(
                        //                 width: MediaQuery.of(context).size.width*0.7,
                        //                 child: Row(
                        //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //                   children: [
                        //                     Row(
                        //                       children: [
                        //                         Icon(Icons.currency_rupee,size: 15,),
                        //                         Text('95',style: TextStyle(fontWeight: FontWeight.w500),),
                        //                         Text(' / kg',style: TextStyle(color: Colors.black12),),
                        //                       ],
                        //                     ),
                        //                     Text('Qty: 2'),
                        //                     Row(
                        //                       children: [
                        //                         Icon(Icons.currency_rupee,size: 15,color: Color(0XFF286953),),
                        //                         Text('190.00',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Color(0XFF286953),),)
                        //                       ],
                        //                     )
                        //                   ],
                        //                 ),
                        //               ),
                        //             ],
                        //           )
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(height: 10,),
                        // Container(
                        //   decoration: ShapeDecoration(
                        //       color: Color(0xffFFFFFF),
                        //       shape: RoundedRectangleBorder (
                        //         borderRadius: BorderRadius.circular(10.0),
                        //       )
                        //   ),
                        //   child: Column(
                        //     children: [
                        //       Row(
                        //         children: [
                        //           Padding(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child: Image.asset('images/image 40.png',scale: 3,),
                        //           ),
                        //           Column(
                        //             crossAxisAlignment: CrossAxisAlignment.start,
                        //             children: [
                        //               Row(
                        //                 children: [
                        //                   Text('Swadist Soyabean Oil',style: TextStyle(fontSize: 16),),
                        //                 ],
                        //               ),
                        //               SizedBox(
                        //                 width: MediaQuery.of(context).size.width*0.7,
                        //                 child: Row(
                        //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //                   children: [
                        //                     Row(
                        //                       children: [
                        //                         Icon(Icons.currency_rupee,size: 15,),
                        //                         Text('95',style: TextStyle(fontWeight: FontWeight.w500),),
                        //                         Text(' / kg',style: TextStyle(color: Colors.black12),),
                        //                       ],
                        //                     ),
                        //                     Text('Qty: 2'),
                        //                     Row(
                        //                       children: [
                        //                         Icon(Icons.currency_rupee,size: 15,color: Color(0XFF286953),),
                        //                         Text('190.00',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Color(0XFF286953),),)
                        //                       ],
                        //                     )
                        //                   ],
                        //                 ),
                        //               ),
                        //             ],
                        //           )
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          'Payment Method',
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: ShapeDecoration(
                              color: const Color(0xffFFFFFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Amount to pay',
                                      style: const TextStyle(
                                          fontFamily: "Poppins",
                                          color: Colors.black),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.currency_rupee,
                                          size: 18,
                                        ),
                                        Text(
                                          widget._model.totalAmount.toString(),
                                          style: const TextStyle(
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Service fee',
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: Colors.black12),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.currency_rupee,
                                          size: 18,
                                        ),
                                        Text(
                                          service_fee.toString(),
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       const Text(
                              //         'Discount',
                              //         style: const TextStyle(
                              //             color: Colors.black12),
                              //       ),
                              //       Row(
                              //         children: [
                              //           Text(
                              //             '-',
                              //             style: TextStyle(
                              //                 color: Color(0XFF286953)),
                              //           ),
                              //           Icon(Icons.currency_rupee,
                              //               size: 18, color: Color(0XFF286953)),
                              //           Text(
                              //             Discountprice.toString(),
                              //             style: TextStyle(
                              //                 fontWeight: FontWeight.w500,
                              //                 fontSize: 16,
                              //                 color: Color(0XFF286953)),
                              //           ),
                              //         ],
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total',
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.currency_rupee,
                                            size: 18,
                                            color: const Color(0XFF286953)),
                                        Text(
                                          TOTAL_AMOUNT =
                                              "${total_amount + service_amount - Discountprice}",
                                          style: const TextStyle(
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Color(0XFF286953)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: Discountprice != 0,
                                child: Container(
                                  decoration: ShapeDecoration(
                                      color: const Color(0xffFCDA28),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                      )),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Image.asset('images/Group 37736.png'),
                                        const Text(
                                          'You have saved ',
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        ),
                                        const Icon(Icons.currency_rupee,
                                            size: 15),
                                        Text(
                                          Discountprice.toString() +
                                              ' on this order',
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: ShapeDecoration(
                              color: const Color(0xffFFFFFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: const Text(
                                  'Transaction ID',
                                  style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  Transaction_Id.toString() == "null"
                                      ? "No TransactionId Found"
                                      : Transaction_Id.toString(),
                                  style: const TextStyle(
                                      fontFamily: "Poppins", fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        // Container(
                        //   height: 48,
                        //   width: double.infinity,
                        //   child: ButtonTheme(
                        //     buttonColor: Color(0XFF286953),
                        //     child: RaisedButton(
                        //       onPressed: () {
                        //         // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => My_subscription()));
                        //       },
                        //       textColor: Colors.white,
                        //       child: Text("Share Code",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                        //     ),
                        //   ),
                        // ),

                        Column(
                          children: [
                            if (widget._model.status! == "Pending") ...[
                              InkWell(
                                onTap: () {
                                  showCustomToast("Cancel Order");
                                },
                                child: SizedBox(
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              side: const BorderSide(
                                                  color: Color(0XFF286953))),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: const [
                                                Icon(
                                                  Icons.cancel,
                                                  color: Color(0XFF286953),
                                                ),
                                                Text(
                                                  "Cancel Order",
                                                  style: TextStyle(
                                                      fontFamily: "Poppins",
                                                      color: Color(0XFF286953)),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        onPressed: () {
                                          cancelOrder(
                                              widget._model.id.toString());
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ] else ...[
                              Container(
                                height: 48,
                                width: double.infinity,
                                child: ButtonTheme(
                                  buttonColor: const Color(0XFF286953),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      repetOrder();
                                      //callApi();
                                    },
                                    //textColor: Colors.white,
                                    child: const Text(
                                      "Repeat Order",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        primary: Color(0XFF286953)),
                                  ),
                                ),
                              ),
                            ]
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: getProgressBar(),
              ),
      ),
    );
  }

  List<String> value = ["06:00 AM - 09:00 AM", "11:00 AM - 01:00 PM"];
  String date = "Select Date";
  String selectTime = "";
  // void openBottomSheet() {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (context) {
  //         return Container(
  //           height: 160,
  //           child: Column(
  //             children: [
  //               const SizedBox(
  //                 height: 10,
  //               ),
  //               Container(
  //                 child: const Text(
  //                   "Select Prefer  Time",
  //                   style: TextStyle(
  //                       color: Colors.black,
  //                       fontSize: 20,
  //                       fontWeight: FontWeight.bold),
  //                 ),
  //                 alignment: Alignment.topLeft,
  //                 margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
  //               ),
  //               Visibility(
  //                 visible: false,
  //                 child: InkWell(
  //                   onTap: () {
  //                     print("====>TAP");

  //                     // DateTimePicker(
  //                     //   initialValue: '',
  //                     //   firstDate: DateTime(2000),
  //                     //   lastDate: DateTime(2100),
  //                     //   dateLabelText: 'Date',
  //                     //   onChanged: (val) {
  //                     //     setState(() {
  //                     //       // date=val.toString();
  //                     //     });
  //                     //     // showCustomToast(val.toString());
  //                     //   },
  //                     //   validator: (val) {
  //                     //     // showCustomToast(val.toString());
  //                     //   },
  //                     //   onSaved: (val) {
  //                     //     setState(() {
  //                     //       // date=val.toString();
  //                     //       // showCustomToast(date.toString());
  //                     //     });
  //                     //   },
  //                     // );
  //                   },
  //                   child: Card(
  //                     margin: const EdgeInsets.fromLTRB(10, 5, 0, 0),
  //                     child: InkWell(
  //                       onTap: () async {
  //                         DateTime selectedDate = DateTime.now();

  //                         final DateTime? picked = await showDatePicker(
  //                           context: context,
  //                           firstDate: DateTime(2015, 8),
  //                           lastDate: DateTime(2101),
  //                           initialDate: selectedDate,
  //                         );

  //                         setState(() {
  //                           date = picked!.year.toString() +
  //                               "-" +
  //                               picked.month.toString() +
  //                               "-" +
  //                               picked.day.toString();
  //                           print("==>ENTRY==>" + date.toString());
  //                         });
  //                       },
  //                       child: Container(
  //                         padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
  //                         child: Row(
  //                           children: [
  //                             Image.asset(
  //                               "images/calender.png",
  //                               height: 20,
  //                               width: 20,
  //                             ),
  //                             const SizedBox(
  //                               width: 5,
  //                             ),
  //                             Text(
  //                               date.toString(),
  //                               style: const TextStyle(fontSize: 15),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(
  //                 height: 7,
  //               ),
  //               SingleChildScrollView(
  //                 scrollDirection: Axis.horizontal,
  //                 child: Container(
  //                   margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
  //                   alignment: Alignment.topLeft,
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       CustomRadioButton(
  //                         spacing: 1.0,
  //                         padding: 5,
  //                         wrapAlignment: WrapAlignment.spaceEvenly,
  //                         elevation: 0,
  //                         autoWidth: true,
  //                         radius: 20,
  //                         enableShape: true,
  //                         shapeRadius: 50,
  //                         absoluteZeroSpacing: false,
  //                         unSelectedColor: Theme.of(context).canvasColor,
  //                         buttonLables: value,
  //                         buttonValues: value,
  //                         buttonTextStyle: const ButtonTextStyle(
  //                             selectedColor: Colors.white,
  //                             unSelectedColor: Color(0XFF286953),
  //                             textStyle: TextStyle(fontSize: 16)),
  //                         radioButtonValue: (value) {
  //                           if (kDebugMode) {
  //                             print(value);
  //                           }

  //                           setState(() {
  //                             selectTime = value.toString();
  //                           });
  //                         },
  //                         selectedColor: const Color(0XFF286953),
  //                         unSelectedBorderColor: const Color(0XFF286953),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(
  //                 height: 10,
  //               ),
  //               Container(
  //                 margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
  //                 width: double.infinity,
  //                 child: ElevatedButton(
  //                     style: ElevatedButton.styleFrom(
  //                         shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(10)),
  //                         primary: const Color(0XFF286953)),
  //                     onPressed: () {
  //                       Navigator.of(context).push(MaterialPageRoute(
  //                           builder: (context) => Add_money(
  //                               false,
  //                               widget._model.productId!,
  //                               int.parse(widget._model.quantity.toString()),
  //                               widget._model.totalAmount.toString(),
  //                               "",
  //                               selectTime)));
  //                     },
  //                     child: const SizedBox(
  //                         width: double.infinity,
  //                         child: Text(
  //                           "Process",
  //                           textAlign: TextAlign.center,
  //                         ))),
  //               )
  //             ],
  //           ),
  //         );
  //       });
  // }

  void callApi() async {
    void getDate() async {
      DateTime now = DateTime.now();
      convertedDateTime =
          "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";

      print("Hurrray ");
      print(now);
      print(convertedDateTime);

      selectTime = convertedDateTime;

      print(selectTime);
      // // DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");/**/
      // String formattedDate = DateFormat('kk:mm:ss  EEE d MMM').format(now);
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("id").toString();

    getStorage.read("");
    var subtype = getStorage.read("subscriptiontype");
    var concate = getStorage.read("concate");
    var startdate = getStorage.read("startdate");
    var enddate = getStorage.read("enddate");

    print(concate);
    print(startdate);
    print(enddate);
    print(subtype);

    // if (walletAmount == 0) {
    //   showCustomToast("No Wallet Balance");
    //   return;
    // }

    // if (date == "") {
    //   showCustomToast("Please select Date");
    //   return;
    // }
    // if (selectTime == "") {
    //   showCustomToast("Please select Time");
    //   return;
    // }

    if (widget._model == null) {
      print("===>id$id");
      print("===>Product id=>${widget._model.productId.toString()}");
      print("===>Product id=>${widget._model.quantity}");
      print("===>Product id=>$concate");
      print("===>SUBSCRIBE TYPE==>$subtype");
      print("===DATE==>$startdate");
      print("====EndDate==>$enddate");
      print("Select date & time is -->" + date.toString());

      var Product_Id = widget._model.productId.toString();
      getStorage.write("PID", Product_Id);
      print(Product_Id);

      var api = APICallRepository();
      api
          .addSubscrption(
        id.toString(),
        '',
        widget._model.quantity.toString(),
        startdate.toString(),
        concate.toString().substring(0, concate.toString().length - 1),
        subtype.toString(),
        enddate.toString(),
        total_amount.toString(),
        widget._model.volume.toString(),
      )
          .then((value) {
        print(value);
        setState(() {
          _isLoading = false;
        });
      }, onError: (error) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        showCustomToast(error.toString());
      });
    }

    // print("Combine String is ==>" + Combinelist.toString());
    print("SELECTED TIME IS " + selectTime.toString());
    print(id);
    // var api = APICallRepository();
    // api.addOrder(id, selectTime.toString()).then((value) {
    //   var json = jsonDecode(value);
    //   print(value);

    //   String message = json["messaage"];

    //   if (message == 'Add Product to cart') {
    //     if (message == "Not Sufficient Balance in Wallet") {
    //       Navigator.of(context)
    //           .push(MaterialPageRoute(builder: (context) => const Wallet()));
    //       showCustomToast("Payment Failed");
    //     }
    //     // else {
    //     //   Navigator.of(context).push(
    //     //       MaterialPageRoute(builder: (context) => OrderSuccessScreen()));
    //     // }
    //   }

    //   // showCustomToast(message.toString());
    //   if (message == "Order added Successfully") {
    //     transaction_status = "Success";
    //   } else {
    //     transaction_status = "Failed";
    //   }
    //   print(message);
    //   if (message == json["messaage"]) {
    //     print(" ==>" + id);
    //     print(" ==>" + total_amount.toString());
    //     print(" ==>" + widget._model.productId.toString());
    //     print(" ==>" + transaction_status.toString());
    //     // print(" ==>" + id);

    //     //var api = APICallRepository();
    //     api
    //         .addUserTransation(
    //             id,
    //             total_amount.toString(),
    //             widget._model.productId.toString(),
    //             transaction_status.toString(),
    //             "Money Add to Wallet")
    //         .then((value) {
    //       print("This Is Value ==>" + value);
    //       setState(() {
    //         //    _isPaymentProcess = false;
    //       });

    //       // showCustomToast("Payment Failed");
    //     }, onError: (error) {
    //       setState(() {
    //         //   _isPaymentProcess = false;
    //       });

    //       showCustomToast(error.toString());
    //       print("ERROR " + error.toString());
    //       showCustomToast("Payment Failed");
    //     });
    //   }
    // }, onError: (error) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   showCustomToast(error.toString());
    // });
  }

  void repetOrder() async {
    String? type = "Normal";
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String userId = _prefs.getString("id").toString();
    var api = APICallRepository();
    print("receving userid is " + userId);
    print(userId);
    print(
      widget._model.id.toString(),
    );
    api
        .addToCart(
            userId,
            widget._model.productId.toString(),
            widget._model.quantity.toString(),
            widget._model.volume!.replaceAll(RegExp(r'[^0-9]'), ''),
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
      if (message == "Product added to cart") {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Cart2(cartlist, cartsubscribeList)));
      }
    }, onError: (error) {
      showCustomToast(error.toString());
    });

    // openBottomSheet();
    // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Add_money(false,widget._model.id!,int.parse(widget._model.quantity.toString()),widget._model.totalAmount.toString(),"")));
  }

  void cancelOrder(String id) {
    var api = APICallRepository();
    api.cancelUserOrder(id).then((value) {
      var json = jsonDecode(value);
      String message = json["message"];
      showCustomToast(message.toString());
      Navigator.of(context).pop();
    }, onError: (error) {
      showCustomToast(error.toString());
    });
  }
}
