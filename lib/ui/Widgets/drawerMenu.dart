import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:urawai_pos/core/Models/users.dart';
import 'package:urawai_pos/core/Services/firebase_auth.dart';
import 'package:urawai_pos/ui/Widgets/costum_DialogBox.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';
import 'package:urawai_pos/ui/utils/functions/routeGenerator.dart';

class DrawerMenu extends StatelessWidget {
  final Users currentUser;
  DrawerMenu(this.currentUser);
  final locatorAuth = GetIt.I<FirebaseAuthentication>();

  String _getUserIntial(String username) {
    String userInital = '';
    var result = username.trim().split(' ');
    for (String intial in result) userInital = userInital + intial[0];

    return userInital.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              currentUser.username,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            accountEmail: Text(
              currentUser.email,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            currentAccountPicture: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[600],
              ),
              child: Text(
                _getUserIntial(currentUser.username),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.cashRegister),
            title: (Text(
              'Transaksi',
              style: kMainMenuStyle,
            )),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, RouteGenerator.kRoutePOSPage);
            },
          ),
          ListTile(
              leading: FaIcon(FontAwesomeIcons.clipboardList),
              title: (Text(
                'Riwayat Transaksi',
                style: kMainMenuStyle,
              )),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                    context, RouteGenerator.kRouteTransactionHistory);
              }),
          ListTile(
              leading: FaIcon(FontAwesomeIcons.book),
              title: (Text(
                'Laporan',
                style: kMainMenuStyle,
              )),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                    context, RouteGenerator.kRouteTransactionReport);
              }),
          ListTile(
              leading: FaIcon(FontAwesomeIcons.cog),
              title: (Text(
                'Pengaturan',
                style: kMainMenuStyle,
              )),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, RouteGenerator.kRouteSettingsPage);
              }),
          ExpansionTile(
            title: Text(
              'Produk',
              style: kPriceTextStyle,
            ),
            leading: FaIcon(FontAwesomeIcons.folder),
            children: <Widget>[
              ListTile(
                leading: FaIcon(FontAwesomeIcons.plus),
                title: (Text(
                  'Tambah Produk',
                  style: kMainMenuStyle,
                )),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                      context, RouteGenerator.kRouteAddProductPage);
                },
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.listAlt),
                title: (Text(
                  'List Produk',
                  style: kMainMenuStyle,
                )),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                      context, RouteGenerator.kRouteProductListPage);
                },
              ),
            ],
          ),
          //* Hide for Now
          // ListTile(
          //   leading: FaIcon(FontAwesomeIcons.lifeRing),
          //   title: (Text('Bantuan', style: kMainMenuStyle)),
          // ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.signOutAlt),
            title: (Text('Keluar', style: kMainMenuStyle)),
            onTap: () {
              CostumDialogBox.showCostumDialogBox(
                  context: context,
                  title: 'Konfirmasi',
                  icon: FontAwesomeIcons.signOutAlt,
                  iconColor: Colors.red,
                  contentString: 'Keluar dari Aplikasi?',
                  confirmButtonTitle: 'Keluar',
                  onConfirmPressed: () {
                    locatorAuth.signOut();
                    SystemNavigator.pop();
                  });
            },
          ),
        ],
      ),
    );
  }
}
