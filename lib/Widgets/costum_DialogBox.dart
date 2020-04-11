import 'package:flutter/material.dart';

class CostumDialogBox {
  Future<void> showCostumDialogBox({
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
          title: Text(title),
          content: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 30,
                color: iconColor,
              ),
              SizedBox(width: 20),
              Text(contentString),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Batal'),
              onPressed: onCancelPressed,
            ),
            FlatButton(
              child: Text(confirmButtonTitle),
              onPressed: onConfirmPressed,
            )
          ],
        ));
  }
}
