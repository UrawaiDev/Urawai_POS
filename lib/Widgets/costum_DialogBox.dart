import 'package:flutter/material.dart';

class CostumDialogBox {
  static Future<void> showCostumDialogBox({
    BuildContext context,
    String title,
    String contentString,
    IconData icon,
    Color iconColor,
    String confirmButtonTitle,
    Function onConfirmPressed,
    Function onCancelPressed,
  }) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        child: AlertDialog(
          title: Text(
            title,
            style: TextStyle(fontSize: 22),
          ),
          content: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 30,
                color: iconColor,
              ),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  contentString,
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Batal',
                style: TextStyle(fontSize: 22),
              ),
              onPressed: onCancelPressed,
            ),
            FlatButton(
              child: Text(
                confirmButtonTitle,
                style: TextStyle(fontSize: 22),
              ),
              onPressed: onConfirmPressed,
            )
          ],
        ));
  }
}
