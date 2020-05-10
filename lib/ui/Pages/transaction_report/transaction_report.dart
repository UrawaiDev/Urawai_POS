import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:urawai_pos/core/Models/transaction.dart';
import 'package:urawai_pos/ui/Widgets/costum_button.dart';
import 'package:urawai_pos/ui/Widgets/drawerMenu.dart';
import 'package:urawai_pos/ui/utils/constans/formatter.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';

class TransactionReport extends StatelessWidget {
  static const String routeName = '/transaction_Report';
  @override
  Widget build(BuildContext context) {
    var box = Hive.box<TransactionOrder>(TransactionOrder.boxName);

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(title: Text('Laporan Penjualan')),
            drawer: Drawer(
              child: DrawerMenu(),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Beranda', style: kHeaderTextStyle),
                        CostumButton.squareButton('Periode Penjualan'),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _headerCard(
                          'Total Penjualan Kotor',
                          Colors.lightGreen,
                          _getBruto(box),
                        ),
                        _headerCard(
                          'Total Keuntungan',
                          Colors.amber,
                          _getNetto(box),
                        ),
                        _headerCard(
                          'Total Transaksi',
                          Colors.blue,
                          box.length.toString(),
                        ),
                        _headerCard(
                          'Rata-Rata Nilai Transaksi',
                          Colors.red,
                          _getAverage(box),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Produk Terlaris',
                                          style: kHeaderTextStyle,
                                        ),
                                        Text(
                                          'Produk dengan penjualan terbanyak',
                                          style: kPriceTextStyle,
                                        ),
                                        Divider(thickness: 4),
                                      ],
                                    ),
                                    Expanded(
                                      child: ListView(
                                        children: <Widget>[
                                          ListTile(
                                            title: Text(
                                              'Mie Ayam',
                                              style: kPriceTextStyle,
                                            ),
                                            trailing: Text(
                                              '20',
                                              style: kPriceTextStyle,
                                            ),
                                          ),
                                          ListTile(
                                            title: Text(
                                              'Bakso Tenis',
                                              style: kPriceTextStyle,
                                            ),
                                            trailing: Text(
                                              '15',
                                              style: kPriceTextStyle,
                                            ),
                                          ),
                                          ListTile(
                                            title: Text(
                                              'Nasi Kucing',
                                              style: kPriceTextStyle,
                                            ),
                                            trailing: Text(
                                              '10',
                                              style: kPriceTextStyle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //Prepare for Chart
                          Expanded(
                              child: Container(
                            // color: Colors.blue,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                'CHART',
                                style: kProductNameBigScreenTextStyle,
                              ),
                            ),
                          )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )));
  }

  String _getBruto(Box<TransactionOrder> box) {
    double result =
        box.values.fold(0, (prev, element) => prev + element.grandTotal);

    return Formatter.currencyFormat(result);
  }

  String _getNetto(Box<TransactionOrder> box) {
    double total =
        box.values.fold(0, (prev, element) => prev + element.grandTotal);

    double result = (total * 100 / 110);

    return Formatter.currencyFormat(result);
  }

  String _getAverage(Box<TransactionOrder> box) {
    double total =
        box.values.fold(0, (prev, element) => prev + element.grandTotal);

    double result = total / box.length;

    return Formatter.currencyFormat(result);
  }

  Widget _headerCard(String title, Color color, String value) {
    return Container(
      width: 230,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: kPriceTextStyle,
                ),
                SizedBox(height: 10),
                Text(
                  value,
                  style: kProductNameBigScreenTextStyle,
                ),
              ],
            ),
          ),
          Container(
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
            ),
          )
        ],
      ),
    );
  }
}
