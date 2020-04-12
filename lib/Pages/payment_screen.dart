import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/Models/orderList.dart';
import 'package:urawai_pos/Models/postedOrder.dart';
import 'package:urawai_pos/Provider/postedOrder_provider.dart';
import 'package:urawai_pos/Widgets/costum_DialogBox.dart';
import 'package:urawai_pos/Widgets/detail_itemOrder.dart';
import 'package:urawai_pos/Widgets/footer_OrderList.dart';
import 'package:urawai_pos/constans/utils.dart';

class PaymentScreen extends StatelessWidget {
  final PostedOrder postedOrder;
  static const String postedOrderBox = "Posted_Order";

  PaymentScreen(this.postedOrder);

  @override
  Widget build(BuildContext context) {
    var postedOrderProvider =
        Provider.of<PostedOrderProvider>(context, listen: false);

    postedOrderProvider.postedOrder = postedOrder;

    return Container(
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
                                  style: headerTextStyle,
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
                                  // postedOrder.orderList.add(OrderList(
                                  //   productName: 'Kerupuk',
                                  //   price: 1500,
                                  // ));
                                },
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
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
                                  itemCount: state.postedOrder.orderList.length,
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
                                              onCancelPressed: () =>
                                                  Navigator.pop(context),
                                              confirmButtonTitle: 'Hapus',
                                              onConfirmPressed: () {
                                                postedOrderProvider
                                                    .removeItemFromList(index);
                                                Navigator.pop(context);
                                              });
                                        },
                                      ),
                                      onPlusButtonTap: () => postedOrderProvider
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

                      // TODO:change bootom button to Void / delete all Posted Order
                      Consumer<PostedOrderProvider>(
                        builder: (context, stateProvider, _) => Container(
                          child: Column(
                            children: <Widget>[
                              FooterOrderList(
                                dicount: 0,
                                grandTotal: stateProvider.getGrandTotal(),
                                subtotal: stateProvider.getSubtotal(),
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
                                        onCancelPressed: () =>
                                            Navigator.pop(context),
                                        contentString:
                                            'Anda akan menghapus transaksi ini?',
                                        confirmButtonTitle: 'Hapus',
                                        onConfirmPressed: () {
                                          Hive.box<PostedOrder>(postedOrderBox)
                                              .delete(
                                                  stateProvider.postedOrder.id);
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                _paymentMethodCard('Cash', Icons.attach_money),
                                _paymentMethodCard(
                                    'Credit/Debit Card', Icons.credit_card),
                                _paymentMethodCard(
                                    'E-Money', Icons.confirmation_number),
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
                                color: Colors.white,
                              ),
                              child: Column(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          color: Colors.yellow,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  'Total Bayar',
                                                  style:
                                                      TextStyle(fontSize: 27),
                                                ),
                                                Text(
                                                  'Rp. 100,0000',
                                                  style:
                                                      TextStyle(fontSize: 27),
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
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  'Pembayaran',
                                                  style:
                                                      TextStyle(fontSize: 27),
                                                ),
                                                Text(
                                                  'Rp. 0',
                                                  style:
                                                      TextStyle(fontSize: 27),
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
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  'Kembalian',
                                                  style:
                                                      TextStyle(fontSize: 27),
                                                ),
                                                Text(
                                                  'Rp. 0',
                                                  style:
                                                      TextStyle(fontSize: 27),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Container(
                                            // color: Color(0xFFf5f6f7),
                                            color: Colors.blue,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.46,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.65,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        SizedBox(width: 10),
                                                        _keypadCard('1'),
                                                        SizedBox(width: 10),
                                                        _keypadCard('2'),
                                                        SizedBox(width: 10),
                                                        _keypadCard('3'),
                                                        SizedBox(width: 10),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10),
                                                    Row(
                                                      children: <Widget>[
                                                        SizedBox(width: 10),
                                                        _keypadCard('4'),
                                                        SizedBox(width: 10),
                                                        _keypadCard('5'),
                                                        SizedBox(width: 10),
                                                        _keypadCard('6'),
                                                        SizedBox(width: 10),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10),
                                                    Row(
                                                      children: <Widget>[
                                                        SizedBox(width: 10),
                                                        _keypadCard('<-'),
                                                        SizedBox(width: 10),
                                                        _keypadCard('0'),
                                                        SizedBox(width: 10),
                                                        _keypadCard('000'),
                                                        SizedBox(width: 10),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                //Right Side
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: 250,
                                                        height: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        //TODO: Design Button
                                                        child: Text(
                                                          'BAYAR',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 30,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )),
                                      ),
                                    ],
                                  )
                                ],
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
    );
  }

  Widget _keypadCard(String title) {
    return Container(
      padding: EdgeInsets.all(8),
      alignment: Alignment.center,
      // color: Color(0xFFfcfcfc),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.amber,
      ),
      width: 150,
      height: 100,
      child: Text(title,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  Widget _paymentMethodCard(String title, IconData icon) {
    return Container(
      alignment: Alignment.center,
      width: 250,
      height: 100,
      decoration: BoxDecoration(
          // color: Colors.yellow,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 40,
          ),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(fontSize: 25),
          )
        ],
      ),
    );
  }
}
