import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/Models/postedOrder.dart';
import 'package:urawai_pos/Provider/orderList_provider.dart';
import 'package:urawai_pos/constans/utils.dart';

class FooterOrderList extends StatelessWidget {
  final _formatCurrency = NumberFormat("#,##0", "en_US");
  static const String postedOrderBox = "Posted_Order";
  final double subtotal;
  final double grandTotal;
  final double dicount;
  final double tax;

  FooterOrderList({this.grandTotal, this.subtotal, this.dicount, this.tax});

  @override
  Widget build(BuildContext context) {
    final orderlistProvider =
        Provider.of<OrderListProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: <Widget>[
          Divider(thickness: 3),
          SizedBox(height: 8),
          _bottomInfo(
              title: 'Subtotal',
              value: 'Rp. ${_formatCurrency.format(subtotal)},-'),
          SizedBox(height: 8),
          _bottomInfo(
              title: 'Diskon (0%)',
              value: 'Rp. ${_formatCurrency.format(dicount)},-'),
          SizedBox(height: 8),
          _bottomInfo(
              title: 'Pajak (10%)',
              value: 'Rp. ${_formatCurrency.format(subtotal * tax)},-'),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Total',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Text(
                'Rp. ${_formatCurrency.format(grandTotal)} ,-',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
          style: priceTextStyle,
        ),
        Text(
          value,
          style: priceTextStyle,
        ),
      ],
    );
  }
}
