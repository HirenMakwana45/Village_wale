import 'dart:convert';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village.wale/persistance/api_repository.dart';
import 'package:village.wale/util/AppUtil.dart';

import 'HomeScreen.dart';
import 'LogInPage1.dart';
import 'Model/TransactionModel.dart';

class Transaction_history extends StatefulWidget {
  const Transaction_history({Key? key}) : super(key: key);

  @override
  State<Transaction_history> createState() => _Transaction_historyState();
}

class _Transaction_historyState extends State<Transaction_history> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller1 = TextEditingController();
  List<Transactions> _searchList = [];
  // var items = [
  //   'January',
  //   'Febuary',
  //   'March',
  //   'April',
  //   'May',
  //   'June',
  //   'July',
  //   'Augast',
  //   'Saptember',
  //   'October',
  //   'November',
  //   'December'
  // ];
  var ABCLIST = ['Money  ', 'Order', 'Transaction failed'];
  //var items1 = ['Date', 'Month', 'Year'];
  // var MONTH = ['Date', 'Month', 'Year'];
  var Filter = [
    'Filter by',
    'Money Add to Wallet',
    'Order',
    'failed',
    'Refund for Order'
  ];
  String? _chosenVal;
  DateTime? datel;

  var DATEFILTER = [
    'All',
    'Date',
  ];

  List<Transactions> list = [];
  String id = "";
  String? C;

  String date = "Date";
  bool _isLoading = false;
  String dropdownvalue = 'Month';
  String dropdownvalue2 = 'Filter by';
  String dropdoownvalue3 = "All";
  String? UpdateFilter;
  @override
  void initState() {
    getTransactionHistory();
    super.initState();
  }

  void getTransactionHistory() async {
    SharedPreferences sharedPrefrence = await SharedPreferences.getInstance();
    id = sharedPrefrence.getString("id").toString();

    String filterString = "";
    setState(() {
      _isLoading = true;

      if (date == "Date") {
        // date="";
        filterString = "";
      }
      if (date == "Date") {
        // date="";
        filterString = "";
      }
    });

    var api = APICallRepository();
    api.getTransactionHistory(id, filterString).then((value) {
      setState(() {
        _isLoading = false;

        var model = TransactionModel.fromJson(jsonDecode(value));
        list.clear();
        list.addAll(model.transactions!);

        if (list.isEmpty) {
          showCustomToast("No Record Found");
        }
        _searchList = list;
      });
    }, onError: (error) {
      setState(() {
        _isLoading = false;
      });
      showCustomToast("Something Went Wrong");
    });
  }

  void _runFilter(String enteredKeyword) {
    List<Transactions> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = list;
    } else {
      results = list
          .where((user) =>
              user.amount
                  .toString()
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              user.transactionType
                  .toString()
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              user.transactionStatus
                  .toString()
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              user.transactionStatus
                  .toString()
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _searchList = results;
    });
  }

  void _runFilter2(String enteredKeyword) {
    List<Transactions> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = list;
    } else {
      results = list
          .where((user) =>
              user.amount
                  .toString()
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              user.transactionType
                  .toString()
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              user.transactionStatus
                  .toString()
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _searchList = results;
    });
  }

  void _runFilter3(String enteredKeyword) {
    List<Transactions> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = list;
    } else {
      results = list
          .where((user) =>
              user.amount
                  .toString()
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              user.transactionType
                  .toString()
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              user.transactionStatus
                  .toString()
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              user.date.toString().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _searchList = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 35,
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Text(
                        'Transaction history',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: TextField(
                          maxLength: 10,
                          onChanged: (value) {
                            _runFilter2(value);
                          },
                          keyboardType: TextInputType.text,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            counterText: "",

                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            floatingLabelStyle:
                                TextStyle(color: getColorPrimary()),
                            // filled: true,
                            // fillColor: Color(0xffEFF1F4),
                            prefixIcon: Icon(
                              Icons.search,
                              size: 30,
                              color: getColorFromHex("#9D9FA2"),
                            ),

                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.green),
                              borderRadius: BorderRadius.circular(10),
                            ),

                            labelText: "Search your payment",
                            hintStyle: TextStyle(
                              color: getColorPrimary(),
                              fontSize: 13,
                            ),
                          ))),

                  const SizedBox(
                    height: 20,
                  ),
                  // Row(
                  //   children: [
                  //     Container(
                  //       height: 34,
                  //       width: 120,
                  //       child: TextField(
                  //         controller: _controller,
                  //         decoration: InputDecoration(
                  //           border: OutlineInputBorder(),
                  //           label: Text(
                  //             'Month',
                  //             style: TextStyle(color: Color(0xffC1C1C1)),
                  //           ),
                  //           suffixIcon: PopupMenuButton<String>(
                  //             icon: const Icon(Icons.arrow_drop_down),
                  //             onSelected: (String value) {
                  //               _controller.text = value;
                  //             },
                  //             itemBuilder: (BuildContext context) {
                  //               return items
                  //                   .map<PopupMenuItem<String>>((String value) {
                  //                 return new PopupMenuItem(
                  //                     child: new Text(value), value: value);
                  //               }).toList();
                  //             },
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: 5,
                  //     ),
                  //     Container(
                  //       height: 34,
                  //       width: 130,
                  //       child: TextField(
                  //         controller: _controller1,
                  //         decoration: InputDecoration(
                  //           border: OutlineInputBorder(),
                  //           label: Text(
                  //             'Filter by',
                  //             style: TextStyle(color: Color(0xffC1C1C1)),
                  //           ),
                  //           suffixIcon: PopupMenuButton<String>(
                  //             icon: const Icon(Icons.arrow_drop_down),
                  //             onSelected: (String value) {
                  //               _controller1.text = value;
                  //             },
                  //             itemBuilder: (BuildContext context) {
                  //               return items1
                  //                   .map<PopupMenuItem<String>>((String value) {
                  //                 return new PopupMenuItem(
                  //                     child: new Text(value), value: value);
                  //               }).toList();
                  //             },
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  Row(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.only(right: 5.0),
                      //   child: Row(
                      //     children: [
                      //       InkWell(
                      //         onTap: () async {
                      //           print("===>MOTAP");
                      //           DateTime selectedDate = DateTime.now();
                      //           final DateTime? picked = await showDatePicker(
                      //             builder: ((context, child) {
                      //               return Theme(
                      //                   data: Theme.of(context).copyWith(
                      //                     colorScheme: const ColorScheme.light(
                      //                       primary: Color(
                      //                           0XFF286953), // header background color
                      //                       onPrimary: Colors
                      //                           .black45, // header text color
                      //                       onSurface:
                      //                           Colors.black, // body text color
                      //                     ),
                      //                     textButtonTheme: TextButtonThemeData(
                      //                       style: TextButton.styleFrom(
                      //                         primary: const Color(
                      //                             0XFF286953), // button text color
                      //                       ),
                      //                     ),
                      //                   ),
                      //                   child: child!);
                      //             }),
                      //             context: context,
                      //             firstDate: DateTime(2015, 8),
                      //             lastDate: DateTime(2101),
                      //             initialDate: selectedDate,
                      //           );
                      //           if (picked != null) {
                      //             date = picked.year.toString() +
                      //                 "-" +
                      //                 picked.month.toString() +
                      //                 "-" +
                      //                 picked.day.toString();

                      //             _runFilter3(date);
                      //           } else {
                      //             selectedDate;
                      //           }

                      //           setState(() {
                      //             DropdownButtonHideUnderline(
                      //               child: GestureDetector(
                      //                 child: DropdownButton(
                      //                   isDense: true,

                      //                   // isExpanded: true,
                      //                   value: dropdoownvalue3,
                      //                   icon: const Icon(
                      //                     Icons.keyboard_arrow_down,
                      //                     color: Colors.black87,
                      //                   ),
                      //                   items: DATEFILTER.map((String C) {
                      //                     return DropdownMenuItem(
                      //                       value: C,
                      //                       child: Text(C,
                      //                           style: const TextStyle(
                      //                               color: Colors.black,
                      //                               fontSize: 15)),
                      //                     );
                      //                   }).toList(),

                      //                   onChanged: (String? newValue3) {
                      //                     setState(() {
                      //                       //_runFilter3(date);

                      //                       _runFilter3(newValue3.toString());
                      //                     });
                      //                   },

                      //                   //onChanged: (value) {
                      //                 ),
                      //                 onTap: () {},
                      //               ),
                      //             );
                      //           });
                      //         },
                      //         child: Container(
                      //           decoration: BoxDecoration(
                      //               borderRadius: BorderRadius.circular(10),
                      //               border: Border.all(color: Colors.black38),
                      //               color: getColorFromHex("#FFFFFF")),
                      //           padding: const EdgeInsets.all(10),
                      //           child: Row(
                      //             children: [
                      //               Text(
                      //                 date,
                      //                 style: const TextStyle(
                      //                     color: Colors.black, fontSize: 15),
                      //               ),
                      //               const Icon(Icons.keyboard_arrow_down,
                      //                   color: Colors.black87),
                      //             ],
                      //           ),
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      // DropdownButton(
                      //   value: dropdownvalue,
                      //   icon: const Icon(Icons.keyboard_arrow_down),
                      //   items: MONTH.map((String MONTH) {
                      //     return DropdownMenuItem(
                      //       value: MONTH,
                      //       child: Text(MONTH),
                      //     );
                      //   }).toList(),
                      //   onChanged: (String? newValue) {
                      //     setState(() {
                      //       dropdownvalue = newValue!;
                      //     });
                      //   },
                      // ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.black38),
                                  color: getColorFromHex("#FFFFFF")),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                        isDense: true,
                                        hint: Text('Month'),
                                        focusColor: Colors.white,
                                        value: _chosenVal,
                                        style: TextStyle(color: Colors.black),
                                        items: <String>[
                                          'All',
                                          'Date',
                                        ].map<DropdownMenuItem<String>>(
                                            (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (String? value) {
                                          setState(() {
                                            _chosenVal = value;
                                          });
                                          if (_chosenVal == 'All') {
                                            setState(() {
                                              //_runFilter3(date);

                                              getTransactionHistory();
                                            });
                                          } else if (_chosenVal == 'Date') {
                                            setState(() async {
                                              DateTime selectedDate =
                                                  DateTime.now();
                                              final DateTime? picked =
                                                  await showDatePicker(
                                                builder: ((context, child) {
                                                  return Theme(
                                                      data: Theme.of(context)
                                                          .copyWith(
                                                        colorScheme:
                                                            const ColorScheme
                                                                .light(
                                                          primary: Color(
                                                              0XFF286953), // header background color
                                                          onPrimary: Colors
                                                              .black45, // header text color
                                                          onSurface: Colors
                                                              .black, // body text color
                                                        ),
                                                        textButtonTheme:
                                                            TextButtonThemeData(
                                                          style: TextButton
                                                              .styleFrom(
                                                            primary: const Color(
                                                                0XFF286953), // button text color
                                                          ),
                                                        ),
                                                      ),
                                                      child: child!);
                                                }),
                                                context: context,
                                                firstDate: DateTime(2015, 8),
                                                lastDate: DateTime(2101),
                                                initialDate: selectedDate,
                                              );
                                              if (picked != null) {
                                                date = picked.year.toString() +
                                                    "-" +
                                                    picked.month.toString() +
                                                    "-" +
                                                    picked.day.toString();

                                                _runFilter3(date);
                                              } else {
                                                selectedDate;
                                              }
                                            });
                                          }
                                        })

                                    // onChanged: (String? newValue3) {
                                    //   setState(() {
                                    //     //_runFilter3(date);

                                    //     _runFilter3(newValue3.toString());
                                    //   });
                                    // },

                                    //onChanged: (value) {
                                    ),
                              ),
                            ),
                          ),
                          Container(
                            // width: MediaQuery.of(context).size.width * 0.90,
                            //   buttonWidth: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black38),
                                color: getColorFromHex("#FFFFFF")),

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  isDense: true,

                                  // isExpanded: true,
                                  value: dropdownvalue2,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black54,
                                  ),
                                  items: Filter.map((String B) {
                                    return DropdownMenuItem(
                                      value: B,
                                      child: Text(B,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15)),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue2) {
                                    setState(() {
                                      _runFilter(newValue2.toString());
                                    });
                                  },

                                  //onChanged: (value) {
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // DropdownButton(
                      //   value: dropdownvalue2,
                      //   icon: const Icon(Icons.keyboard_arrow_down),
                      //   items: Filter.map((String A) {
                      //     return DropdownMenuItem(
                      //       value: A,
                      //       child: Text(A),
                      //     );
                      //   }).toList(),
                      //   onChanged: (String? newValue) {
                      //     setState(() {
                      //       dropdownvalue2 = newValue!;
                      //     });
                      //   },
                      // ),

                      // Row(
                      //   children: [
                      //     InkWell(
                      //         onTap: () async {
                      //           DropdownButton(
                      //             value: dropdownvalue2,
                      //             icon: const Icon(Icons.keyboard_arrow_down),
                      //             items: Filter.map((String F) {
                      //               return DropdownMenuItem(
                      //                 value: F,
                      //                 child: Text(F),
                      //               );
                      //             }).toList(),
                      //             onChanged: (String? UpdateFilter) {
                      //               setState(() {
                      //                 dropdownvalue2 = UpdateFilter!;
                      //               });
                      //             },
                      //           );
                      //         },
                      //         child: Container(
                      //             // child: Text(
                      //             //   Filter.toString(),
                      //             //   style: const TextStyle(
                      //             //       color: Colors.black, fontSize: 15),
                      //             // ),
                      //             // decoration: BoxDecoration(
                      //             //     borderRadius: BorderRadius.circular(10),
                      //             //     border: Border.all(color: Colors.black),
                      //             //     color: getColorFromHex("#FFFFFF")),
                      //             // padding: const EdgeInsets.all(10),
                      //             ))
                      //   ],
                      // ),
                    ],
                  )
                ],
              ),
            ),
            !_isLoading
                ? Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(5),
                        itemCount: _searchList.length,
                        itemBuilder: (context, index) => Gethistory(index)),
                  )
                : Center(
                    child: getProgressBar(),
                  ),
          ],
        ),
      ),
    );
  }

  Gethistory(int index) {
    return Column(
      children: [
        ListTile(
          leading: Container(
              child: Column(
            children: [
              if (_searchList[index].transactionType == "Money Add to Wallet" &&
                  _searchList[index].transactionStatus == "Success") ...[
                Container(
                  child: Image.asset(
                    "images/moey_added.png",
                    width: 30,
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                )
              ] else if (_searchList[index].transactionType ==
                      "Money Add to Wallet" &&
                  _searchList[index].transactionStatus == "Failed") ...[
                Container(
                  child: Image.asset(
                    "images/failed.png",
                    width: 40,
                    height: 30,
                  ),
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                )
              ] else ...[
                Container(
                  child: Image.asset(
                    "images/sent_arrow.png",
                    width: 30,
                    height: 30,
                  ),
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                )
              ]
            ],
          )),
          title: Align(
            child: Text(_searchList[index].transactionType!.toString()),
            alignment: Alignment.topLeft,
          ),
          subtitle: Align(
            child: Text(_searchList[index].date.toString()),
            alignment: Alignment.topLeft,
          ),
          trailing: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Text("₹" + _searchList[index].amount.toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w400)),
              const SizedBox(
                height: 5,
              ),
              const Text("Online",
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: Color(0xffAAAAAA)))
            ],
          ),
        ),
        const Divider(
          indent: 10,
          endIndent: 10,
          height: 1,
          color: Colors.grey,
        )
      ],
    );
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
      print("==> Add Favourite SUCCESS=>" + json['messaage'].toString());
    }, onError: (error) {
      print("==> Add Favourite ERROR=>" + error.toString());
    });
  }

  void removeFavourite(String productId) async {
    String userId = "";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getString("id").toString();
    var api = APICallRepository();
    api.removeFavourite(userId, productId).then((value) {
      var json = jsonDecode(value);
      print("==> REMOVE Favourite SUCCESS=>" + json['messaage'].toString());
    }, onError: (error) {
      print("==> REMOVE Favourite ERROR=>" + error.toString());
    });
  }
}
