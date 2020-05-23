import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';
import 'package:urawai_pos/ui/utils/functions/routeGenerator.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(child: CircleAvatar()),
          Container(
            color: Color(0xFFebf2fd),
            child: ListTile(
              leading: Icon(Icons.home),
              title: (Text(
                'Beranda',
                style: kMainMenuStyle,
              )),
              selected: true,
              onTap: () {},
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
            onTap: () {},
          ),
          ExpansionTile(
            title: Text(
              'Produk',
              style: kPriceTextStyle,
            ),
            leading: FaIcon(FontAwesomeIcons.instagram),
            children: <Widget>[
              ListTile(
                leading: FaIcon(FontAwesomeIcons.cog),
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
                leading: FaIcon(FontAwesomeIcons.instagram),
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
          ListTile(
            leading: FaIcon(FontAwesomeIcons.lifeRing),
            title: (Text('Bantuan', style: kMainMenuStyle)),
          ),
        ],
      ),
    );
  }
}
