import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CostumButton {
  static Widget squareButton(String text,
      {Color borderColor = Colors.blueAccent,
      IconData prefixIcon = Icons.info,
      Function onTap}) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        width: 300,
        height: 70,
        decoration: BoxDecoration(
            border: Border.all(
          width: 4,
          color: borderColor,
        )),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                prefixIcon,
                size: 40,
                color: borderColor,
              ),
              SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  static Widget squareButtonSmall(String text,
      {Color borderColor = Colors.blueAccent,
      IconData prefixIcon = Icons.info,
      Function onTap}) {
    return GestureDetector(
      child: ScreenTypeLayout(
        tablet: Container(
          alignment: Alignment.center,
          width: 180,
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(
            width: 2,
            color: borderColor,
          )),
          child: _buttonContent(prefixIcon, borderColor, text),
        ),
        mobile: Container(
          alignment: Alignment.center,
          width: 150,
          height: 50,
          decoration: BoxDecoration(
              border: Border.all(
            width: 2,
            color: borderColor,
          )),
          child: _buttonContent(prefixIcon, borderColor, text),
        ),
      ),
      onTap: onTap,
    );
  }

  static Padding _buttonContent(
      IconData prefixIcon, Color borderColor, String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            prefixIcon,
            size: 25,
            color: borderColor,
          ),
          SizedBox(width: 10),
          Container(
            width: 80,
            height: 50,
            child: AutoSizeText(
              text,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
