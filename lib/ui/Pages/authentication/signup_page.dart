import 'package:carousel_slider/carousel_slider.dart';
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
import 'package:validators/validators.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _textshopName = TextEditingController();
  final _textUserName = TextEditingController();
  final _textEmail = TextEditingController();
  final _textPassword = TextEditingController();
  final _textReconfirmPassword = TextEditingController();

  final FirebaseAuthentication _auth = FirebaseAuthentication();
  String errorMessageSignUp = '';

  int _current = 0;

  final List<String> imageUrl = [
    'assets/images/bakmi.jpg',
    'assets/images/bakmi_ayam_pedas.jpg',
    'assets/images/bakmi_ayam_spesial.png',
    'assets/images/bakso.jpg',
    'assets/images/eskopi_susu.jpg',
  ];

  @override
  dispose() {
    super.dispose();
    _textshopName.dispose();
    _textUserName.dispose();
    _textEmail.dispose();
    _textPassword.dispose();
    _textReconfirmPassword.dispose();
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
          backgroundColor: Color(0xFFf8fafb),
          // body: _viewPage(context, generalProvider),
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //* LEFT SIDE
                      Expanded(
                        child: Column(
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
                            SizedBox(height: 10),
                            SizedBox.fromSize(
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    CarouselSlider(
                                      options: CarouselOptions(
                                          autoPlay: true,
                                          enableInfiniteScroll: true,
                                          viewportFraction: 1,
                                          autoPlayCurve: Curves.easeInToLinear,
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              _current = index;
                                            });
                                          }),
                                      items: imageUrl
                                          .map((data) => Container(
                                                child: Image.asset(
                                                  data,
                                                  fit: BoxFit.cover,
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: imageUrl.map((url) {
                                        int index = imageUrl.indexOf(url);
                                        return Container(
                                          width: 8.0,
                                          height: 8.0,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 2.0),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _current == index
                                                ? Color.fromRGBO(0, 0, 0, 0.9)
                                                : Color.fromRGBO(0, 0, 0, 0.4),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
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
                child: _formSignUp(generalProvider, context)),
          ),
        ),
      ),
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
        SizedBox(height: 10),
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
        SizedBox(height: 10),
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
        SizedBox(height: 10),
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
          style: kPriceTextStyle,
          maxLength: 6,
          keyboardType: TextInputType.number,
          obscureText: true,
          validator: (value) {
            if (value.isEmpty)
              return 'Password Tidak Boleh Kosong.';
            else if (!isNumeric(value))
              return 'Hanya Password Angka yg diperbolehkan.';
            return null;
          },
        ),
        SizedBox(height: 10),
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
        Row(
          children: <Widget>[
            CostumButton.buttonLoginPage('Daftar', Color(0xFF3882fe),
                Colors.white, () => _onSignUpTap(generalProvider)),
            SizedBox(width: 10),
            CostumButton.buttonLoginPage(
                'Login',
                Color(0xFFeef1f4),
                Colors.grey,
                () => Navigator.pushNamed(
                    context, RouteGenerator.kRouteLoginPage)),
          ],
        ),
      ],
    );
  }

  Future<void> _onSignUpTap(GeneralProvider generalProvider) async {
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
        Navigator.pushNamed(context, RouteGenerator.kRoutePOSPage);
      } else if (result is OnErrorState) {
        errorMessageSignUp = result.message;
      }
    }
  }

  Widget _showLoading(BuildContext context) {
    return Positioned.fill(
      child: Container(
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
