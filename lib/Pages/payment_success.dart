import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/Pages/pos_Page.dart';
import 'package:urawai_pos/Provider/orderList_provider.dart';
import 'package:urawai_pos/Provider/postedOrder_provider.dart';
import 'package:urawai_pos/Widgets/footer_OrderList.dart';
import 'package:urawai_pos/constans/utils.dart';

class PaymentSuccess extends StatelessWidget {
  final List<dynamic> itemList;
  final String cashierName;
  final String referenceOrder;
  final String date;
  final String orderID;
  final double pembayaran;
  final double kembali;
  final dynamic state;

  PaymentSuccess({
    @required this.itemList,
    @required this.cashierName,
    @required this.referenceOrder,
    @required this.date,
    @required this.orderID,
    @required this.pembayaran,
    @required this.kembali,
    @required this.state,
  });

  final _formatCurrency = NumberFormat.currency(
    symbol: 'Rp.',
    locale: 'en_US',
    decimalDigits: 0,
  );

  static const String routeName = "PaymentSuccessPage";

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
                                Text(referenceOrder ?? '-'),
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
                                Text(cashierName ?? 'Cashier Not State'),
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
                              dicount: state.discountTotal,
                              grandTotal: state.grandTotal,
                              subtotal: state.subTotal,
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
                                    style: kGrandTotalTextStyle,
                                  ),
                                  Text(
                                    _formatCurrency.format(pembayaran),
                                    style: kGrandTotalTextStyle,
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
                                    style: kGrandTotalTextStyle,
                                  ),
                                  Text(
                                    _formatCurrency.format(kembali),
                                    style: kGrandTotalTextStyle,
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
                                    //reset variable
                                    Provider.of<PostedOrderProvider>(context,
                                            listen: false)
                                        .resetFinalPayment();
                                    Provider.of<OrderListProvider>(context,
                                            listen: false)
                                        .resetFinalPayment();
                                    Provider.of<OrderListProvider>(context,
                                            listen: false)
                                        .resetOrderList();

                                    //Navigate to Main Page
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => POSPage()),
                                      ModalRoute.withName('/pos'),
                                    );
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
}
