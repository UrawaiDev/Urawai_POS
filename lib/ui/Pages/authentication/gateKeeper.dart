import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/core/Services/firebase_auth.dart';
import 'package:urawai_pos/ui/Pages/authentication/authentication_page.dart';
import 'package:urawai_pos/ui/Pages/homePage/home_page.dart';
import 'package:urawai_pos/core/Models/users.dart';
import 'package:urawai_pos/ui/utils/functions/getCurrentUser.dart';

class GateKeeper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureProvider<Users>(
        create: (context) => CurrentUserLoggedIn.currentUser,
        child: StreamProvider<FirebaseUser>(
          create: (context) => FirebaseAuthentication().userState,
          child: Consumer<FirebaseUser>(
            builder: (context, userState, __) {
              final user = Provider.of<Users>(context);
              if (userState != null && user != null) return HomePage();

              return AuthenticationPage();
            },
          ),
        ));
  }
}
