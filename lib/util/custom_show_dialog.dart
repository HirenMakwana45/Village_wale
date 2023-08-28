import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:village.wale/util/util.dart';

class ShowCustomDialog extends StatelessWidget {
  String title;
  String content;
  String firstLable;
  String secondLable;
  VoidCallback firstCallBack;
  VoidCallback secondCallBack;
  bool firstBtnVisible = false;

  ShowCustomDialog(
      this.title,
      this.content,
      this.firstCallBack,
      this.secondCallBack,
      this.firstLable,
      this.secondLable,
      this.firstBtnVisible);

  TextStyle textStyle = const TextStyle(color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: getTextWidgetWithAlign(
          title, 18, Colors.black, FontWeight.bold, TextAlign.start),
      content: getTextWidgetWithAlign(
          content, 14, Colors.black, FontWeight.normal, TextAlign.start),
      actions: <Widget>[
        Visibility(
          visible: firstBtnVisible,
          child: TextButton(
            child: getTextWidget(firstLable, 18, Colors.green, FontWeight.bold),
            onPressed: () {
              firstCallBack();
            },
          ),
        ),
        TextButton(
          child: getTextWidget(secondLable, 18, Colors.green, FontWeight.bold),
          onPressed: () {
            secondCallBack();
          },
        ),
      ],
    );
  }
}
