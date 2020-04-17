import 'package:flutter/material.dart';
import 'package:urawai_pos/constans/utils.dart';

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
            style: kDialogTextStyle,
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
                  style: kDialogTextStyle,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Batal',
                style: kDialogTextStyle,
              ),
              onPressed: onCancelPressed,
            ),
            FlatButton(
              child: Text(
                confirmButtonTitle,
                style: kDialogTextStyle,
              ),
              onPressed: onConfirmPressed,
            )
          ],
        ));
  }
}
