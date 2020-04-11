import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/Pages/constans/utils.dart';
import 'package:urawai_pos/Provider/orderList_provider.dart';

class FooterOrderList extends StatelessWidget {
  final _formatCurrency = NumberFormat("#,##0", "en_US");

  @override
  Widget build(BuildContext context) {
    final orderlistProvider =
        Provider.of<OrderListProvider>(context, listen: false);

    double _grandTotal = 0;
    double _tax = 0;
    double _subtotal = 0;

    orderlistProvider.orderlist.forEach((order) {
      _subtotal = order.quantity * order.price;
      _grandTotal = _grandTotal + _subtotal;
    });
    _subtotal = _grandTotal;

    _tax = _subtotal * 0.1;
    _grandTotal = _subtotal + _tax;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: <Widget>[
          Divider(thickness: 3),
          SizedBox(height: 8),
          _bottomInfo(
              title: 'Subtotal',
              value: 'Rp. ${_formatCurrency.format(_subtotal)},-'),
          SizedBox(height: 8),
          _bottomInfo(title: 'Diskon (0%)', value: 'Rp. 0,-'),
          SizedBox(height: 8),
          _bottomInfo(
              title: 'Pajak (10%)',
              value: 'Rp. ${_formatCurrency.format(_tax)},-'),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Total',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Text(
                'Rp. ${_formatCurrency.format(_grandTotal)} ,-',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _bottomButton(
                      icon: Icons.save,
                      title: 'Simpan',
                      onTap: () {
                        if (orderlistProvider.orderID.isNotEmpty &&
                            orderlistProvider.orderlist.isNotEmpty) {
                          print(
                              'save ${orderlistProvider.orderlist.length} Item(s) to DB');

                          //TODO: Save Order to DB
                          // PostedOrder(
                          //   id: orderlistProvider.orderID,
                          //   orderDate: orderlistProvider.orderDate,
                          //   subtotal: _subtotal,
                          //   discount: 0,
                          //   grandTotal: _grandTotal,
                          //   orderList: orderlistProvider.orderlist.toList(),
                          // );

                          showDialog(
                            barrierDismissible: false,
                            child: AlertDialog(
                              title: Text('Informasi Pesanan'),
                              content: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.info,
                                    size: 40,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(width: 10),
                                  Text('Pesanan sudah disimpan.'),
                                ],
                              ),
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);

                                      orderlistProvider.resetOrderList();
                                    },
                                    child: Text('OK'))
                              ],
                            ),
                            context: context,
                          );
                        }
                      }),
                  _bottomButton(icon: Icons.disc_full, title: 'Diskon'),
                  _bottomButton(
                      icon: Icons.check_box_outline_blank,
                      title: 'Split Bill',
                      onTap: () {}),
                ],
              ),
              Expanded(
                child: RaisedButton(
                    padding: EdgeInsets.all(0),
                    child: Container(
                        alignment: Alignment.center,
                        height: 60,
                        color: Color(0xFF408be5),
                        child: Text(
                          'BAYAR',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    onPressed: null),
              )
            ],
          ),
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

  Widget _bottomButton({String title, IconData icon, Function onTap}) {
    return GestureDetector(
      child: Container(
        width: 60,
        height: 60,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: greyColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon),
            Text(
              title,
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
