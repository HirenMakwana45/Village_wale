import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village.wale/EditProfileScreen.dart';
import 'package:village.wale/Map.dart';
import 'package:village.wale/Map2.dart';
import 'package:village.wale/Model/ProfileModel.dart';
import 'package:village.wale/persistance/api_repository.dart';
import 'package:village.wale/util/AppUtil.dart';
import 'package:village.wale/util/util.dart';

import 'HomeScreen.dart';
import 'Notification.dart';
import 'Wallet.dart';

class My_Profile extends StatefulWidget {
  const My_Profile({Key? key}) : super(key: key);

  @override
  State<My_Profile> createState() => _My_ProfileState();
}

class _My_ProfileState extends State<My_Profile> {
  String? _id;
  bool _isLoading = true;
  ProfileModel? _model;
  String? Add_Second_Address;
  final nameController = TextEditingController();
  final address1 = TextEditingController();
  final address2 = TextEditingController();
  final getStorage = GetStorage();

  @override
  void initState() {
    print("===GET PROFILE INIT STATE==>");
    getId();
    getProfile();
    Add_Second_Address = getStorage.read('Sec_Address');
    print("My Second Address Is " + Add_Second_Address.toString());

    super.initState();
  }

  void getId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _id = sharedPreferences.getString('id');
  }

  @override
  Widget build(BuildContext context) {
    // return ScreenUtilInit(
    //   designSize: const Size(414, 896),
    //   builder: (BuildContext context, Widget? child){
    //     return  MaterialApp(
    //       debugShowCheckedModeBanner: false,
    //       home: Scaffold(
    //         bottomNavigationBar: Container(
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.only(
    //                 topRight: Radius.circular(30), topLeft: Radius.circular(30)),
    //             boxShadow: [
    //               BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
    //             ],
    //           ),
    //           child: ClipRRect(
    //             borderRadius: BorderRadius.only(
    //               topLeft: Radius.circular(30.0),
    //               topRight: Radius.circular(30.0),
    //             ),
    //             child: BottomNavigationBar(
    //               currentIndex: 3,
    //               elevation: 40,
    //               type: BottomNavigationBarType.fixed,
    //               selectedItemColor: Color(0XFF286953),
    //               unselectedItemColor: Colors.grey,
    //               selectedFontSize: 0,
    //               unselectedFontSize: 0,
    //               onTap: (value) {
    //                 if (value == 0) {Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyHomeScreen()));}
    //                 if (value == 1) {Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Wallet()));}
    //                 if (value == 2) {Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Notifications()));}
    //                 if (value == 3) {}
    //               },
    //               items: [
    //                 BottomNavigationBarItem(
    //                   backgroundColor: Colors.black,
    //                   icon: Icon(
    //                     Icons.home_outlined,
    //                   ),
    //                   label: "",
    //                 ),
    //                 BottomNavigationBarItem(
    //                   icon: Icon(Icons.account_balance_wallet_outlined,
    //                   ),
    //                   label: "",
    //                 ),
    //                 BottomNavigationBarItem(
    //                   icon:
    //                   Icon(Icons.notifications_none_outlined, ),
    //                   label: "",
    //                 ),
    //                 BottomNavigationBarItem(
    //                   icon: Icon(Icons.person_outline, ),
    //                   label: "",
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //         drawer: Drawer(
    //           child: Column(
    //             children: [
    //               MyHeaderDrawer(),
    //               Container(height: 1,width: double.infinity,color: Colors.black12,),
    //               MyDrawerList()
    //             ],
    //           ),
    //         ),
    //         backgroundColor: Color(0xffF5F5F5),
    //         body: !_isLoading?Container(
    //           margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
    //           width: double.infinity,
    //           child: Column(
    //             children: [
    //               SizedBox(height: 50,),
    //               Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Text('My Profile',style: TextStyle(fontSize: 20),),
    //                   Column(
    //                     children: [
    //                       Row(
    //                         children: [
    //                           Icon(Icons.mode_edit_outline_outlined,color: Colors.green,),
    //                           SizedBox(width: 10,),
    //                           Text('Edit',style: TextStyle(fontSize: 16,color: Colors.green),),
    //                         ],
    //                       ),
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //               SizedBox(height: 32.06,),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: [
    //                   Container(
    //                     width: 100.0,
    //                     height: 100.0,
    //                     decoration: BoxDecoration(
    //                         shape: BoxShape.circle,
    //                         border:
    //                         Border.all(width: 2)),
    //                     child: ClipOval(
    //                       child: Image.network(
    //                         _model!.image==""?"https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png":_model!.image!,
    //                         fit: BoxFit.cover,),
    //                       //   child:  _image != null
    //                       //       ? Image.file(File(_image!.path), fit: BoxFit.fill,)
    //                       //       : Image.network(image_url , fit: BoxFit.fill , scale: 1.0) ,
    //                     ),
    //                   ),
    //                   // Center(child: Image.network(_model!.image==""?"https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png":_model!.image!,scale: 0.7,height: 20,width: 20,)),
    //                 ],
    //               ),
    //               SizedBox(height: 10,),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: [
    //                   Text(_model!.name.toString(),style: TextStyle(fontSize: 16),)
    //                 ],
    //               ),
    //               SizedBox(height: 21.38,),
    //               Container(
    //
    //                 child:Container(
    //                   decoration: ShapeDecoration(
    //                       shape: RoundedRectangleBorder (
    //                           borderRadius: BorderRadius.circular(10.0),
    //                           side: const BorderSide(
    //                               width: 1,
    //                               color: Colors.transparent
    //                           )
    //                       )
    //                   ),
    //
    //                   child: Card(
    //                     child: Column(
    //                       children: [
    //                         SizedBox(height: 10.h,),
    //                         Row(
    //                           children: [
    //                             SizedBox(width: 14.w,),
    //                             Text('Email',style: TextStyle(color: Color(0xff9D9FA1)),)
    //                           ],
    //                         ),
    //                         SizedBox(height: 5.h,),
    //                         Row(
    //                           children: [
    //                             SizedBox(width: 14.w,),
    //                             Text(_model!.gmail.toString(),style: TextStyle(fontSize: 16),)
    //                           ],
    //                         ),
    //                         Padding(
    //                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
    //                           child: Divider(thickness: 1,),
    //                         ),
    //                         Row(
    //                           children: [
    //                             SizedBox(width: 14.w,),
    //                             Text('Number',style: TextStyle(color: Color(0xff9D9FA1),))
    //                           ],
    //                         ),
    //                         SizedBox(height: 5.h),
    //                         Row(
    //                           children: [
    //                             SizedBox(width: 14.w,),
    //                             Text(_model!.mobileNo.toString(),style: TextStyle(fontSize: 16),)
    //                           ],
    //                         ),
    //                         SizedBox(height: 5.h),
    //
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               SizedBox(height: 10.h,),
    //               Container(
    //                 child: Container(
    //                   decoration: ShapeDecoration(
    //                       shape: RoundedRectangleBorder (
    //                           borderRadius: BorderRadius.circular(10.0),
    //                           side: const BorderSide(
    //                               width: 1,
    //                               color: Colors.transparent
    //                           )
    //                       )
    //                   ),
    //
    //                   child: Card(
    //                     child: Column(
    //                       children: [
    //                         SizedBox(height: 11.h,),
    //                         Row(
    //                           children: [
    //                             SizedBox(width: 14.w,),
    //                             Text('Address-1',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),)
    //                           ],
    //                         ),
    //                         SizedBox(height: 14.h,),
    //                         Row(
    //                           children: [
    //                             SizedBox(width: 14.w,),
    //                             Icon(Icons.location_on_outlined),
    //                             SizedBox(width: 11.w,),
    //                             Text(_model!.address.toString(),style: TextStyle(fontSize: 16),)
    //                           ],
    //                         ),
    //                         SizedBox(height: 2.h,),
    //                         Row(
    //                           children: [
    //                             SizedBox(width: 45.w,),
    //                             Text('B3-205 Nano City, behind shalimar township',style: TextStyle(color: Color(0xff9D9FA1)),)
    //                           ],
    //                         ),
    //                         SizedBox(height: 14.h),
    //
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //
    //               ),
    //               SizedBox(height: 10.h,),
    //               Container(
    //                 child: Container(
    //                   decoration: ShapeDecoration(
    //                       shape: RoundedRectangleBorder (
    //                           borderRadius: BorderRadius.circular(12.0),
    //                           side: const BorderSide(
    //                               width: 1,
    //                               color: Colors.transparent
    //                           )
    //                       )
    //                   ),
    //
    //                   child: Card(
    //                     child: Column(
    //                       children: [
    //                         Row(
    //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                           children: [
    //                             Row(
    //                               children: [
    //                                 SizedBox(width: 15.w,),
    //                                 Text('Address-2',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
    //                               ],
    //                             ),
    //                             Row(
    //                               children: [
    //                                 TextButton(child: Text('+ Add more',style: TextStyle(color: Color(0XFF286953))), onPressed: () {  },),
    //                                 SizedBox(width: 10.w,),
    //                               ],
    //                             )
    //                           ],
    //                         ),
    //                         SizedBox(height: 14.h,),
    //                         Row(
    //                           children: [
    //                             SizedBox(width: 14.w,),
    //                             Icon(Icons.location_on_outlined),
    //                             SizedBox(width: 11.w,),
    //                             Text('Scheme 114 Vijay nagar, indore',style: TextStyle(fontSize: 16),)
    //                           ],
    //                         ),
    //                         SizedBox(height: 2.h,),
    //                         Row(
    //                           children: [
    //                             SizedBox(width: 46.w,),
    //                             Text('B3-205 Nano City, behind shalimar township',style: TextStyle(color: Color(0xff9D9FA1)),)
    //                           ],
    //                         ),
    //                         SizedBox(height: 14.h,),
    //
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ):Center(child: getProgressBar(),),
    //       ),
    //     );
    //   }
    // );

    return Scaffold(
      body: Builder(builder: (context) {
        return _isLoading
            ? Center(
                child: getProgressBar(),
              )
            : LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) =>
                    MaterialApp(
                        debugShowCheckedModeBanner: false,
                        home: _isLoading
                            ? Center(
                                child: getProgressBar(),
                              )
                            : Scaffold(
                                bottomNavigationBar: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(30),
                                        topLeft: Radius.circular(30)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black38,
                                          spreadRadius: 0,
                                          blurRadius: 10),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0),
                                    ),
                                    child: BottomNavigationBar(
                                      currentIndex: 3,
                                      elevation: 40,
                                      type: BottomNavigationBarType.fixed,
                                      selectedItemColor:
                                          const Color(0XFF286953),
                                      unselectedItemColor: Colors.grey,
                                      selectedFontSize: 0,
                                      unselectedFontSize: 0,
                                      onTap: (value) {
                                        if (value == 0) {
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  type: PageTransitionType.fade,
                                                  child: MyHomeScreen()));
                                          // Navigator.of(context).push(
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             const MyHomeScreen()));
                                        }
                                        if (value == 1) {
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  type: PageTransitionType.fade,
                                                  child: Wallet()));
                                          // Navigator.of(context).push(
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             const Wallet()));
                                        }
                                        if (value == 2) {
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  type: PageTransitionType.fade,
                                                  child: Notifications()));
                                          // Navigator.of(context).push(
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             const Notifications()));
                                        }
                                        if (value == 3) {}
                                      },
                                      items: const [
                                        BottomNavigationBarItem(
                                          backgroundColor: Colors.black,
                                          icon: Icon(
                                            Icons.home_outlined,
                                          ),
                                          label: "",
                                        ),
                                        BottomNavigationBarItem(
                                          icon: Icon(
                                            Icons
                                                .account_balance_wallet_outlined,
                                          ),
                                          label: "",
                                        ),
                                        BottomNavigationBarItem(
                                          icon: Icon(
                                            Icons.notifications_none_outlined,
                                          ),
                                          label: "",
                                        ),
                                        BottomNavigationBarItem(
                                          icon: Icon(
                                            Icons.person_outline,
                                          ),
                                          label: "",
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                drawer: Drawer(
                                  child: Column(
                                    children: [
                                      const MyHeaderDrawer(),
                                      Container(
                                        height: 1,
                                        width: double.infinity,
                                        color: Colors.black12,
                                      ),
                                      const MyDrawerList()
                                    ],
                                  ),
                                ),
                                backgroundColor: const Color(0xffF5F5F5),
                                body: !_isLoading
                                    ? Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            10, 0, 10, 0),
                                        width: double.infinity,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 50,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    'My Profile',
                                                    style: TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontSize: 20),
                                                  ),
                                                  Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              PageTransition(
                                                                  type:
                                                                      PageTransitionType
                                                                          .fade,
                                                                  child: EditProileScreen(
                                                                      _model!)));
                                                          // Navigator.of(context).push(
                                                          //     MaterialPageRoute(
                                                          //         builder: (context) =>
                                                          //             EditProileScreen(
                                                          //                 _model!)));
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .mode_edit_outline_outlined,
                                                              color:
                                                                  getColorFromHex(
                                                                      "#286953"),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text('Edit',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      "Poppins",
                                                                  fontSize: 16,
                                                                  color: getColorFromHex(
                                                                      "#286953"),
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 32.06,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 100.0,
                                                    height: 100.0,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            width: 2)),
                                                    child: ClipOval(
                                                      // child:FadeInImage(
                                                      //   // height: 45,
                                                      //   // width: 45,
                                                      //   image: NetworkImage(image),
                                                      //   fit: BoxFit.cover,
                                                      //   placeholder:NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSd7ouUaXq_gL4N44vL7zj-NcpCKQDJIoIQzM3FnHnZ5Q&s") ,
                                                      //
                                                      // ),
                                                      child: Image.network(
                                                        image.toString() ==
                                                                    "" ||
                                                                image.toString() ==
                                                                    "null"
                                                            ? noImage
                                                            : image,
                                                        height: 45,
                                                        width: 45,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      // child: Image.network(
                                                      //   _model!.image=="" && _model!.image==null?"https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png":_model!.image!,
                                                      //   fit: BoxFit.cover,),My
                                                      //   child:  _image != null
                                                      //       ? Image.file(File(_image!.path), fit: BoxFit.fill,)
                                                      //       : Image.network(image_url , fit: BoxFit.fill , scale: 1.0) ,
                                                    ),
                                                  ),
                                                  // Center(child: Image.network(_model!.image==""?"https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png":_model!.image!,scale: 0.7,height: 20,width: 20,)),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    _model!.name.toString(),
                                                    style: const TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontSize: 16),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 21.38,
                                              ),
                                              Container(
                                                child: Container(
                                                  decoration: ShapeDecoration(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          side: const BorderSide(
                                                              width: 1,
                                                              color: Colors
                                                                  .transparent))),
                                                  child: Card(
                                                    child: Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: const [
                                                            SizedBox(
                                                              width: 14,
                                                            ),
                                                            Text(
                                                              'Email',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Poppins",
                                                                  color: Color(
                                                                      0xff9D9FA1)),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const SizedBox(
                                                              width: 14,
                                                            ),
                                                            Text(
                                                              _model!.gmail
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontFamily:
                                                                      "Poppins",
                                                                  fontSize: 16),
                                                            )
                                                          ],
                                                        ),
                                                        const Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      8.0),
                                                          child: Divider(
                                                            thickness: 1,
                                                          ),
                                                        ),
                                                        Row(
                                                          children: const [
                                                            SizedBox(
                                                              width: 14,
                                                            ),
                                                            Text('Number',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      "Poppins",
                                                                  color: Color(
                                                                      0xff9D9FA1),
                                                                ))
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 5),
                                                        Row(
                                                          children: [
                                                            const SizedBox(
                                                              width: 14,
                                                            ),
                                                            Text(
                                                              _model!.mobileNo
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  fontFamily:
                                                                      "Poppins",
                                                                  fontSize: 16),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 5),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                child: Container(
                                                  decoration: ShapeDecoration(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          side: const BorderSide(
                                                              width: 1,
                                                              color: Colors
                                                                  .transparent))),
                                                  child: Card(
                                                    child: Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 11,
                                                        ),
                                                        Row(
                                                          children: const [
                                                            SizedBox(
                                                              width: 14,
                                                            ),
                                                            Text(
                                                              'Address-1',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Poppins",
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 14,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const SizedBox(
                                                              width: 14,
                                                            ),
                                                            const Icon(Icons
                                                                .location_on_outlined),
                                                            const SizedBox(
                                                              width: 11,
                                                            ),
                                                            SizedBox(
                                                              width: 260,
                                                              child: Text(
                                                                _model!.address
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        "Poppins",
                                                                    fontSize:
                                                                        16),
                                                                maxLines: 4,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 2,
                                                        ),
                                                        Visibility(
                                                          visible: false,
                                                          child: Row(
                                                            children: const [
                                                              SizedBox(
                                                                width: 45,
                                                              ),
                                                              Text(
                                                                'B3-205 Nano City, behind shalimar township',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Poppins",
                                                                    color: Color(
                                                                        0xff9D9FA1)),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 14),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  decoration: ShapeDecoration(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.0),
                                                          side: const BorderSide(
                                                              width: 1,
                                                              color: Colors
                                                                  .transparent))),
                                                  child: SingleChildScrollView(
                                                    child: Card(
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: const [
                                                                  SizedBox(
                                                                    width: 15,
                                                                  ),
                                                                  Text(
                                                                    'Address-2',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            "Poppins",
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  TextButton(
                                                                    child: const Text(
                                                                        '+ Add more',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                "Poppins",
                                                                            color:
                                                                                Color(0XFF286953))),
                                                                    onPressed:
                                                                        () {
                                                                      // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>EditProileScreen(_model!)));
                                                                      _bottomsheet(
                                                                          context);
                                                                    },
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 14,
                                                          ),
                                                          Row(
                                                            children: [
                                                              const SizedBox(
                                                                width: 14,
                                                              ),
                                                              const Icon(Icons
                                                                  .location_on_outlined),
                                                              const SizedBox(
                                                                width: 11,
                                                              ),
                                                              SizedBox(
                                                                width: 260,
                                                                child: Text(
                                                                  Add_Second_Address ==
                                                                              "null" ||
                                                                          address2.text.toString() ==
                                                                              ""
                                                                      ? "No Address found"
                                                                      : address2
                                                                          .text
                                                                          .toString(),
                                                                  maxLines: 4,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontFamily:
                                                                        "Poppins",
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                            height: 2,
                                                          ),
                                                          Visibility(
                                                            visible: false,
                                                            child: Row(
                                                              children: const [
                                                                SizedBox(
                                                                  width: 46,
                                                                ),
                                                                Text(
                                                                  'B3-205 Nano City, behind shalimar township',
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          "Poppins",
                                                                      color: Color(
                                                                          0xff9D9FA1)),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 14,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: getProgressBar(),
                                      ),
                              )),
              );
      }),
    );
  }

  void _bottomsheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            height: 320,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Address',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    height: 1,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: getColorFromHex("#EFF1F4"),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: Set_delivery_locaton()));
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) =>
                        //         const Set_delivery_locaton()));
                      },
                      child: TextField(
                        enableInteractiveSelection: false,
                        enabled: false,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(
                            fontFamily: "Poppins", color: Colors.black),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Address 1',
                        ),
                        controller: address1,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: getColorFromHex("#EFF1F4"),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
                    child: GestureDetector(
                      onTap: (() {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: Address2()));
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => const Address2()));
                      }),
                      child: TextField(
                        enableInteractiveSelection: false,
                        enabled: false,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(
                            fontFamily: "Poppins", color: Colors.black),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Address 2',
                        ),
                        controller: address2,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ButtonTheme(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    // buttonColor: const Color(0XFF286953),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0XFF286953),
                      ),
                      onPressed: () {
                        // callApi();
                      },
                      //textColor: Colors.white,
                      child: const Center(
                        child: Text(
                          "Save Address",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void getProfile() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _id = sharedPreferences.getString('id');
    print("===>API CALL=>" + sharedPreferences.getString('id').toString());
    setState(() {
      _isLoading = true;
    });
    var api = APICallRepository();
    if (_id != null) {
      api.getProfile(_id!).then((value) {
        setState(() {
          var model = ProfileModel.fromJson(jsonDecode(value));
          _model = model;

          address1.text = _model!.address!.toString();
          address2.text = _model!.address2.toString() == "null" ||
                  _model!.address2.toString() == ""
              ? "No Address Found"
              : _model!.address2.toString();

          _isLoading = false;
        });
      }, onError: (error) {
        setState(() {
          _isLoading = false;
          showCustomToast("Something Went Wrong..");
        });
      });
    }
  }
}

class MyDrawerList extends StatefulWidget {
  const MyDrawerList({Key? key}) : super(key: key);

  @override
  State<MyDrawerList> createState() => _MyDrawerListState();
}

class _MyDrawerListState extends State<MyDrawerList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade, child: My_Profile()));
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => const My_Profile(),
                // ));
              },
              child: Row(children: const [
                Expanded(
                    child: Icon(
                  Icons.person,
                  size: 20,
                  color: Colors.black,
                )),
                Expanded(
                    flex: 3,
                    child: Text(
                      'My account',
                      style: TextStyle(fontFamily: "Poppins", fontSize: 16),
                    )),
                Expanded(
                    child: Icon(
                  Icons.navigate_next,
                  size: 20,
                  color: Colors.black,
                )),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: GestureDetector(
              onTap: () {
                //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>My_Profile(),));
              },
              child: Row(children: const [
                Expanded(
                    child: Icon(
                  Icons.category_outlined,
                  size: 20,
                  color: Colors.black,
                )),
                Expanded(
                    flex: 3,
                    child: Text(
                      'Shop by category',
                      style: TextStyle(fontFamily: "Poppins", fontSize: 16),
                    )),
                Expanded(
                    child: Icon(
                  Icons.navigate_next,
                  size: 20,
                  color: Colors.black,
                )),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: GestureDetector(
              onTap: () {
                //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>My_Profile(),));
              },
              child: Row(children: const [
                Expanded(
                    child: Icon(
                  Icons.subscriptions_outlined,
                  size: 20,
                  color: Colors.black,
                )),
                Expanded(
                    flex: 3,
                    child: Text(
                      'My subscriptions',
                      style: TextStyle(fontFamily: "Poppins", fontSize: 16),
                    )),
                Expanded(
                    child: Icon(
                  Icons.navigate_next,
                  size: 20,
                  color: Colors.black,
                )),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: GestureDetector(
              onTap: () {
                //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>My_Profile(),));
              },
              child: Row(children: const [
                Expanded(
                    child: Icon(
                  Icons.wallet_giftcard_outlined,
                  size: 20,
                  color: Colors.black,
                )),
                Expanded(
                    flex: 3,
                    child: Text(
                      'Refer & earn',
                      style: TextStyle(fontFamily: "Poppins", fontSize: 16),
                    )),
                Expanded(
                    child: Icon(
                  Icons.navigate_next,
                  size: 20,
                  color: Colors.black,
                )),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: GestureDetector(
              onTap: () {
                // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>My_Profile(),));
              },
              child: Row(children: const [
                Expanded(
                    child: Icon(
                  Icons.history,
                  size: 20,
                  color: Colors.black,
                )),
                Expanded(
                    flex: 3,
                    child: Text(
                      'Transaction history',
                      style: TextStyle(fontFamily: "Poppins", fontSize: 16),
                    )),
                Expanded(
                    child: Icon(
                  Icons.navigate_next,
                  size: 20,
                  color: Colors.black,
                )),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: GestureDetector(
              onTap: () {
                //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>My_Profile(),));
              },
              child: Row(children: const [
                Expanded(
                    child: Icon(
                  Icons.view_list_outlined,
                  size: 20,
                  color: Colors.black,
                )),
                Expanded(
                    flex: 3,
                    child: Text(
                      'My Order',
                      style: TextStyle(fontFamily: "Poppins", fontSize: 16),
                    )),
                Expanded(
                    child: Icon(
                  Icons.navigate_next,
                  size: 20,
                  color: Colors.black,
                )),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: GestureDetector(
              onTap: () {},
              child: Row(children: const [
                Expanded(
                    child: Icon(
                  Icons.local_offer_outlined,
                  size: 20,
                  color: Colors.black,
                )),
                Expanded(
                    flex: 3,
                    child: Text(
                      'Offers',
                      style: TextStyle(fontFamily: "Poppins", fontSize: 16),
                    )),
                Expanded(
                    child: Icon(
                  Icons.navigate_next,
                  size: 20,
                  color: Colors.black,
                )),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: GestureDetector(
              onTap: () {
                //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>My_Profile(),));
              },
              child: Row(children: const [
                Expanded(
                    child: Icon(
                  Icons.headset_mic_outlined,
                  size: 20,
                  color: Colors.black,
                )),
                Expanded(
                    flex: 3,
                    child: Text(
                      'Support',
                      style: TextStyle(fontFamily: "Poppins", fontSize: 16),
                    )),
                Expanded(
                    child: Icon(
                  Icons.navigate_next,
                  size: 20,
                  color: Colors.black,
                )),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class MyHeaderDrawer extends StatefulWidget {
  const MyHeaderDrawer({Key? key}) : super(key: key);

  @override
  State<MyHeaderDrawer> createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: const Color(0xffFFFFFF),
            width: double.infinity,
            padding: const EdgeInsets.only(top: 20),
            child: Column(children: [
              const SizedBox(
                height: 35,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 15,
                  ),
                  Image.asset('images/Logo5.png'),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
              Row(children: [
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              child: My_Profile()));
                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (context) => const My_Profile(),
                      // ));
                    },
                    child: Container(
                      width: 304,
                      height: 90,
                      decoration: ShapeDecoration(
                          color: const Color(0xffFFFFFF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: const BorderSide(
                                  width: 1, color: Colors.transparent))),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 87,
                                width: 301.3,
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Image.asset('images/Face.png'),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          height: 18,
                                        ),
                                        Row(
                                          children: const [
                                            Text(
                                              'John Doe',
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(
                                              width: 90,
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: const [
                                            SizedBox(
                                              width: 7,
                                            ),
                                            Text('john_doe265@gmail.com',
                                                style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                ))
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ))
              ]),
            ]),
          ),
        ],
      ),
    );
  }
}
