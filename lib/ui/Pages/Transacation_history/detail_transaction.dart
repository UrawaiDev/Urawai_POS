import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:urawai_pos/core/Models/transaction.dart';
import 'package:urawai_pos/core/Services/firestore_service.dart';
import 'package:urawai_pos/ui/Pages/pos/pos_Page.dart';
import 'package:urawai_pos/ui/Widgets/costum_button.dart';
import 'package:urawai_pos/ui/Widgets/footer_OrderList.dart';
import 'package:urawai_pos/ui/utils/constans/const.dart';
import 'package:urawai_pos/ui/utils/constans/formatter.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';
import 'package:urawai_pos/ui/utils/functions/paymentHelpers.dart';

class DetailTransactionPage extends StatelessWidget {
  static const String routeName = '/DetailTransactionPage';

  final String boxKey;

  DetailTransactionPage({@required this.boxKey});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Row(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Container(
                child: _buildDetailTransactionFromFirestore(),
              )),
          Expanded(
              flex: 3,
              child: Container(
                // color: Colors.yellow,
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CostumButton.squareButton(
                        'Cetak Kwitansi',
                        prefixIcon: Icons.print,
                        borderColor: Colors.green,
                      ),
                      SizedBox(height: 20),
                      CostumButton.squareButton(
                        'Kirim Kwitansi',
                        prefixIcon: Icons.share,
                      ),
                      SizedBox(height: 20),
                      CostumButton.squareButton(
                        'Kembali',
                        prefixIcon: Icons.arrow_back,
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    ));
  }

  Widget _buildDetailTransactionFromFirestore() {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirestoreServices().getDocumentByID(kShopName, boxKey),
        builder: (context, document) {
          var data = document.data;

          if (!document.hasData)
            return Center(child: CircularProgressIndicator());
          else
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 1.5,
                  color: Colors.grey,
                )),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Order ID:',
                              style: kPriceTextStyle,
                            ),
                            SizedBox(width: 8),
                            Text(
                              data['id'] ?? '-',
                              style: kPriceTextStyle,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Ref. Order :',
                              style: kPriceTextStyle,
                            ),
                            SizedBox(width: 8),
                            Text(
                              data['referenceOrder'] ?? '-',
                              style: kPriceTextStyle,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Tanggal :',
                              style: kPriceTextStyle,
                            ),
                            SizedBox(width: 8),
                            Text(
                              Formatter.dateFormat(
                                  (data['orderDate'] as Timestamp).toDate()),
                              style: kPriceTextStyle,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Kasir :',
                              style: kPriceTextStyle,
                            ),
                            SizedBox(width: 8),
                            Text(
                              data['cashierName'] ?? '[null]',
                              style: kPriceTextStyle,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Metode Pembayaran:',
                              style: kPriceTextStyle,
                            ),
                            SizedBox(width: 8),
                            Text(
                              PaymentHelper.getPaymentTypeAsString(
                                      data['paymentType']) ??
                                  '[null]',
                              style: kPriceTextStyle,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Status:',
                              style: kPriceTextStyle,
                            ),
                            SizedBox(width: 8),
                            Text(
                              PaymentHelper.getPaymentStatusAsString(
                                      data['paymentStatus']) ??
                                  '[null]',
                              style: kPriceTextStyle,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Jumlah Pesanan:',
                              style: kPriceTextStyle,
                            ),
                            SizedBox(width: 8),
                            Text(
                              (data['orderlist'] as List).length.toString() +
                                      ' Item(s)' ??
                                  '[null]',
                              style: kPriceTextStyle,
                            ),
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
                              itemCount: (data['orderlist'] as List).length,
                              itemBuilder: (context, index) {
                                var itemList =
                                    (data['orderlist'] as List)[index];
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
                                            'x${itemList['quantity']}',
                                            style: kStruckTextStyle,
                                          ),
                                          SizedBox(width: 15),
                                          Text(
                                            itemList['productName'],
                                            style: kStruckTextStyle,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        Formatter.currencyFormat(
                                            itemList['price'] *
                                                itemList['quantity']),
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
                          dicount: data['discount'],
                          grandTotal: data['grandTotal'],
                          subtotal: data['subtotal'],
                          tax: 0.1,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Pembayaran',
                                style: kPriceTextStyle,
                              ),
                              Text(
                                data['paymentType'] == 'PaymentType.CASH'
                                    ? Formatter.currencyFormat(data['tender'])
                                    : Formatter.currencyFormat(
                                        data['grandTotal']),
                                style: kPriceTextStyle,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Kembali',
                                style: kPriceTextStyle,
                              ),
                              Text(
                                data['paymentType'] == 'PaymentType.CASH'
                                    ? Formatter.currencyFormat(
                                        data['change'].toDouble())
                                    : 'Rp. 0',
                                style: kPriceTextStyle,
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
            );
        });
  }

  Widget _buildTransactionItem() {
    var box =
        Hive.box<TransactionOrder>(POSPage.transactionBoxName).get(boxKey);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(
          width: 1.5,
          color: Colors.grey,
        )),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Ref. Order :',
                      style: kPriceTextStyle,
                    ),
                    SizedBox(width: 8),
                    Text(
                      box.referenceOrder ?? '-',
                      style: kPriceTextStyle,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Tanggal :',
                      style: kPriceTextStyle,
                    ),
                    SizedBox(width: 8),
                    Text(
                      Formatter.dateFormat(box.date),
                      style: kPriceTextStyle,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Kasir :',
                      style: kPriceTextStyle,
                    ),
                    SizedBox(width: 8),
                    Text(
                      box.cashierName ?? '[null]',
                      style: kPriceTextStyle,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Metode Pembayaran:',
                      style: kPriceTextStyle,
                    ),
                    SizedBox(width: 8),
                    Text(
                      PaymentHelper.getPaymentType(box.paymentType) ?? '[null]',
                      style: kPriceTextStyle,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Status:',
                      style: kPriceTextStyle,
                    ),
                    SizedBox(width: 8),
                    Text(
                      PaymentHelper.getPaymentStatus(box.paymentStatus) ??
                          '[null]',
                      style: kPriceTextStyle,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Jumlah Pesanan:',
                      style: kPriceTextStyle,
                    ),
                    SizedBox(width: 8),
                    Text(
                      box.itemList.length.toString() + ' Item(s)' ?? '[null]',
                      style: kPriceTextStyle,
                    ),
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
                      itemCount: box.itemList.length,
                      itemBuilder: (context, index) {
                        var itemList = box.itemList;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    'x${itemList[index].quantity}',
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
                                Formatter.currencyFormat(itemList[index].price *
                                    itemList[index].quantity),
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
                  dicount: box.discount,
                  grandTotal: box.grandTotal,
                  subtotal: box.subtotal,
                  tax: 0.1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Pembayaran',
                        style: kPriceTextStyle,
                      ),
                      Text(
                        box.paymentType == PaymentType.CASH
                            ? Formatter.currencyFormat(box.tender)
                            : Formatter.currencyFormat(box.grandTotal),
                        style: kPriceTextStyle,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Kembali',
                        style: kPriceTextStyle,
                      ),
                      Text(
                        box.paymentType == PaymentType.CASH
                            ? Formatter.currencyFormat(box.change)
                            : Formatter.currencyFormat(0),
                        style: kPriceTextStyle,
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
    );
  }
}
