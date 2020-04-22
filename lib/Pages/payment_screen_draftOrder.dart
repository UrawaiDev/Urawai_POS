import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/Models/orderList.dart';
import 'package:urawai_pos/Models/postedOrder.dart';
import 'package:urawai_pos/Models/transaction.dart';
import 'package:urawai_pos/Pages/mainPage.dart';
import 'package:urawai_pos/Pages/payment_success.dart';
import 'package:urawai_pos/Provider/postedOrder_provider.dart';
import 'package:urawai_pos/Provider/transactionOrder_provider.dart';
import 'package:urawai_pos/Widgets/costum_DialogBox.dart';
import 'package:urawai_pos/Widgets/detail_itemOrder.dart';
import 'package:urawai_pos/Widgets/footer_OrderList.dart';
import 'package:urawai_pos/constans/utils.dart';

class PaymentScreenDraftOrder extends StatelessWidget {
  final PostedOrder postedOrder;
  static const String postedOrderBox = "Posted_Order";
  static const String routeName = "PaymentScreenDraftOrder";

  final _formatCurrency = NumberFormat.currency(
    symbol: 'Rp.',
    locale: 'en_US',
    decimalDigits: 0,
  );

  PaymentScreenDraftOrder(this.postedOrder);

  @override
  Widget build(BuildContext context) {
    var postedOrderProvider =
        Provider.of<PostedOrderProvider>(context, listen: false);

    postedOrderProvider.postedorder = postedOrder;

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Container(
        child: SafeArea(
          child: Scaffold(
            body: Container(
              child: Row(
                children: <Widget>[
                  //LEFT SIDE
                  Expanded(
                      child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(5, 20, 5, 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Consumer<PostedOrderProvider>(
                                  builder: (context, state, _) => Text(
                                    'Pesanan (${state.postedOrder.orderList.length})',
                                    style: kHeaderTextStyle,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    postedOrderProvider.addItem(
                                      postedOrder,
                                      OrderList(
                                        productName: 'Nasi Putih',
                                        price: 5000,
                                        quantity: 2,
                                      ),
                                    );
                                  },
                                ),
                                GestureDetector(
                                  onTap: () {
                                    var box = Hive.box<PostedOrder>(
                                        MainPage.postedBoxName);
                                    box.put(
                                        postedOrderProvider.postedOrder.id,
                                        PostedOrder(
                                          id: postedOrderProvider
                                              .postedOrder.id,
                                          orderDate:
                                              DateTime.now().toIso8601String(),
                                          discount: 0,
                                          grandTotal:
                                              postedOrderProvider.grandTotal,
                                          subtotal:
                                              postedOrderProvider.subTotal,
                                          orderList: postedOrderProvider
                                              .postedOrder.orderList,
                                          paidStatus: PaidStatus.UnPaid,
                                        ));

                                    Provider.of<PostedOrderProvider>(context,
                                            listen: false)
                                        .resetFinalPayment();
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 120,
                                    height: 40,
                                    color: Colors.blue,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.arrow_back,
                                          size: 25,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Kembali',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        //ORDERED ITEM LIST

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Consumer<PostedOrderProvider>(
                              builder: (context, state, _) => Container(
                                child: ListView.builder(
                                    itemCount:
                                        state.postedOrder.orderList.length,
                                    itemBuilder: (context, index) {
                                      var item =
                                          state.postedOrder.orderList[index];
                                      return DetailItemOrder(
                                        productName: item.productName,
                                        price: item.price,
                                        quantity: item.quantity,
                                        childWidget: IconButton(
                                          icon: Icon(Icons.delete),
                                          color: Colors.red,
                                          iconSize: 35,
                                          onPressed: () {
                                            CostumDialogBox.showCostumDialogBox(
                                                context: context,
                                                icon: Icons.delete,
                                                iconColor: Colors.red,
                                                title: 'Konfirmasi',
                                                contentString:
                                                    'Pesanan ${item.productName} akan diHapus?',
                                                confirmButtonTitle: 'Hapus',
                                                onConfirmPressed: () {
                                                  postedOrderProvider
                                                      .removeItemFromList(
                                                          index);
                                                  Navigator.pop(context);
                                                });
                                          },
                                        ),
                                        onPlusButtonTap: () =>
                                            postedOrderProvider
                                                .incrementQuantity(index),
                                        onMinusButtonTap: () =>
                                            postedOrderProvider
                                                .decrementQuantity(index),
                                      );
                                    }),
                              ),
                            ),
                          ),
                        ),

                        Consumer<PostedOrderProvider>(
                          builder: (context, stateProvider, _) => Container(
                            child: Column(
                              children: <Widget>[
                                FooterOrderList(
                                  dicount: 0,
                                  grandTotal: stateProvider.grandTotal,
                                  subtotal: stateProvider.subTotal,
                                  tax: 0.1,
                                ),
                                Divider(
                                  thickness: 2.5,
                                ),
                                GestureDetector(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    width: 400,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Text('Void Traksaksi',
                                        style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  onTap: () =>
                                      CostumDialogBox.showCostumDialogBox(
                                          context: context,
                                          icon: Icons.delete,
                                          iconColor: Colors.red,
                                          title: 'Konfirmasi',
                                          contentString:
                                              'Anda akan menghapus transaksi ini?',
                                          confirmButtonTitle: 'Hapus',
                                          onConfirmPressed: () {
                                            Provider.of<TransactionOrderProvider>(
                                                    context,
                                                    listen: false)
                                                .addTransactionOrder(
                                                    stateProvider:
                                                        stateProvider,
                                                    paymentStatus:
                                                        PaymentStatus.VOID,
                                                    paymentType:
                                                        PaymentType.CASH);

                                            stateProvider.deletePostedOrder(
                                                stateProvider.postedOrder.id);
                                            stateProvider.resetFinalPayment();
                                            Navigator.pop(
                                                context); //close dialogBOx
                                            Navigator.pop(
                                                context); //Back to HomePage Screen
                                          }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),

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
                                child: Consumer<PostedOrderProvider>(
                                  builder: (context, postedOrderState, _) =>
                                      Column(
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
                                                          postedOrderState
                                                              .grandTotal),
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
                                                          postedOrderState
                                                              .finalPayment),
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
                                                      postedOrderState.finalPayment !=
                                                                  0 &&
                                                              postedOrderState
                                                                      .finalPayment >
                                                                  postedOrderState
                                                                      .grandTotal
                                                          ? _formatCurrency.format(
                                                              postedOrderState
                                                                      .finalPayment -
                                                                  postedOrderState
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
                                  ),
                                ),
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
          Consumer<PostedOrderProvider>(
            builder: (context, state, _) => Column(
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
                              state.finalPayment = 0;
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
                        state.finalPayment = 0;
                      }),
                      SizedBox(width: 10),
                    ],
                  ),
                )
              ],
            ),
          ),
          //Right Side
          Consumer<PostedOrderProvider>(
            builder: (context, state, _) => Expanded(
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
                          onTap: () => state.finalPayment = 50000,
                        ),
                        _buttonPaymentSuggestion(
                          text: '100K',
                          context: context,
                          onTap: () => state.finalPayment = 100000,
                        ),
                        // _buttonPaymentSuggestion(
                        //   text: '300K',
                        //   context: context,
                        //   onTap: () => state.finalPayment = 300000,
                        // ),
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
                              Provider.of<TransactionOrderProvider>(context,
                                      listen: false)
                                  .addTransactionOrder(
                                stateProvider: state,
                                paymentStatus: PaymentStatus.COMPLETED,
                                paymentType: PaymentType.CASH,
                              );

                              //delete Posted Order
                              Hive.box<PostedOrder>(MainPage.postedBoxName)
                                  .delete(state.postedOrder.id);

                              //Navigate to Payment Success Screen
                              Navigator.pushNamed(
                                  context, PaymentSuccess.routeName,
                                  arguments: state);
                            },
                          );
                        } else
                          print('Pastikan sudah di bayar');
                      }),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }

  void _keyPadNumber(String inputValue, PostedOrderProvider state) {
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
