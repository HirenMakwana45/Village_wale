import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

showCustomToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.SNACKBAR,
    backgroundColor: Colors.green,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

var greencolor = const Color(0XFF286953);
CircularProgressIndicator getProgressBar() {
  return CircularProgressIndicator(
    color: greencolor,
  );
}

getCustomProgressBar() {
  var greencolor = const Color(0XFF286953);
  Center(
    child: CircularProgressIndicator(
      backgroundColor: greencolor,
    ),
  );
}
