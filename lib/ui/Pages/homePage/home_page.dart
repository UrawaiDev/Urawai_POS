import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:urawai_pos/core/Services/firebase_auth.dart';
import 'package:urawai_pos/ui/Widgets/costum_DialogBox.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';
import 'package:urawai_pos/ui/utils/functions/routeGenerator.dart';

class HomePage extends StatelessWidget {
  final FirebaseAuthentication _auth = FirebaseAuthentication();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => _isBackButtonPressed(context),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Halaman Utama',
                  style: kProductNameBigScreenTextStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _isBackButtonPressed(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'Konfirmasi',
                style: kProductNameSmallScreenTextStyle,
              ),
              content: Row(
                children: <Widget>[
                  FaIcon(
                    FontAwesomeIcons.signOutAlt,
                    color: Colors.red,
                    size: 25,
                  ),
                  SizedBox(width: 20),
                  Text(
                    'Keluar dari Aplikasi?',
                    style: kPriceTextStyle,
                  )
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Tidak',
                    style: kPriceTextStyle,
                  ),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                FlatButton(
                  child: Text(
                    'Ya',
                    style: kPriceTextStyle,
                  ),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                )
              ],
            ));
  }
}
