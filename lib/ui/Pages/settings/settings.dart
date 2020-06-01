import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urawai_pos/core/Models/transaction.dart';
import 'package:urawai_pos/core/Provider/general_provider.dart';
import 'package:urawai_pos/core/Provider/settings_provider.dart';
import 'package:urawai_pos/core/Services/firebase_auth.dart';
import 'package:urawai_pos/core/Services/firestore_service.dart';
import 'package:urawai_pos/ui/Widgets/connection_status.dart';
import 'package:urawai_pos/ui/Widgets/costum_DialogBox.dart';
import 'package:urawai_pos/ui/Widgets/loading_card.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';
import 'package:urawai_pos/main.dart' as mainPage;
import 'package:urawai_pos/ui/utils/functions/routeGenerator.dart';

class SettingPage extends StatelessWidget {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final hiveBox = Hive.box<TransactionOrder>(mainPage.transactionBoxName);
  final FirestoreServices _firestoreServices = FirestoreServices();
  final FirebaseAuthentication _authentication = FirebaseAuthentication();

  @override
  Widget build(BuildContext context) {
    final generalProvider = Provider.of<GeneralProvider>(context);

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('Halaman Pengaturan'),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ConnectionStatusWidget(TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  )),
                ),
              ],
            ),
            // drawer: DrawerMenu(),
            body: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Pengaturan',
                        style: kProductNameBigScreenTextStyle,
                      ),
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            ListTile(
                              title: Text('Pajak Pertambahan Nilai (PPN) 10%',
                                  style: kPriceTextStyle),
                              trailing: FutureBuilder<bool>(
                                  future: _getVAT(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData)
                                      return CupertinoSwitch(
                                          value: snapshot.data,
                                          onChanged: (value) {
                                            showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                child: AlertDialog(
                                                  title: Text(
                                                    'Konfirmasi',
                                                    style: kDialogTextStyle,
                                                  ),
                                                  content: Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.info,
                                                        size: 30,
                                                        color: Colors.blue,
                                                      ),
                                                      SizedBox(width: 20),
                                                      Expanded(
                                                        child: Text(
                                                          value
                                                              ? 'Anda Akan Mengaktifkan Pajak (PPN 10%)'
                                                              : 'Anda Akan Menonaktfikan Pajak (PPN 10%)',
                                                          style:
                                                              kDialogTextStyle,
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
                                                      onPressed: () async {
                                                        await _setVAT(!value);

                                                        // return Navigator
                                                        //     .pop(context);
                                                        Navigator
                                                            .pushReplacementNamed(
                                                                context,
                                                                RouteGenerator
                                                                    .kRouteSettingsPage);
                                                      },
                                                    ),
                                                    FlatButton(
                                                      child: Text(
                                                        'OK',
                                                        style: kDialogTextStyle,
                                                      ),
                                                      onPressed: () async {
                                                        await _setVAT(value);
                                                        Navigator.pop(context);
                                                        CostumDialogBox
                                                            .showDialogInformation(
                                                                context:
                                                                    context,
                                                                icon:
                                                                    Icons.check,
                                                                iconColor:
                                                                    Colors
                                                                        .green,
                                                                title:
                                                                    'Informasi',
                                                                contentText:
                                                                    'PPN 10% Telah di Aktifkan, \nAplikasi perlu di Restart.',
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  Phoenix.rebirth(
                                                                      context);
                                                                });
                                                      },
                                                    )
                                                  ],
                                                ));
                                          });

                                    return Container(
                                      child: Text('...'),
                                    );
                                  }),
                            ),
                            //* TODO: Load Offline Transaction Order
                            ListTile(
                              title: Text(
                                'Terdapat [${hiveBox.length}] Transaksi Offline',
                                style: kPriceTextStyle,
                              ),
                              trailing: Consumer<ConnectivityResult>(
                                builder: (_, connectionStatus, __) =>
                                    RaisedButton.icon(
                                  onPressed: () async {
                                    if (hiveBox.length != 0 &&
                                        connectionStatus !=
                                            ConnectivityResult.none) {
                                      generalProvider.isLoading = true;

                                      var currentUser =
                                          await _authentication.currentUserXXX;
                                      if (currentUser != null) {
                                        hiveBox.values
                                            .forEach((transactionOrder) {
                                          _firestoreServices.postTransaction(
                                              currentUser.shopName,
                                              transactionOrder);
                                          hiveBox.delete(transactionOrder.id);
                                        });

                                        //* When Done.
                                        print('All Done!!!');
                                        generalProvider.isLoading = false;
                                        CostumDialogBox.showDialogInformation(
                                          context: context,
                                          title: 'Informasi',
                                          icon: Icons.check,
                                          iconColor: Colors.green,
                                          contentText: 'Sinkronisasi Berhasil.',
                                          onTap: () => Navigator.pop(context),
                                        );
                                      }
                                    }
                                  },
                                  icon: Icon(
                                    Icons.sync,
                                    size: 28,
                                    color: ((connectionStatus ==
                                                ConnectivityResult.none) ||
                                            hiveBox.length == 0)
                                        ? Colors.green
                                        : Colors.white,
                                  ),
                                  label: Text(
                                    'Sinkronisasi',
                                    style: ((connectionStatus ==
                                                ConnectivityResult.none) ||
                                            hiveBox.length == 0)
                                        ? kPriceTextStyle
                                        : TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                  ),
                                  color: ((connectionStatus ==
                                              ConnectivityResult.none) ||
                                          hiveBox.length == 0)
                                      ? Colors.grey[350]
                                      : Colors.green,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Consumer<GeneralProvider>(
                  builder: (context, value, _) =>
                      (value.isLoading) ? LoadingCard() : Container(),
                ),
              ],
            )));
  }

  Future<void> _setVAT(bool value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('vat', value);
  }

  Future<bool> _getVAT() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool('vat');
  }
}
