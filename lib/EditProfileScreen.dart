import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:ui' as voidCallBack;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:village.wale/HomeScreen.dart';
import 'package:village.wale/Map.dart';
import 'package:village.wale/Model/ProfileModel.dart';
import 'package:village.wale/persistance/api_repository.dart';
import 'package:village.wale/util/AppUtil.dart';
import 'package:village.wale/util/util.dart';

import 'MyProfile.dart';

class EditProileScreen extends StatefulWidget {
  ProfileModel _model;

  EditProileScreen(this._model);

  @override
  _EditProfileScreen createState() => _EditProfileScreen();
}

class _EditProfileScreen extends State<EditProileScreen> {
  XFile? _image;

  String image_url = "https://www.w3schools.com/howto/img_avatar.png";

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final address1 = TextEditingController();
  final address2 = TextEditingController();
  bool _isLoading = false;

  bool _isAddressOneUpdate = false;
  bool _isaddresstwoupdate = false;
  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: getColorFromHex("#286953"),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Text(
                  'Edit Profile',
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 20,
                      color: getColorFromHex("#286953")),
                ),
              ],
            ),
            Center(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: InkWell(
                  onTap: () {
                    voidCallBack.VoidCallback firstCallback =
                        () => {Navigator.of(context).pop(), getImage(true)};

                    voidCallBack.VoidCallback secondCallback =
                        () => {Navigator.of(context).pop(), getImage(false)};
                    showDialogCustom(context, "Select Image", "", firstCallback,
                        secondCallback, "Camera", "Gallery", true, true);
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    child: Stack(
                      children: [
                        Container(
                          width: 100.0,
                          height: 100.0,
                          padding: const EdgeInsets.all(1),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black38,
                                  spreadRadius: 0,
                                  blurRadius: 1),
                            ],
                          ),
                          child: ClipOval(
                            child: _image != null
                                ? Image.file(
                                    File(_image!.path),
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    widget._model.image!.isNotEmpty
                                        ? widget._model.image!
                                        : "https://media.istockphoto.com/photos/businessman-silhouette-as-avatar-or-default-profile-picture-picture-id476085198?b=1&k=20&m=476085198&s=170667a&w=0&h=Ct4e1kIOdCOrEgvsQg4A1qeuQv944pPFORUQcaGw4oI=",
                                    fit: BoxFit.fill,
                                    scale: 1.0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                              width: 25.0,
                              height: 25.0,
                              padding: const EdgeInsets.all(0),
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  const BoxShadow(
                                      color: Colors.black38,
                                      spreadRadius: 0,
                                      blurRadius: 10),
                                ],
                              ),
                              child: Container(
                                child: Image.asset(
                                  'images/camera_icon.png',
                                  height: 18,
                                  fit: BoxFit.fitHeight,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Text("Name",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      color: getColorFromHex("#286953"),
                      fontSize: 17)),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: getColorFromHex("#286953"))),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: getColorFromHex("#286953"))),
                    hintText: "Name",
                    hintStyle: const TextStyle(
                        fontFamily: "Poppins", color: Colors.black)),
                style: const TextStyle(
                    fontFamily: "Poppins", color: Colors.black, fontSize: 17),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Text("Email",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      color: getColorFromHex("#286953"),
                      fontSize: 17)),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: getColorFromHex("#286953"))),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: getColorFromHex("#286953"))),
                    hintText: "Email",
                    hintStyle: const TextStyle(
                        fontFamily: "Poppins", color: Colors.black)),
                style: const TextStyle(
                    fontFamily: "Poppins", color: Colors.black, fontSize: 17),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Text("Mobile",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      color: getColorFromHex("#286953"),
                      fontSize: 17)),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: TextField(
                controller: mobileController,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: getColorFromHex("#286953"))),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: getColorFromHex("#286953"))),
                    hintText: "Mobile",
                    hintStyle: const TextStyle(color: Colors.black)),
                style: const TextStyle(color: Colors.black, fontSize: 17),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            // Container(
            //   margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            //   child: Text("Address-1",
            //       style: TextStyle(
            //           color: getColorFromHex("#286953"), fontSize: 17)),
            // ),
            // Container(
            //   margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            //   child: GestureDetector(
            //     onTap: () {
            //       Navigator.of(context).push(MaterialPageRoute(
            //           builder: (context) => Set_delivery_locaton()));
            //     },
            //     child: TextField(
            //       enableInteractiveSelection: false,
            //       enabled: false,
            //       onChanged: (value) {
            //         setState(() {
            //           _isAddressOneUpdate = true;
            //         });
            //       },
            //       controller: address1,
            //       decoration: InputDecoration(
            //           focusedBorder: UnderlineInputBorder(
            //               borderSide:
            //                   BorderSide(color: getColorFromHex("#286953"))),
            //           enabledBorder: UnderlineInputBorder(
            //               borderSide:
            //                   BorderSide(color: getColorFromHex("#286953"))),
            //           hintText: "Address-1",
            //           hintStyle: const TextStyle(color: Colors.black)),
            //       style: const TextStyle(color: Colors.black, fontSize: 17),
            //     ),
            //   ),
            // ),
            // const SizedBox(
            //   height: 30,
            // ),
            // Container(
            //   margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            //   child: Text("Address-2",
            //       style: TextStyle(
            //           color: getColorFromHex("#286953"), fontSize: 17)),
            // ),
            // Container(
            //   margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            //   child: TextField(
            //     // will disable paste operation

            //     onChanged: (value) {
            //       setState(() {
            //         _isaddresstwoupdate = true;
            //       });
            //     },
            //     controller: address2,
            //     decoration: InputDecoration(
            //         focusedBorder: UnderlineInputBorder(
            //             borderSide:
            //                 BorderSide(color: getColorFromHex("#286953"))),
            //         enabledBorder: UnderlineInputBorder(
            //             borderSide:
            //                 BorderSide(color: getColorFromHex("#286953"))),
            //         hintText: "Address-2",
            //         hintStyle: const TextStyle(color: Colors.black)),
            //     style: const TextStyle(color: Colors.black, fontSize: 17),
            //   ),
            // ),

            const SizedBox(
              height: 30,
            ),
            !_isLoading
                ? InkWell(
                    onTap: () {
                      callApi();

                      if (_isAddressOneUpdate) {
                        updateAddressOne();
                      }

                      if (_isaddresstwoupdate) {
                        addSecondAddress();
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      decoration: BoxDecoration(
                        color: getColorFromHex("#286953"),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(15),
                      child: const Text(
                        "Update",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  )
                : Center(
                    child: getProgressBar(),
                  )
          ],
        ),
      )),
    );
  }

  void callApi() async {
    setState(() {
      _isLoading = true;
    });
    String id = "";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    id = sharedPreferences.getString("id").toString();
    var api = APICallRepository();
    api
        .editProfile(id, nameController.text, mobileController.text,
            emailController.text, _image == null ? "" : _image!.path)
        .then((value) {
      setState(() {
        var json = jsonDecode(value);
        String message = json["message"];
        showCustomToast(message.toString());

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const My_Profile()),
            (route) => false);
      });
    }, onError: (error) {
      showCustomToast("Something Went Wrong");
    });
  }

  void setData() {
    setState(() {
      mobileController.text = widget._model.mobileNo.toString();
      nameController.text = widget._model.name.toString();
      emailController.text = widget._model.gmail.toString();
      address1.text = widget._model.address.toString();
      address2.text = widget._model.address2.toString();
    });
  }

  Future getImage(bool isFromCamera) async {
    XFile? image;
    final ImagePicker _picker = ImagePicker();
    if (isFromCamera)
      image = await _picker.pickImage(source: ImageSource.camera);
    else
      image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null && image.path != null) {
      print("======>IMAGE CHOOSE PERSONAL IMAGE" + image.path);
      if (image != null) {
        setState(() {
          _image = image;
        });
      }
    }
  }

  void updateAddressOne() async {
    String id = "";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    id = sharedPreferences.getString("id").toString();

    var api = APICallRepository();
    api.updateAddress(address1.text.toString(), id).then((value) {
      var json = jsonDecode(value);
      String message = json["message"];
      print("=====>SUCCESS==> UPDATE ADDRESS=>" + message);
    }, onError: (error) {
      print("=====>ERROR==> UPDATE ADDRESS=>" + error);
    });
  }

  void addSecondAddress() async {
    String id = "";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    id = sharedPreferences.getString("id").toString();

    var api = APICallRepository();
    api.addSecondAddress(address2.text.toString(), id).then((value) {
      var json = jsonDecode(value);
      String message = json["message"];
      print("=====>SUCCESS==> UPDATE ADDRESS=>" + message);
    }, onError: (error) {
      print("=====>ERROR==> UPDATE ADDRESS=>" + error);
    });
  }
}
