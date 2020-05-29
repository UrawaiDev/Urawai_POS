import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/core/Services/firebase_auth.dart';
import 'package:urawai_pos/ui/Pages/authentication/authentication_page.dart';
import 'package:urawai_pos/core/Models/users.dart';
import 'package:urawai_pos/ui/Pages/pos/pos_Page.dart';
import 'package:urawai_pos/ui/utils/functions/getCurrentUser.dart';

class GateKeeper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return FutureProvider<Users>(
    //   create: (context) => CurrentUserLoggedIn.currentUser,
    //   child: StreamProvider<FirebaseUser>(
    //     create: (context) => FirebaseAuthentication().userState,
    //     child: Consumer2<FirebaseUser, Users>(
    //       builder: (context, userState, currentUser, __) {
    //         print('Firebase user $userState');
    //         print('Current user ${currentUser.username}');
    //         if (userState == null || currentUser == null)
    //           return AuthenticationPage();

    //         return POSPage();
    //       },
    //     ),
    //   ),
    // );

    return StreamProvider<FirebaseUser>(
      create: (context) => FirebaseAuthentication().userState,
      child: Consumer<FirebaseUser>(
        builder: (context, userState, __) {
          if (userState != null) {
            print('user aktif ${userState.email}');
            return POSPage();
          } else {
            print('user aktif $userState');
            return AuthenticationPage();
          }
        },
      ),
    );
  }
}
