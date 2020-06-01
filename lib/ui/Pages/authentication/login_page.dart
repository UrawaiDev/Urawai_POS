import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/core/Models/users.dart';
import 'package:urawai_pos/core/Provider/general_provider.dart';
import 'package:urawai_pos/core/Services/error_handling.dart';
import 'package:urawai_pos/core/Services/firebase_auth.dart';
import 'package:urawai_pos/ui/Widgets/costum_button.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';
import 'package:urawai_pos/ui/utils/functions/routeGenerator.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _textEmailSignIn = TextEditingController();
  final _textPasswordSignIn = TextEditingController();
  final FirebaseAuthentication _auth = FirebaseAuthentication();
  String errorMessageSignIn = '';

  @override
  dispose() {
    super.dispose();

    _textEmailSignIn.dispose();
    _textPasswordSignIn.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final generalProvider = Provider.of<GeneralProvider>(context);

    return SafeArea(
        child: WillPopScope(
      onWillPop: () => _isBackButtonPressed(context),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Color(0xFFfeffff),
          // body: _viewPage(context, generalProvider),
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      //* LEFT SIDE
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Selamat Datang.',
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.blueAccent,
                              ),
                            ),
                            Text(
                              'Urawai POS (Point of Sales)',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontStyle: FontStyle.italic),
                            ),
                            SizedBox(height: 50),
                            Container(
                              width: 400,
                              height: 400,
                              child: Image.asset(
                                'assets/images/login_image.jpg',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //* RIGHT SIDE
                      _buildRightSide(generalProvider, context)
                    ],
                  ),
                ),
              ),
              Consumer<GeneralProvider>(
                  builder: (_, value, __) =>
                      (value.isLoading) ? _showLoading(context) : Container()),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildRightSide(
      GeneralProvider generalProvider, BuildContext context) {
    return Expanded(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _formSignIn(generalProvider, context)),
          ),
        ),
      ),
    );
  }

  Widget _formSignIn(GeneralProvider generalProvider, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Masuk',
          style: kProductNameBigScreenTextStyle,
        ),
        Divider(
          thickness: 4,
          color: Colors.green,
          endIndent: 200,
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: _textEmailSignIn,
          autocorrect: false,
          decoration: InputDecoration(
            hintStyle: kPriceTextStyle,
            hintText: 'Alamat Email',
            labelStyle: kPriceTextStyle,
            labelText: 'Email',
            border: OutlineInputBorder(),
            counterText: '',
            errorStyle: kErrorTextStyle,
          ),
          style: kPriceTextStyle,
          maxLength: 50,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value.isEmpty)
              return 'Email Tidak Boleh Kosong.';
            else if (!EmailValidator.validate(value))
              return 'Email Anda Tidak Valid';
            return null;
          },
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: _textPasswordSignIn,
          autocorrect: false,
          decoration: InputDecoration(
            hintStyle: kPriceTextStyle,
            hintText: 'Password (Angka)',
            labelStyle: kPriceTextStyle,
            labelText: 'Password',
            border: OutlineInputBorder(),
            counterText: '',
            errorStyle: kErrorTextStyle,
          ),
          style: TextStyle(fontSize: 25),
          maxLength: 6,
          keyboardType: TextInputType.number,
          obscureText: true,
          validator: (value) {
            if (value.isEmpty) return 'Password Tidak Boleh Kosong.';
            return null;
          },
        ),
        SizedBox(height: 20),
        Text(
          errorMessageSignIn.isEmpty ? '' : errorMessageSignIn,
          style: kErrorTextStyle,
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            CostumButton.squareButtonSmall('Masuk',
                prefixIcon: FontAwesomeIcons.signInAlt, onTap: () async {
              //Make sure to close softkeyboard
              FocusScope.of(context).unfocus();

              if (_formKey.currentState.validate()) {
                //show loading
                generalProvider.isLoading = true;
                Future.delayed(Duration(seconds: 1));

                var result = await _auth.signInWithEmailandPassword(
                    _textEmailSignIn.text, _textPasswordSignIn.text);

                //stop loading
                generalProvider.isLoading = false;
                if (result == null) {
                  print('hasilnya $result');
                } else if (result is OnErrorState) {
                  errorMessageSignIn = result.message;
                } else if (result is Users) {
                  // TODO:will check the best option
                  // Navigator.pushNamedAndRemoveUntil(
                  //     context,
                  //     RouteGenerator.kRouteGateKeeper,
                  //     ModalRoute.withName(RouteGenerator.kRouteGateKeeper));

                  Navigator.pushNamed(context, RouteGenerator.kRoutePOSPage);
                }
              }
            }),
            SizedBox(width: 20),
            GestureDetector(
              child: Text(
                'Daftar disini',
                style: TextStyle(
                    fontSize: 22,
                    fontStyle: FontStyle.italic,
                    decoration: TextDecoration.underline),
              ),
              onTap: () =>
                  Navigator.pushNamed(context, RouteGenerator.kRouteSignUpPage),
            ),
          ],
        ),
      ],
    );
  }

  Widget _showLoading(BuildContext context) {
    return Positioned.fill(
      child: Container(
        // width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
        color: Colors.grey.withOpacity(0.6),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            width: 250,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: 80, height: 80, child: CircularProgressIndicator()),
                SizedBox(height: 10),
                Text('Loading...', style: kPriceTextStyle),
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
