import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:urawai_pos/Models/postedOrder.dart';
import 'package:urawai_pos/Widgets/footer_OrderList.dart';
import 'package:urawai_pos/constans/utils.dart';

class PaymentSuccess extends StatelessWidget {
  final List<dynamic> itemList;
  final String cashierName;
  final String date;
  final String orderID;
  final double pembayaran;
  final double kembali;

  PaymentSuccess({
    @required this.itemList,
    @required this.cashierName,
    @required this.date,
    @required this.orderID,
    @required this.pembayaran,
    @required this.kembali,
  });

  final _formatCurrency = NumberFormat.currency(
    symbol: 'Rp.',
    locale: 'en_US',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: SafeArea(
        child: Scaffold(
          body: Container(
            child: Row(
              children: <Widget>[
                SizedBox(width: 10),
                //LEFT SIDE
                Container(
                  width: 1.5,
                  color: Colors.grey,
                ),
                SizedBox(width: 5),
                Expanded(
                  child: Container(
                    // color: Colors.blue,
                    padding: EdgeInsets.fromLTRB(10, 20, 5, 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('WARUNG MAKYOS',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                )),
                            Text(
                              'Jln. KP. Rawageni No. 5',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'RT 4. RW 5, Kelurahan Ratujaya, Kota DEPOK',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            Divider(
                              thickness: 2,
                            ),
                            Row(
                              children: <Widget>[
                                Text('Ref. Order :'),
                                SizedBox(width: 8),
                                Text(orderID),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text('Tanggal :'),
                                SizedBox(width: 8),
                                Text(date),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text('Kasir :'),
                                SizedBox(width: 8),
                                Text(cashierName),
                              ],
                            ),
                            Divider(
                              thickness: 2,
                            )
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Container(
                              child: ListView.builder(
                                  itemCount: itemList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                itemList[index]
                                                    .quantity
                                                    .toString(),
                                                style: kStruckTextStyle,
                                              ),
                                              SizedBox(width: 15),
                                              Text(
                                                itemList[index].productName,
                                                style: kStruckTextStyle,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            _formatCurrency
                                                .format(itemList[index].price),
                                            style: kStruckTextStyle,
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            FooterOrderList(
                              dicount: 0,
                              grandTotal: getGrandTotal(),
                              subtotal: getSubTotal(),
                              tax: 0.1,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Pembayaran',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _formatCurrency.format(pembayaran),
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Kembali',
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _formatCurrency.format(kembali),
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 2,
                            ),
                            Text(
                              'Terima Kasih Atas Kunjungan Anda',
                              style: kStruckTextStyle,
                            ),
                            Divider(
                              thickness: 2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Container(
                  width: 1.5,
                  color: Colors.grey,
                ),

                //RIGHSIDE
                Expanded(
                    flex: 2,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.check_circle_outline,
                            size: 200,
                            color: Colors.green,
                          ),
                          Text(
                            'Pembayaran Berhasil',
                            style: TextStyle(fontSize: 35),
                          ),
                          SizedBox(height: 100),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                GestureDetector(
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 300,
                                    height: 70,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                      width: 4,
                                      color: Colors.blueAccent,
                                    )),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.print,
                                            size: 40,
                                            color: Colors.blue,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Duplikat Kwitansi',
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {},
                                ),
                                GestureDetector(
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 300,
                                    height: 70,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                      width: 4,
                                      color: Colors.green,
                                    )),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.done,
                                            size: 40,
                                            color: Colors.green,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Selesai',
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    // TODO:Hapus record Apabila PostedOrder dan Clear Apabila OrderList
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double getGrandTotal() {
    double _grandTotal = 0;
    double _tax = 0;
    double _subtotal;

    itemList.forEach((order) {
      _subtotal = order.quantity * order.price;
      _grandTotal = _grandTotal + _subtotal;
    });
    _subtotal = _grandTotal;

    _tax = _subtotal * 0.1;
    _grandTotal = _subtotal + _tax;
    return _grandTotal;
  }

  double getSubTotal() {
    double _grandTotal = 0;
    double _tax = 0;
    double _subtotal;

    itemList.forEach((order) {
      _subtotal = order.quantity * order.price;
      _grandTotal = _grandTotal + _subtotal;
    });
    _subtotal = _grandTotal;

    return _subtotal;
  }
}
