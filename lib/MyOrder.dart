import 'dart:convert';

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village.wale/HomeScreen.dart';
import 'package:village.wale/Model/OrderModel.dart';
import 'package:village.wale/Model/TransactionModel.dart';
import 'package:village.wale/persistance/api_repository.dart';
import 'package:village.wale/util/AppUtil.dart';
import 'package:village.wale/util/util.dart';

import 'AddMoney.dart';
import 'OrederDetails.dart';

class My_Oders extends StatefulWidget {
  const My_Oders({Key? key}) : super(key: key);

  @override
  State<My_Oders> createState() => _My_OdersState();
}

class _My_OdersState extends State<My_Oders> {
  List<String> topList = [];

  @override
  void initState() {
    getMyOrder();
    topList.add("All");
    topList.add("In Progress");
    topList.add("Completed");
    topList.add("Cancelled");

    super.initState();
  }

  String? Order_id;

  String? _transaction_id;
  bool _isLoading = false;
  List<Orders> list = [];
  List<Transactions> _list2 = [];

  //TransactionModel? _transactionModel;
  String filter = "All";
  final getStorage = GetStorage();

  void getMyOrder() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("id").toString();

    setState(() {
      _isLoading = true;
    });
    print("==>FILTER==>" + filter.toString());
    var api = APICallRepository();
    api.getMyOrder(id, filter).then((value) {
      setState(() {
        _isLoading = false;
        print("===>VALUE==>" + value.toString());
        var model = OrderModel.fromJson(jsonDecode(value));
        list.clear();
        list.addAll(model.orders!);
      });
      if (list.isEmpty) {
        showCustomToast("No Order Found");
      }
    }, onError: (error) {
      setState(() {
        _isLoading = false;
      });
      showCustomToast(error.toString());
    });

    api.getTransactionHistory(id, '').then((value) {
      setState(() {
        _isLoading = false;

        var model = TransactionModel.fromJson(jsonDecode(value));
        _list2.clear();
        _list2.addAll(model.transactions!);

        if (list.isEmpty) {
          // showCustomToast("No Record Found");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0XffFFFFFF),
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
              'My orders',
              style:
                  const TextStyle(fontFamily: "Poppins", color: Colors.black),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  height: 40,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => getDaily(index),
                      itemCount: topList.length),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Total Order( " + list.length.toString() + " )",
                    style: const TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                ),
                !_isLoading
                    ? ListView.builder(
                        itemBuilder: (context, index) => getData(index),
                        itemCount: list.length,
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                      )
                    : Center(
                        child: getProgressBar(),
                      )
              ],
            ),
          )),
    );
  }

  int selectPosition = 0;
  Widget getDaily(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          selectPosition = index;
          filter = topList[index];
          getMyOrder();

          // subscribeType=dailyList[index].toString();
        });
      },
      child: Container(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          height: 30,
          margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          decoration: ShapeDecoration(
              color: selectPosition == index
                  ? const Color(0XFF286953)
                  : getColorFromHex("#e4ecd6"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              )),
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              topList[index].toString(),
              style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: selectPosition == index
                      ? Colors.white
                      : getColorFromHex("#286953")),
            ),
          ))),
    );
  }

  Widget getData(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          print(_list2);
          _transaction_id = _list2[index].transaction_id;
          print(_transaction_id);
          getStorage.write('T_id', _transaction_id);
          print("BOOOM BOOOM ");
          print(getStorage.read('T_id'));
        });
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child: Order_details(list[index])));
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => Order_details(list[index])));
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(9, 4, 9, 4),
        // color: Color(0XffFFFFFF),
        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(width: 0, color: Colors.black12))),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
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
                    list[index].status.toString(),
                    style: const TextStyle(
                        fontFamily: "Poppins", color: Color(0Xff04B200)),
                  ),
                ],
              ),
              const SizedBox(
                height: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          list[index].date.toString(),
                          style: TextStyle(
                              fontFamily: "Poppins",
                              color: getColorFromHex("#878787")),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Visibility(
                          visible: true,
                          child: Row(
                            children: [
                              Image.network(
                                list[index].productImage.toString() == "" ||
                                        list[index].productImage.toString() ==
                                            "null"
                                    ? noImage
                                    : list[index].productImage.toString(),
                                height: 30,
                                width: 30,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                      ]),
                  Column(
                    children: [
                      if (list[index].status == "Pending") ...[
                        TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black54),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: const BorderSide(
                                            color: Colors.black54)))),
                            onPressed: () {
                              setState(() {
                                Order_id = list[index].orderId;
                                print(
                                    "I Am removing MMM " + Order_id.toString());
                                cancelOrder(list[index].id.toString());
                                list.removeAt(index);
                              });
                            },
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                ),
                                Text('Canecl',
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colors.white,
                                    )),
                              ],
                            )),
                      ] else if (list[index].status == "Pending") ...[
                        TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        getColorFromHex("#44533C")),
                                // backgroundColor: getColorFromHex("#44533C"),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: const BorderSide(
                                            color: Colors.black54)))),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: Order_details(list[index])));
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) =>
                              //         Order_details(list[index])));
                            },
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                ),
                                Text('Reorder',
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colors.white,
                                    )),
                              ],
                            )),
                      ] else ...[
                        TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black54),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: const BorderSide(
                                            color: Colors.black54)))),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: Order_details(list[index])));
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) =>
                              //         Order_details(list[index])));
                            },
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                ),
                                Text('Reorder',
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colors.white,
                                    )),
                              ],
                            )),
                      ]
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              const Divider(),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Total Products:',
                        style: TextStyle(
                            fontFamily: "Poppins",
                            color: getColorFromHex("#878787")),
                      ),
                      Text(list[index].quantity.toString()),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.currency_rupee,
                            color: Colors.green,
                          ),
                          Text(
                            list[index].totalAmount.toString(),
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // List<String> value=["06:00 AM - 09:00 AM","11:00 AM - 01:00 PM"];
  // String selectTime="";
  // void openBottomSheet() {
  //   showModalBottomSheet(context: context, builder: (context){
  //
  //     return Container(
  //       height: 200,
  //       child: Column(
  //         children: [
  //           SizedBox(height: 10,),
  //           Container(child: Text("Select Prefer Date & Time",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),alignment: Alignment.topLeft,margin: EdgeInsets.fromLTRB(10, 0, 0, 0),),
  //           InkWell(
  //             onTap: (){
  //               print("====>TAP");
  //
  //               // DateTimePicker(
  //               //   initialValue: '',
  //               //   firstDate: DateTime(2000),
  //               //   lastDate: DateTime(2100),
  //               //   dateLabelText: 'Date',
  //               //   onChanged: (val) {
  //               //     setState(() {
  //               //       // date=val.toString();
  //               //     });
  //               //     // showCustomToast(val.toString());
  //               //   },
  //               //   validator: (val) {
  //               //     // showCustomToast(val.toString());
  //               //   },
  //               //   onSaved: (val) {
  //               //     setState(() {
  //               //       // date=val.toString();
  //               //       // showCustomToast(date.toString());
  //               //     });
  //               //   },
  //               // );
  //             },
  //             child: Card(
  //               margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
  //               child: InkWell(
  //                 onTap: (){
  //
  //                   DateTimePicker(
  //                     initialValue: '',
  //                     firstDate: DateTime(2000),
  //                     lastDate: DateTime(2100),
  //                     dateLabelText: 'Date',
  //                     onChanged: (val) {
  //                       setState(() {
  //                         // date=val.toString();
  //                       });
  //                       // showCustomToast(val.toString());
  //                     },
  //                     validator: (val) {
  //                       // showCustomToast(val.toString());
  //                     },
  //                     onSaved: (val) {
  //                       setState(() {
  //                         // date=val.toString();
  //                         // showCustomToast(date.toString());
  //                       });
  //                     },
  //                   );
  //                 },
  //                 child: Container(
  //                   padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
  //                   child: Row(children: [
  //                     Image.asset("images/calender.png",height: 20,width: 20,),
  //                     SizedBox(width: 5,),
  //                     Text("Saturday 26 March, 2022",style: TextStyle(fontSize: 15),),
  //                   ],),
  //                 ),
  //               ),
  //             ),
  //           ),
  //
  //           SizedBox(height: 7,),
  //           SingleChildScrollView(
  //             scrollDirection: Axis.horizontal,
  //             child: Container(
  //               margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
  //               alignment: Alignment.topLeft,
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   CustomRadioButton(
  //                     spacing: 1.0,
  //                     padding: 5,
  //                     wrapAlignment: WrapAlignment.spaceEvenly,
  //                     elevation: 0,
  //                     autoWidth: true,
  //                     radius: 20,
  //                     enableShape: true,
  //                     shapeRadius: 50,
  //                     absoluteZeroSpacing: false,
  //                     unSelectedColor: Theme.of(context).canvasColor,
  //                     buttonLables: value,
  //                     buttonValues: value,
  //                     buttonTextStyle: const ButtonTextStyle(
  //                         selectedColor: Colors.white,
  //                         unSelectedColor: Color(0XFF286953),
  //                         textStyle: TextStyle(fontSize: 16)),
  //                     radioButtonValue: (value) {
  //                       if (kDebugMode) {
  //                         print(value);
  //                       }
  //
  //                       setState(() {
  //                         selectTime=value.toString();
  //                       });
  //                     },
  //                     selectedColor: Color(0XFF286953),
  //                     unSelectedBorderColor: Color(0XFF286953),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //
  //           SizedBox(height: 10,),
  //           Container(
  //             margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
  //             width: double.infinity,
  //             child: ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                     shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(10)
  //                     ),
  //                     primary: Color(0XFF286953)),
  //                 onPressed: () {
  //                     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Add_money(false,widget._model.id!,quentity,widget._model.normalPrice!,productvolume,selectTime)));
  //
  //
  //                 },
  //                 child: const SizedBox(width: double.infinity,child: Text("Process",textAlign: TextAlign.center,))
  //             ),
  //           )
  //         ],
  //       ),
  //     );
  //   });
  // }

  // List<String> value=["06:00 AM - 09:00 AM","11:00 AM - 01:00 PM"];
  // String selectTime="";
  // void openBottomSheet() {
  //   showModalBottomSheet(context: context, builder: (context){
  //
  //     return Container(
  //       height: 200,
  //       child: Column(
  //         children: [
  //           SizedBox(height: 10,),
  //           Container(child: Text("Select Prefer Date & Time",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),alignment: Alignment.topLeft,margin: EdgeInsets.fromLTRB(10, 0, 0, 0),),
  //           InkWell(
  //             onTap: (){
  //               print("====>TAP");
  //
  //               // DateTimePicker(
  //               //   initialValue: '',
  //               //   firstDate: DateTime(2000),
  //               //   lastDate: DateTime(2100),
  //               //   dateLabelText: 'Date',
  //               //   onChanged: (val) {
  //               //     setState(() {
  //               //       // date=val.toString();
  //               //     });
  //               //     // showCustomToast(val.toString());
  //               //   },
  //               //   validator: (val) {
  //               //     // showCustomToast(val.toString());
  //               //   },
  //               //   onSaved: (val) {
  //               //     setState(() {
  //               //       // date=val.toString();
  //               //       // showCustomToast(date.toString());
  //               //     });
  //               //   },
  //               // );
  //             },
  //             child: Card(
  //               margin: EdgeInsets.fromLTRB(10, 5, 0, 0),
  //               child: InkWell(
  //                 onTap: (){
  //
  //                   DateTimePicker(
  //                     initialValue: '',
  //                     firstDate: DateTime(2000),
  //                     lastDate: DateTime(2100),
  //                     dateLabelText: 'Date',
  //                     onChanged: (val) {
  //                       setState(() {
  //                         // date=val.toString();
  //                       });
  //                       // showCustomToast(val.toString());
  //                     },
  //                     validator: (val) {
  //                       // showCustomToast(val.toString());
  //                     },
  //                     onSaved: (val) {
  //                       setState(() {
  //                         // date=val.toString();
  //                         // showCustomToast(date.toString());
  //                       });
  //                     },
  //                   );
  //                 },
  //                 child: Container(
  //                   padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
  //                   child: Row(children: [
  //                     Image.asset("images/calender.png",height: 20,width: 20,),
  //                     SizedBox(width: 5,),
  //                     Text("Saturday 26 March, 2022",style: TextStyle(fontSize: 15),),
  //                   ],),
  //                 ),
  //               ),
  //             ),
  //           ),
  //
  //           SizedBox(height: 7,),
  //           SingleChildScrollView(
  //             scrollDirection: Axis.horizontal,
  //             child: Container(
  //               margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
  //               alignment: Alignment.topLeft,
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   CustomRadioButton(
  //                     spacing: 1.0,
  //                     padding: 5,
  //                     wrapAlignment: WrapAlignment.spaceEvenly,
  //                     elevation: 0,
  //                     autoWidth: true,
  //                     radius: 20,
  //                     enableShape: true,
  //                     shapeRadius: 50,
  //                     absoluteZeroSpacing: false,
  //                     unSelectedColor: Theme.of(context).canvasColor,
  //                     buttonLables: value,
  //                     buttonValues: value,
  //                     buttonTextStyle: const ButtonTextStyle(
  //                         selectedColor: Colors.white,
  //                         unSelectedColor: Color(0XFF286953),
  //                         textStyle: TextStyle(fontSize: 16)),
  //                     radioButtonValue: (value) {
  //                       if (kDebugMode) {
  //                         print(value);
  //                       }
  //
  //                       setState(() {
  //                         selectTime=value.toString();
  //                       });
  //                     },
  //                     selectedColor: Color(0XFF286953),
  //                     unSelectedBorderColor: Color(0XFF286953),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //
  //           SizedBox(height: 10,),
  //           Container(
  //             margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
  //             width: double.infinity,
  //             child: ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                     shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(10)
  //                     ),
  //                     primary: Color(0XFF286953)),
  //                 onPressed: () {
  //
  //
  //                     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Add_money(false,widget._model.id!,quentity,widget._model.normalPrice!,productvolume,selectTime)));
  //
  //
  //                 },
  //                 child: const SizedBox(width: double.infinity,child: Text("Process",textAlign: TextAlign.center,))
  //             ),
  //           )
  //         ],
  //       ),
  //     );
  //   });
  // }

  void cancelOrder(String id) {
    print("Selected Order id Is " + Order_id.toString());
    print(id);
    var api = APICallRepository();
    api.cancelUserOrder(Order_id.toString()).then((value) {
      var json = jsonDecode(value);
      String message = json["message"];
      showCustomToast(message.toString());
    }, onError: (error) {
      showCustomToast(error.toString());
    });
  }
}

class Completed extends StatefulWidget {
  const Completed({Key? key}) : super(key: key);

  @override
  State<Completed> createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // color: Color(0XffFFFFFF),
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(width: 0, color: Colors.black12))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Order #TM145865',
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Completed',
                    style: TextStyle(
                        fontFamily: "Poppins", color: Color(0Xff04B200)),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          '11 April, 2022 10:15 AM',
                          style: const TextStyle(
                              fontFamily: "Poppins", color: Colors.black12),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Image.asset('images/image 42.png'),
                            const SizedBox(
                              width: 2,
                            ),
                            Image.asset(
                              'images/image 43.png',
                              scale: 2,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Image.asset('images/image 44.png'),
                            const SizedBox(
                              width: 2,
                            ),
                            Image.asset('images/image 45.png'),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ]),
                  Column(
                    children: [
                      TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black54),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(
                                          color: Colors.black54)))),
                          onPressed: () {},
                          child: Row(
                            children: const [
                              Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),
                              Text('Cancelled',
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colors.white,
                                  )),
                            ],
                          )),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side:
                            const BorderSide(width: 1, color: Colors.black12))),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Text(
                        'Total Products:',
                        style: TextStyle(
                            fontFamily: "Poppins", color: Colors.black12),
                      ),
                      Text('4'),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.currency_rupee,
                            color: Colors.green,
                          ),
                          Text(
                            '190.00',
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          // color: Color(0XffFFFFFF),
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(width: 0, color: Colors.black12))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Order #TM145865',
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Completed',
                    style: TextStyle(
                        fontFamily: "Poppins", color: Color(0Xff04B200)),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          '11 April, 2022 10:15 AM',
                          style: TextStyle(
                              fontFamily: "Poppins", color: Colors.black12),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Image.asset('images/image 42.png'),
                            const SizedBox(
                              width: 2,
                            ),
                            Image.asset(
                              'images/image 43.png',
                              scale: 2,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Image.asset('images/image 44.png'),
                            const SizedBox(
                              width: 2,
                            ),
                            Image.asset('images/image 45.png'),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ]),
                  Column(
                    children: [
                      TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black54),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(
                                          color: Colors.black54)))),
                          onPressed: () {},
                          child: Row(
                            children: const [
                              Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),
                              Text('Cancelled',
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colors.white,
                                  )),
                            ],
                          )),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side:
                            const BorderSide(width: 1, color: Colors.black12))),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Text(
                        'Total Products:',
                        style: TextStyle(
                            fontFamily: "Poppins", color: Colors.black12),
                      ),
                      Text('4'),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.currency_rupee,
                            color: Colors.green,
                          ),
                          Text(
                            '190.00',
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          // color: Color(0XffFFFFFF),
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(width: 0, color: Colors.black12))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Order #TM145865',
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Completed',
                    style: TextStyle(
                        fontFamily: "Poppins", color: Color(0Xff04B200)),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          '11 April, 2022 10:15 AM',
                          style: TextStyle(
                              fontFamily: "Poppins", color: Colors.black12),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Image.asset('images/image 42.png'),
                            const SizedBox(
                              width: 2,
                            ),
                            Image.asset(
                              'images/image 43.png',
                              scale: 2,
                            ),
                            const SizedBox(
                              width: 2,
                            ),
                            Image.asset('images/image 44.png'),
                            const SizedBox(
                              width: 2,
                            ),
                            Image.asset('images/image 45.png'),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ]),
                  Column(
                    children: [
                      TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black54),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: const BorderSide(
                                          color: Colors.black54)))),
                          onPressed: () {},
                          child: Row(
                            children: const [
                              Icon(
                                Icons.refresh,
                                color: Colors.white,
                              ),
                              Text('Cancelled',
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colors.white,
                                  )),
                            ],
                          )),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side:
                            const BorderSide(width: 1, color: Colors.black12))),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Text(
                        'Total Products:',
                        style: TextStyle(
                            fontFamily: "Poppins", color: Colors.black12),
                      ),
                      Text('4'),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.currency_rupee,
                            color: Colors.green,
                          ),
                          Text(
                            '190.00',
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
