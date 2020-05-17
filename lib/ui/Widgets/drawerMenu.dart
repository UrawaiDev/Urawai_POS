import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:urawai_pos/ui/Pages/Transacation_history/transaction_history.dart';
import 'package:urawai_pos/ui/Pages/pos/pos_Page.dart';
import 'package:urawai_pos/ui/Pages/products/add_products.dart';
import 'package:urawai_pos/ui/Pages/transaction_report/transaction_report.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
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
            Navigator.pushNamed(context, POSPage.routeName);
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
              Navigator.pushNamed(context, TransactionHistoryPage.routeName);
            }),
        ListTile(
            leading: FaIcon(FontAwesomeIcons.book),
            title: (Text(
              'Laporan',
              style: kMainMenuStyle,
            )),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, TransactionReport.routeName);
            }),
        ListTile(
          leading: FaIcon(FontAwesomeIcons.cog),
          title: (Text(
            'Pengaturan',
            style: kMainMenuStyle,
          )),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AddProductPage.routeName);
          },
        ),
        ListTile(
          leading: FaIcon(FontAwesomeIcons.lifeRing),
          title: (Text('Bantuan', style: kMainMenuStyle)),
        ),
      ],
    );
  }
}
