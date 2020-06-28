import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:urawai_pos/core/Services/firebase_auth.dart';
import 'package:urawai_pos/ui/Widgets/costum_DialogBox.dart';

import 'package:urawai_pos/ui/utils/constans/utils.dart';
import 'package:urawai_pos/ui/utils/functions/routeGenerator.dart';
import 'package:validators/validators.dart';

class ResetPasswordDialog extends StatefulWidget {
  @override
  _ResetPasswordDialogState createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  var _textResetPassword = TextEditingController();

  final FirebaseAuthentication _firebaseAuthentication =
      FirebaseAuthentication();

  @override
  void dispose() {
    _textResetPassword.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Reset Password',
        style: kDialogTextStyle,
      ),
      content: Container(
        width: 400,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _textResetPassword,
                  keyboardType: TextInputType.emailAddress,
                  style: kDialogTextStyle,
                  decoration: InputDecoration(
                      icon: Icon(Icons.lock_open), hintText: 'Masukkan Email'),
                  validator: (value) {
                    if (value.isEmpty)
                      return 'Tidak Boleh Kosong.';
                    else if (!isEmail(value))
                      return 'Format Email Tidak sesuai.';
                    return null;
                  },
                ),
              ),
            ),
          ],
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
              'OK',
              style: kDialogTextStyle,
            ),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                var result = await _firebaseAuthentication
                    .resetPassword(_textResetPassword.text);
                if (result == true)
                  CostumDialogBox.showDialogInformation(
                    context: context,
                    title: 'Reset Password',
                    icon: Icons.check_box,
                    iconColor: Colors.green,
                    contentText:
                        'Email permintaan reset telah dikirim ke email ${_textResetPassword.text}',
                    onTap: () => Navigator.pushReplacementNamed(
                        context, RouteGenerator.kRouteLoginPage),
                  );
                else if (result is String) {
                  CostumDialogBox.showDialogInformation(
                    context: context,
                    title: 'Reset Password',
                    icon: Icons.sms_failed,
                    iconColor: Colors.red,
                    contentText: '$result \nEmail: ${_textResetPassword.text}',
                    onTap: () => Navigator.pushReplacementNamed(
                        context, RouteGenerator.kRouteLoginPage),
                  );
                }
              }
            })
      ],
    );
  }
}
