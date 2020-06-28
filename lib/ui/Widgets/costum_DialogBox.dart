import 'package:flutter/material.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';

class CostumDialogBox {
  static showDialogInformation({
    BuildContext context,
    String title,
    IconData icon,
    Color iconColor,
    String contentText,
    Function onTap,
  }) {
    showDialog(
      barrierDismissible: false,
      child: WillPopScope(
        onWillPop: () => Future.value(false),
        child: AlertDialog(
          title: Text(title, style: kDialogTextStyle),
          content: Row(
            children: <Widget>[
              Icon(
                icon,
                size: 40,
                color: iconColor,
              ),
              SizedBox(width: 10),
              Flexible(child: Text(contentText, style: kDialogTextStyle)),
            ],
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: onTap, child: Text('OK', style: kDialogTextStyle))
          ],
        ),
      ),
      context: context,
    );
  }

  static showInputDialogBox({
    TextEditingController textEditingController,
    BuildContext context,
    Key formKey,
    String title,
    String confirmButtonTitle,
    String hint = '',
    Function onConfirmPressed,
  }) {
    showDialog(
        context: context,
        barrierDismissible: false,
        child: AlertDialog(
          title: Text(
            title,
            style: kDialogTextStyle,
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: textEditingController,
              autofocus: true,
              autocorrect: false,
              maxLength: 20,
              style: kPriceTextStyle,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintStyle: kPriceTextStyle,
                hintText: hint,
                errorStyle: kErrorTextStyle,
              ),
              validator: (value) {
                if (value.isEmpty)
                  return 'Rereferensi tidak boleh kosong.';
                else if (value.length < 3) return 'Minimal 3 Karakter.';
                return null;
              },
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Batal',
                style: kDialogTextStyle,
              ),
              onPressed: () => Navigator.pop(context),
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

  static Future<void> showCostumDialogBox({
    BuildContext context,
    String title,
    String contentString,
    IconData icon,
    Color iconColor,
    String confirmButtonTitle,
    Function onConfirmPressed,
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
              onPressed: () => Navigator.pop(context),
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
