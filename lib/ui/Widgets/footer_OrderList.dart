import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urawai_pos/ui/utils/constans/formatter.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';

class FooterOrderList extends StatelessWidget {
  static const String postedOrderBox = "Posted_Order";
  final double subtotal;
  final double grandTotal;
  final double dicount;
  final double vat;

  FooterOrderList({this.grandTotal, this.subtotal, this.dicount, this.vat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: <Widget>[
          Divider(thickness: 3),
          SizedBox(height: 5),
          _bottomInfo(
              title: 'Subtotal', value: Formatter.currencyFormat(subtotal)),
          SizedBox(height: 5),
          _bottomInfo(
              title: 'Diskon', value: Formatter.currencyFormat(dicount)),
          SizedBox(height: 5),
          FutureBuilder<bool>(
            future: getVAT(),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState ==
                      ConnectionState.done) if (snapshot.data == true)
                return _bottomInfo(
                    title: 'Pajak (10%)', value: Formatter.currencyFormat(vat));
              else
                return Container();
              return Container();
            },
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Total',
                style: kGrandTotalTextStyle,
              ),
              Text(
                Formatter.currencyFormat(grandTotal),
                style: kGrandTotalTextStyle,
              ),
            ],
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _bottomInfo({String title, String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title,
          style: kPriceTextStyle,
        ),
        Text(
          value,
          style: kPriceTextStyle,
        ),
      ],
    );
  }

  Future<bool> getVAT() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    return _prefs.getBool('vat');
  }
}
