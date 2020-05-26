import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:urawai_pos/core/Models/users.dart';
import 'package:urawai_pos/core/Services/firebase_auth.dart';
import 'package:urawai_pos/core/Services/firestore_service.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';

class CurrentUserWidget extends StatelessWidget {
  final FirebaseAuthentication _firebaseAuthentication =
      FirebaseAuthentication();
  final FirestoreServices _firestoreServices = FirestoreServices();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
        stream: _firebaseAuthentication.userState,
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting)
            return Text('Loading...', style: kPriceTextStyle);

          return FutureBuilder<Users>(
            future: _firestoreServices.currentUser(snapshot.data.uid),
            builder: (context, userSnapshot) {
              if (!userSnapshot.hasData ||
                  userSnapshot.connectionState == ConnectionState.waiting)
                return Text(
                  'Loading...',
                  style: kPriceTextStyle,
                );

              return Text(
                'Kasir: ${userSnapshot.data.username}',
                style: kPriceTextStyle,
              );
            },
          );
        });
  }
}
