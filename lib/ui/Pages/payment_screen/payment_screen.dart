import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/core/Models/postedOrder.dart';
import 'package:urawai_pos/core/Models/transaction.dart';
import 'package:urawai_pos/core/Provider/orderList_provider.dart';
import 'package:urawai_pos/core/Provider/postedOrder_provider.dart';
import 'package:urawai_pos/core/Provider/transactionOrder_provider.dart';
import 'package:urawai_pos/ui/Pages/payment_success/payment_success.dart';
import 'package:urawai_pos/ui/Pages/pos/pos_Page.dart';
import 'package:urawai_pos/ui/Widgets/costum_DialogBox.dart';
import 'package:urawai_pos/ui/Widgets/left_paymentScreen_OrderList.dart';
import 'package:urawai_pos/ui/Widgets/left_paymentScreen_postedOrder.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';

class PaymentScreen extends StatelessWidget {
  final dynamic itemList;
  static const String postedOrderBox = "Posted_Order";
  static const String routeName = "PaymentScreen";

  final _formatCurrency = NumberFormat.currency(
    symbol: 'Rp.',
    locale: 'en_US',
    decimalDigits: 0,
  );

  PaymentScreen(this.itemList);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Container(
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Container(
              child: Row(
                children: <Widget>[
                  //LEFT SIDE
                  (itemList is PostedOrder)
                      ? PaymentScreenLeftPostedOrder(itemList)
                      : PaymentScreenLeftOrderList(itemList),

                  //RIGHT SIDE
                  Expanded(
                      flex: 2,
                      child: Container(
                          // color: Colors.blue,
                          child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  _paymentMethodCard(
                                    'Cash',
                                    Icons.attach_money,
                                    Color(0xFFebf3fe),
                                  ),
                                  _paymentMethodCard(
                                    'Credit/Debit Card',
                                    Icons.credit_card,
                                    Colors.white,
                                  ),
                                  _paymentMethodCard(
                                    'E-Money',
                                    Icons.confirmation_number,
                                    Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Expanded(
                              flex: 6,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                  color: Color(0xFFf5f6f7),
                                ),
                                child: Consumer2<PostedOrderProvider,
                                        OrderListProvider>(
                                    builder: (context, statePostedOrder,
                                        stateOrderList, _) {
                                  var state;
                                  if (itemList is PostedOrder)
                                    state = statePostedOrder;
                                  else
                                    state = stateOrderList;

                                  return Column(
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  border: Border.all(
                                                    color: Colors.blue,
                                                    width: 3,
                                                  )),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      'Total Bayar',
                                                      style: TextStyle(
                                                        fontSize: 27,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      _formatCurrency.format(
                                                          state.grandTotal),
                                                      style: TextStyle(
                                                        fontSize: 27,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                color: Colors.blue,
                                                width: 3,
                                              )),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      'Pembayaran',
                                                      style: TextStyle(
                                                          fontSize: 27),
                                                    ),
                                                    Text(
                                                      _formatCurrency.format(
                                                          state.finalPayment),
                                                      style: TextStyle(
                                                          fontSize: 27),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                color: Colors.blue,
                                                width: 3,
                                              )),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      'Kembali',
                                                      style: TextStyle(
                                                          fontSize: 27),
                                                    ),
                                                    // Only return value when bigger dan grandTotal
                                                    Text(
                                                      state.finalPayment != 0 &&
                                                              state.finalPayment >
                                                                  state
                                                                      .grandTotal
                                                          ? _formatCurrency.format(
                                                              state.finalPayment -
                                                                  state
                                                                      .grandTotal)
                                                          : 'Rp. 0',
                                                      style: TextStyle(
                                                          fontSize: 27),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          // keyPadArea(context),
                                        ],
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: keyPadArea(context),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding keyPadArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
          // color: Color(0xFFf5f6f7),

          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Consumer2<PostedOrderProvider, OrderListProvider>(
              builder: (context, statePostedOrder, stateOrderList, _) {
            var state;
            if (itemList is PostedOrder)
              state = statePostedOrder;
            else
              state = stateOrderList;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 10),
                      _keypadCard('1', () => _keyPadNumber('1', state)),
                      SizedBox(width: 10),
                      _keypadCard('2', () => _keyPadNumber('2', state)),
                      SizedBox(width: 10),
                      _keypadCard('3', () => _keyPadNumber('3', state)),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 10),
                      _keypadCard('4', () => _keyPadNumber('4', state)),
                      SizedBox(width: 10),
                      _keypadCard('5', () => _keyPadNumber('5', state)),
                      SizedBox(width: 10),
                      _keypadCard('6', () => _keyPadNumber('6', state)),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 10),
                      _keypadCard('7', () => _keyPadNumber('7', state)),
                      SizedBox(width: 10),
                      _keypadCard('8', () => _keyPadNumber('8', state)),
                      SizedBox(width: 10),
                      _keypadCard('9', () => _keyPadNumber('9', state)),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          if (state.totalPayment.isNotEmpty) {
                            var result = state.totalPayment
                                .substring(0, state.totalPayment.length - 1);
                            state.totalPayment = result;
                            if (result.isNotEmpty) {
                              state.finalPayment = double.parse(result);
                            } else
                              state.finalPayment = 0.0;
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[400],
                          ),
                          width: 150,
                          height: 80,
                          child: Icon(Icons.backspace),
                        ),
                      ),
                      SizedBox(width: 10),
                      _keypadCard('0', () => _keyPadNumber('0', state)),
                      SizedBox(width: 10),
                      _keypadCard('C', () {
                        state.totalPayment = '';
                        state.finalPayment = 0.0;
                      }),
                      SizedBox(width: 10),
                    ],
                  ),
                )
              ],
            );
          }),
          //Right Side
          Consumer2<PostedOrderProvider, OrderListProvider>(
              builder: (context, statePostedOrder, stateOrderList, _) {
            var state;
            if (itemList is PostedOrder)
              state = statePostedOrder;
            else
              state = stateOrderList;

            return Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: _buttonPayment(
                        text: Text(
                          'Uang Pas',
                          style: kProductNameSmallScreenTextStyle,
                        ),
                        color: Colors.grey[300],
                        onTap: () {
                          state.finalPayment = state.grandTotal;
                        }),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: <Widget>[
                        _buttonPaymentSuggestion(
                          text: '50K',
                          context: context,
                          onTap: () => state.finalPayment = 50000.0,
                        ),
                        _buttonPaymentSuggestion(
                          text: '100K',
                          context: context,
                          onTap: () => state.finalPayment = 100000.0,
                        ),
                      ],
                    ),
                  ),
                  _buttonPayment(
                      color: Colors.blue,
                      text: Text(
                        'BAYAR',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        if (state.finalPayment != 0 &&
                            state.finalPayment >= state.grandTotal) {
                          CostumDialogBox.showCostumDialogBox(
                            context: context,
                            title: 'Konfirmasi',
                            icon: Icons.receipt,
                            iconColor: Colors.blue,
                            contentString:
                                'Pembayaran telah dilakukan dan Cetak Kwitansi, Lanjutkan?',
                            confirmButtonTitle: 'Proses',
                            onConfirmPressed: () {
                              //Add Transaction
                              Provider.of<TransactionOrderProvider>(context,
                                      listen: false)
                                  .addTransactionOrder(
                                stateProvider: state,
                                paymentStatus: PaymentStatus.COMPLETED,
                                paymentType: PaymentType.CASH,
                              );

                              //delete Posted Order
                              if (itemList is PostedOrder) {
                                Hive.box<PostedOrder>(POSPage.postedBoxName)
                                    .delete(state.postedOrder.id);
                              }

                              //Navigate to Payment Success Screen
                              Navigator.pushNamed(
                                  context, PaymentSuccess.routeName,
                                  arguments: state);
                            },
                          );
                        } else {
                          print('Pastikan sudah di bayar');
                          CostumDialogBox.showDialogInformation(
                              title: 'Informasi',
                              context: context,
                              contentText:
                                  'Pastikan pembayaran telah dilakukan.',
                              icon: Icons.warning,
                              iconColor: Colors.yellow,
                              onTap: () => Navigator.pop(context));
                        }
                      }),
                ],
              ),
            );
          })
        ],
      )),
    );
  }

  void _keyPadNumber(String inputValue, dynamic state) {
    var currentValue = state.totalPayment;
    state.totalPayment = currentValue + inputValue;
    state.finalPayment = double.parse(state.totalPayment);
  }

  Padding _buttonPayment({Text text, Color color, Function onTap}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          width: 300,
          height: 100,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: text,
        ),
      ),
    );
  }

  Widget _buttonPaymentSuggestion(
      {String text, Function onTap, BuildContext context}) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            width: 80,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              text,
              style: screenWidth > 1024
                  ? kProductNameBigScreenTextStyle
                  : kProductNameSmallScreenTextStyle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _keypadCard(String title, Function onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[400],
        ),
        width: 150,
        height: 80,
        child: Text(title,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }

  Widget _paymentMethodCard(String title, IconData icon, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey,
              )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 35,
              ),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(fontSize: 20),
              )
            ],
          ),
        ),
      ),
    );
  }
}
