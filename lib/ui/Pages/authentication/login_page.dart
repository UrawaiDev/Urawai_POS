import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:animations/animations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/core/Models/carousel_intro.dart';
import 'package:urawai_pos/core/Models/users.dart';
import 'package:urawai_pos/core/Provider/general_provider.dart';
import 'package:urawai_pos/core/Services/error_handling.dart';
import 'package:urawai_pos/core/Services/firebase_auth.dart';
import 'package:urawai_pos/ui/Pages/authentication/reset_password.dart';
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
  final _textResetPassword = TextEditingController();
  final FirebaseAuthentication _auth = FirebaseAuthentication();
  String errorMessageSignIn = '';

  List<CarouselIntro> carouselIntro = List<CarouselIntro>();

  @override
  void initState() {
    super.initState();
    carouselIntro = CarouselIntro().getDefaultValue();
  }

  @override
  dispose() {
    super.dispose();

    _textEmailSignIn.dispose();
    _textPasswordSignIn.dispose();
    _textResetPassword.dispose();
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
          // backgroundColor: Color(0xFFf8fafb),
          backgroundColor: Color(0xFFFFFFFF),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TypewriterAnimatedTextKit(
                              speed: Duration(milliseconds: 800),
                              repeatForever: true,
                              text: ['Selamat Datang.'],
                              textStyle: TextStyle(
                                fontSize: 40,
                                color: Colors.blueAccent,
                              ),
                            ),
                            FadeAnimatedTextKit(
                              duration: Duration(milliseconds: 1200),
                              repeatForever: true,
                              text: ['Urawai POS (Point of Sales)'],
                              textStyle: TextStyle(
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
                                            generalProvider
                                                .carouselCurrentIndex = index;
                                          }),
                                      items: carouselIntro
                                          .map((data) => Stack(
                                                children: <Widget>[
                                                  Container(
                                                    child: Image.asset(
                                                      data.imgUrl,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    left: 0,
                                                    right: 0,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                topRight: Radius
                                                                    .circular(
                                                                        20)),
                                                        color: Colors.grey
                                                            .withOpacity(0.2),
                                                      ),
                                                      child: Text(data.quote,
                                                          style: TextStyle(
                                                            fontSize: 17,
                                                            color: Colors
                                                                .grey[700],
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                    ),
                                                  )
                                                ],
                                              ))
                                          .toList(),
                                    ),
                                    Consumer<GeneralProvider>(
                                      builder: (_, generalProvider, __) => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: carouselIntro.map((url) {
                                          int index =
                                              carouselIntro.indexOf(url);
                                          return Container(
                                            width: 8.0,
                                            height: 8.0,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 2.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: generalProvider
                                                          .carouselCurrentIndex ==
                                                      index
                                                  ? Color.fromRGBO(
                                                      56, 130, 254, 1.0)
                                                  : Color.fromRGBO(
                                                      0, 0, 0, 0.4),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //* RIGHT SIDE
                      Expanded(child: _buildRightSide(generalProvider, context))
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
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: _formSignIn(generalProvider, context),
        ),
      ),
    );
  }

  Widget _formSignIn(GeneralProvider generalProvider, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
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
        SizedBox(height: 10),
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
          style: kPriceTextStyle,
          maxLength: 6,
          keyboardType: TextInputType.number,
          obscureText: true,
          validator: (value) {
            if (value.isEmpty) return 'Password Tidak Boleh Kosong.';
            return null;
          },
        ),
        SizedBox(height: 5),
        GestureDetector(
          child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                'Lupa Password?',
                style: kPriceTextStyle,
              )),
          onTap: () {
            showModal(
                context: context,
                configuration: FadeScaleTransitionConfiguration(
                  barrierDismissible: false,
                  transitionDuration: Duration(milliseconds: 400),
                ),
                // barrierDismissible: false,
                builder: (context) => ResetPasswordDialog());
          },
        ),
        SizedBox(height: 10),
        Text(
          errorMessageSignIn.isEmpty ? '' : errorMessageSignIn,
          style: kErrorTextStyle,
        ),
        Wrap(
          spacing: 5,
          children: <Widget>[
            CostumButton.buttonLoginPage('Masuk', Color(0xFF3882fe),
                Colors.white, () => _onLoginTap(generalProvider)),
            SizedBox(width: 10),
            CostumButton.buttonLoginPage(
                'Daftar',
                Color(0xFFeef1f4),
                Colors.grey,
                () => Navigator.pushNamed(
                    context, RouteGenerator.kRouteSignUpPage)),
          ],
        ),
      ],
    );
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

  Future<void> _onLoginTap(GeneralProvider generalProvider) async {
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
        Navigator.pushNamed(context, RouteGenerator.kRoutePOSPage);
      }
    }
  }

  Future<bool> _isBackButtonPressed(BuildContext context) {
    return showModal(
        configuration: FadeScaleTransitionConfiguration(
          barrierDismissible: false,
          transitionDuration: Duration(milliseconds: 500),
        ),
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
