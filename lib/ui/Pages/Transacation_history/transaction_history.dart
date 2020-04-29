import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/core/Models/transaction.dart';
import 'package:urawai_pos/core/Provider/general_provider.dart';
import 'package:urawai_pos/ui/Pages/pos/pos_Page.dart';
import 'package:urawai_pos/ui/utils/constans/formatter.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';
import 'package:urawai_pos/ui/utils/functions/paymentHelpers.dart';

class TransactionHistoryPage extends StatelessWidget {
  static const String routeName = '/transactionHistory';

  @override
  Widget build(BuildContext context) {
    var box = Hive.box<TransactionOrder>(POSPage.transactionBoxName);

    return SafeArea(
        child: Scaffold(
      body: Container(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.blue,
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                // color: Colors.yellow,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Riwayat Transaksi',
                              style: kProductNameBigScreenTextStyle),
                          SizedBox(height: 20),
                          Row(
                            children: <Widget>[
                              Text('Cari Berdasarkan Tanggal',
                                  style: kProductNameSmallScreenTextStyle),
                              SizedBox(width: 15),
                              GestureDetector(
                                child: FaIcon(
                                  FontAwesomeIcons.calendarDay,
                                  color: Colors.blue,
                                  size: 35,
                                ),
                                onTap: () async {
                                  DateTime selectedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2030));

                                  Provider.of<GeneralProvider>(context,
                                          listen: false)
                                      .selectedDate = selectedDate;
                                },
                              ),
                              SizedBox(width: 15),
                              GestureDetector(
                                child: FaIcon(
                                  FontAwesomeIcons.syncAlt,
                                  color: Colors.green,
                                  size: 35,
                                ),
                                onTap: () async {
                                  Provider.of<GeneralProvider>(context,
                                          listen: false)
                                      .selectedDate = null;
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                      (box.length == 0)
                          ? Expanded(
                              child: Container(
                              alignment: Alignment.center,
                              child: Text("Belum Anda Transasksi",
                                  style: kProductNameBigScreenTextStyle),
                            ))
                          : Expanded(
                              child: Consumer<GeneralProvider>(
                                builder: (context, state, _) => GridView.count(
                                    shrinkWrap: true,
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 20,
                                    crossAxisSpacing: 15,
                                    children: _loadTransactionList(box, state)),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  List<Widget> _loadTransactionList(
      Box<TransactionOrder> box, GeneralProvider state) {
    if (state.selectedDate == null) {
      print('null date');
      var result = box.values
          .map((itemList) => _buildCardTransaction(itemList))
          .toList();
      return result;
    } else {
      print('selected date');
      var result = box.values
          .where((item) {
            bool result = DateFormat("dMy").format(item.date) ==
                DateFormat("dMy").format(state.selectedDate);
            return result;
          })
          .map((itemList) => _buildCardTransaction(itemList))
          .toList();

      if (result.length == 0) {
        return [
          Container(
            alignment: Alignment.center,
            child: Text("Belum Anda Transasksi",
                style: kProductNameBigScreenTextStyle),
          )
        ];
      } else
        return result;
    }
  }

  Container _buildCardTransaction(TransactionOrder item) {
    return Container(
      decoration: BoxDecoration(
        color: cardBGColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Order ID:',
                  style: kPriceTextStyle,
                ),
                Text(
                  item.id,
                  style: kPriceTextStyle,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Waktu:',
                  style: kPriceTextStyle,
                ),
                Text(
                  Formatter.dateFormat(item.date),
                  style: kPriceTextStyle,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Pembayaran:',
                  style: kPriceTextStyle,
                ),
                Text(
                  PaymentHelper.getPaymentType(item.paymentType),
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
                Text(
                  PaymentHelper.getPaymentStatus(item.paymentStatus),
                  style: kPriceTextStyle,
                ),
              ],
            ),
            Divider(
              color: item.paymentStatus == PaymentStatus.VOID
                  ? Colors.red
                  : item.paymentStatus == PaymentStatus.PENDING
                      ? Colors.blue
                      : Colors.green,
              thickness: 2,
            ),
            Text(
              'Nama Kasir:',
              style: kPriceTextStyle,
            ),
            Text(
              item.cashierName,
              style: kPriceTextStyle,
            ),
            SizedBox(height: 5),
            Text(
              'Transaksi:',
              style: kPriceTextStyle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  Formatter.currencyFormat(item.grandTotal),
                  style: kProductNameBigScreenTextStyle,
                ),
                Icon(
                  Icons.info,
                  color: Colors.blue,
                  size: 25,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
