import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/core/Models/users.dart';
import 'package:urawai_pos/core/Provider/general_provider.dart';
import 'package:urawai_pos/core/Services/error_handling.dart';
import 'package:urawai_pos/core/Services/firebase_auth.dart';
import 'package:urawai_pos/ui/Widgets/costum_button.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';
import 'package:urawai_pos/ui/utils/functions/routeGenerator.dart';

class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final _formKey = GlobalKey<FormState>();
  final _textshopName = TextEditingController();
  final _textUserName = TextEditingController();
  final _textEmail = TextEditingController();
  final _textPassword = TextEditingController();
  final _textReconfirmPassword = TextEditingController();
  final _textEmailSignIn = TextEditingController();
  final _textPasswordSignIn = TextEditingController();
  final FirebaseAuthentication _auth = FirebaseAuthentication();
  PageController _pageController = PageController();
  String errorMessageSignIn = '';
  String errorMessageSignUp = '';

  @override
  dispose() {
    super.dispose();
    _textshopName.dispose();
    _textUserName.dispose();
    _textEmail.dispose();
    _textPassword.dispose();
    _textReconfirmPassword.dispose();
    _pageController.dispose();
    _textEmailSignIn.dispose();
    _textPasswordSignIn.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final generalProvider = Provider.of<GeneralProvider>(context);
    return SafeArea(
        child: GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Row(
          children: <Widget>[
            Expanded(child: Container(color: Colors.blue)),
            Expanded(
                child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: MediaQuery.of(context).size.height + 100,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Form(
                                key: _formKey,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: PageView(
                                    controller: _pageController,
                                    scrollDirection: Axis.horizontal,
                                    children: <Widget>[
                                      _formSignIn(generalProvider, context),
                                      _formSignUp(generalProvider, context),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Consumer<GeneralProvider>(
                    builder: (_, value, __) => (value.isLoading)
                        ? _showLoading(context)
                        : Container()),
              ],
            )),
          ],
        ),
      ),
    ));
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
        SizedBox(height: 30),
        CostumButton.squareButtonSmall('Masuk', onTap: () async {
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

            if (result is FirebaseAuthError) {
              errorMessageSignIn = result.message;
            } else if (result is FirebaseUser) {
              Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteGenerator.kRouteGateKeeper,
                  ModalRoute.withName(RouteGenerator.kRouteGateKeeper));
            }
          }
        }),
      ],
    );
  }

  Widget _formSignUp(GeneralProvider generalProvider, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Pendaftaran',
          style: kProductNameBigScreenTextStyle,
        ),
        Divider(
          thickness: 4,
          color: Colors.green,
          endIndent: 200,
        ),
        // SizedBox(height: 20),
        Text(
          errorMessageSignUp.isEmpty ? '' : errorMessageSignUp,
          style: kErrorTextStyle,
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _textshopName,
          autocorrect: false,
          decoration: InputDecoration(
            hintStyle: kPriceTextStyle,
            hintText: 'Nama Toko',
            labelStyle: kPriceTextStyle,
            labelText: 'Nama Toko',
            border: OutlineInputBorder(),
            counterText: '',
            errorStyle: kErrorTextStyle,
          ),
          style: kPriceTextStyle,
          maxLength: 30,
          validator: (value) {
            if (value.isEmpty)
              return 'Nama Toko Tidak Boleh Kosong.';
            else if (value.contains('/'))
              return 'Tidak Boleh mengandung karakter \'/\'';

            return null;
          },
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: _textUserName,
          autocorrect: false,
          decoration: InputDecoration(
            hintStyle: kPriceTextStyle,
            hintText: 'Username',
            labelStyle: kPriceTextStyle,
            labelText: 'Username',
            border: OutlineInputBorder(),
            counterText: '',
            errorStyle: kErrorTextStyle,
          ),
          style: kPriceTextStyle,
          maxLength: 20,
          validator: (value) =>
              value.isEmpty ? 'Username Tidak Boleh Kosong' : null,
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: _textEmail,
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
          controller: _textPassword,
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
        TextFormField(
          controller: _textReconfirmPassword,
          autocorrect: false,
          decoration: InputDecoration(
            hintStyle: kPriceTextStyle,
            hintText: 'Konfirmasi Password (Angka)',
            labelStyle: kPriceTextStyle,
            labelText: 'Konfirmasi Password',
            border: OutlineInputBorder(),
            counterText: '',
            errorStyle: kErrorTextStyle,
          ),
          style: kPriceTextStyle,
          maxLength: 6,
          keyboardType: TextInputType.number,
          obscureText: true,
          validator: (value) {
            if (value.isEmpty)
              return 'Konfirmasi Password Tidak Boleh Kosong';
            else if (value != _textPassword.text)
              return 'Password Anda tidak sama.';
            return null;
          },
        ),
        SizedBox(height: 20),
        CostumButton.squareButtonSmall('Sign Up', onTap: () async {
          //Make sure to close softkeyboard
          FocusScope.of(context).unfocus();

          if (_formKey.currentState.validate()) {
            generalProvider.isLoading = true;
            Future.delayed(Duration(seconds: 1));
            var result = await _auth.signUpWithEmail(
              _textEmail.text,
              _textPassword.text,
              _textUserName.text,
              _textshopName.text,
            );

            //stop loading animation
            generalProvider.isLoading = false;

            if (result is Users) {
              Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteGenerator.kRouteGateKeeper,
                  ModalRoute.withName(RouteGenerator.kRouteGateKeeper));
            } else if (result is FirebaseAuthError) {
              errorMessageSignUp = result.message;
            }
          }
        }),
      ],
    );
  }

  Widget _showLoading(BuildContext context) {
    return Positioned.fill(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
}
