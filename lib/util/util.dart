import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_show_dialog.dart';

String noImage="https://www.lexiconn.in/wp-content/themes/ryse/assets/images/no-image/No-Image-Found-400x264.png";

TextStyle style = TextStyle( fontSize: 14.0);

Text getTextWidgetWithAlign(String text, double fontSize, Color fontColor,
    FontWeight weight, TextAlign textAlign) {
  return Text(
    text,
    textAlign: textAlign,
    style: style.copyWith(
      fontSize: fontSize,
      color: fontColor,
      fontWeight: weight,

    ),
  );
}

Text getTextWidget(
    String text, double fontSize, Color fontColor, FontWeight weight) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: style.copyWith(

        fontSize: fontSize,
        color: fontColor,
        fontWeight: weight
    ),
  );
}

showDialogCustom(
    BuildContext context,
    String title,
    String content,
    VoidCallback firstCallBack,
    VoidCallback secondCallBack,
    String firstLable,
    String secondLable,
    bool isFirstBtnVisible,
    bool isOutSideClick) {
  ShowCustomDialog alert = ShowCustomDialog(title, content, firstCallBack,
      secondCallBack, firstLable, secondLable, isFirstBtnVisible);
  // isOutSideClick  : true - Click out pop close / false - Click out side popup don't close.
  showDialog(
    context: context,
    barrierDismissible: isOutSideClick,
    builder: (BuildContext context) {

      return alert;
    },
  );
}
