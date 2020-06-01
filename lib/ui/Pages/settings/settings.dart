import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urawai_pos/core/Provider/settings_provider.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';

class SettingPage extends StatelessWidget {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('Halaman Pengaturan'),
            ),
            // drawer: DrawerMenu(),
            body: Padding(
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
                                  return Consumer<SettingProvider>(
                                    builder: (_, state, __) => CupertinoSwitch(
                                        value: snapshot.data,
                                        onChanged: (value) {
                                          state.taxActivated =
                                              !state.taxActivated;
                                          _setVAT(value);
                                        }),
                                  );

                                return Container(
                                  child: Text('...'),
                                );
                              }),
                        ),
                        //* TODO: Load Offline Transaction Order
                        ListTile(
                          title: Text(
                            'Terdapat 0 Transaksi Offline',
                            style: kPriceTextStyle,
                          ),
                          trailing: RaisedButton.icon(
                              onPressed: () {},
                              icon: Icon(
                                Icons.sync,
                                color: Colors.green,
                              ),
                              label: Text(
                                'Sinkronisasi',
                                style: kPriceTextStyle,
                              )),
                        )
                      ],
                    ),
                  )
                ],
              ),
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
