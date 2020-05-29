import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/core/Models/transaction.dart';
import 'package:urawai_pos/core/Models/users.dart';
import 'package:urawai_pos/core/Provider/orderList_provider.dart';
import 'package:urawai_pos/core/Provider/postedOrder_provider.dart';
import 'package:urawai_pos/core/Services/firebase_auth.dart';
import 'package:urawai_pos/ui/Pages/pos/pos_Page.dart';
import 'package:urawai_pos/ui/Widgets/costum_button.dart';
import 'package:urawai_pos/ui/Widgets/footer_OrderList.dart';
import 'package:urawai_pos/ui/utils/constans/formatter.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';

class PaymentSuccess extends StatelessWidget {
  final List<dynamic> itemList;
  final double pembayaran;
  final double kembali;
  final dynamic state;
  final PaymentType paymentType;
  final locatorAuth = GetIt.I<FirebaseAuthentication>();

  PaymentSuccess({
    @required this.itemList,
    @required this.paymentType,
    @required this.pembayaran,
    @required this.kembali,
    @required this.state,
  });

  @override
  Widget build(BuildContext context) {
    String _cashierName;
    String _referenceOrder;
    DateTime _orderDate;

    //Get header information
    if (state is OrderListProvider) {
      var x = state as OrderListProvider;
      _cashierName = x.cashierName;
      _referenceOrder = x.referenceOrder;
      _orderDate = x.orderDate;
    } else if (state is PostedOrderProvider) {
      var x = state as PostedOrderProvider;
      _cashierName = x.postedOrder.cashierName;
      _referenceOrder = x.postedOrder.refernceOrder;
      _orderDate = x.postedOrder.dateTime;
    }

    return WillPopScope(
      onWillPop: () => _onTransactionComplete(context),
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
                  flex: 2,
                  child: Container(
                    // color: Colors.blue,
                    padding: EdgeInsets.fromLTRB(10, 20, 5, 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FutureBuilder<Users>(
                                future: locatorAuth.currentUserXXX,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData ||
                                      snapshot.connectionState ==
                                          ConnectionState.waiting)
                                    return Text(
                                      'Loading',
                                      style: kPriceTextStyle,
                                    );

                                  return Text(
                                      snapshot.data.shopName.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ));
                                }),
                            Divider(
                              thickness: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Ref. Order:'),
                                SizedBox(width: 8),
                                Text(_referenceOrder ?? '[null]'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Tanggal:'),
                                SizedBox(width: 8),
                                Text(Formatter.dateFormat(_orderDate)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Kasir:'),
                                SizedBox(width: 8),
                                Text(_cashierName ?? '[null]'),
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
                                                'x${itemList[index].quantity}',
                                                style: kStruckTextStyle,
                                              ),
                                              SizedBox(width: 15),
                                              Container(
                                                width: 250,
                                                child: Text(
                                                  itemList[index].productName,
                                                  style: kStruckTextStyle,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            child: Text(
                                              Formatter.currencyFormat(
                                                  itemList[index].price *
                                                      itemList[index].quantity),
                                              style: kStruckTextStyle,
                                            ),
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
                              vat: state.taxFinal,
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
                                    paymentType == PaymentType.CASH
                                        ? Formatter.currencyFormat(pembayaran)
                                        : Formatter.currencyFormat(
                                            state.grandTotal),
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
                                    paymentType == PaymentType.CASH
                                        ? Formatter.currencyFormat(kembali)
                                        : Formatter.currencyFormat(0),
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
                            child: Column(
                              children: <Widget>[
                                CostumButton.squareButton('Cetak Kwitansi',
                                    prefixIcon: Icons.print),
                                SizedBox(height: 20),
                                CostumButton.squareButton(
                                  'Selesai',
                                  prefixIcon: Icons.done,
                                  borderColor: Colors.green,
                                  onTap: () => _onTransactionComplete(context),
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

  Future<void> _onTransactionComplete(BuildContext context) {
    //reset variable
    Provider.of<PostedOrderProvider>(context, listen: false)
        .resetFinalPayment();
    Provider.of<OrderListProvider>(context, listen: false).resetFinalPayment();
    Provider.of<OrderListProvider>(context, listen: false).resetOrderList();

    //Navigate to Main Page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => POSPage()),
      ModalRoute.withName('/pos'),
    );

    return null;
  }
}
