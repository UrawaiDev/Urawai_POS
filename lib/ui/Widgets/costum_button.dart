import 'package:flutter/material.dart';

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
      child: Container(
        alignment: Alignment.center,
        width: 180,
        height: 50,
        decoration: BoxDecoration(
            border: Border.all(
          width: 2,
          color: borderColor,
        )),
        child: Padding(
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
}
