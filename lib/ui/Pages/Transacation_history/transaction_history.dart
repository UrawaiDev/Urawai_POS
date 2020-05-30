import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/core/Models/transaction.dart';
import 'package:urawai_pos/core/Models/users.dart';
import 'package:urawai_pos/core/Provider/general_provider.dart';
import 'package:urawai_pos/core/Services/firestore_service.dart';
import 'package:urawai_pos/ui/Widgets/costum_DialogBox.dart';
import 'package:urawai_pos/ui/Widgets/drawerMenu.dart';
import 'package:urawai_pos/ui/Widgets/loading_card.dart';
import 'package:urawai_pos/ui/utils/constans/formatter.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';
import 'package:urawai_pos/ui/utils/functions/getCurrentUser.dart';
import 'package:urawai_pos/ui/utils/functions/paymentHelpers.dart';
import 'package:date_range_picker/date_range_picker.dart' as dateRangePicker;
import 'package:urawai_pos/ui/utils/functions/routeGenerator.dart';

class TransactionHistoryPage extends StatelessWidget {
  final FirestoreServices _firestoreServices = FirestoreServices();

  @override
  Widget build(BuildContext context) {
    final generalProvider =
        Provider.of<GeneralProvider>(context, listen: false);
    final firebaseUser = Provider.of<FirebaseUser>(context);
    bool isLogin = firebaseUser != null;

    return SafeArea(
        child: FutureBuilder<Users>(
            future: isLogin
                ? CurrentUserLoggedIn.getCurrentUser(firebaseUser.uid)
                : null,
            builder: (context, snapshot) {
              Users currentUser = snapshot.data;
              if (snapshot.hasError)
                return Scaffold(
                  body: Center(
                    child: Text(snapshot.error.toString(),
                        style: kProductNameBigScreenTextStyle),
                  ),
                );
              if (!snapshot.hasData ||
                  snapshot.connectionState == ConnectionState.waiting)
                return Scaffold(
                  body: LoadingCard(),
                );

              return Scaffold(
                appBar: AppBar(
                  title: Text('Riwayat Transasksi'),
                ),
                drawer: Drawer(
                  child: DrawerMenu(currentUser),
                ),
                body: Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('Cari Berdasarkan Tanggal:',
                                            style:
                                                kProductNameSmallScreenTextStyle),
                                        Row(
                                          children: <Widget>[
                                            Consumer<GeneralProvider>(
                                                builder: (_, value, __) {
                                              String text;
                                              if (value.selectedDate == null ||
                                                  value.selectedDate.isEmpty)
                                                text = 'Semua Transaksi';
                                              else if (value
                                                      .selectedDate.length ==
                                                  1)
                                                text = DateFormat('d-M-y')
                                                    .format(
                                                        value.selectedDate[0]);
                                              else if (value
                                                      .selectedDate.length ==
                                                  2)
                                                text = DateFormat('d-M-y')
                                                        .format(value
                                                            .selectedDate[0]) +
                                                    ' s/d ' +
                                                    DateFormat('d-M-y').format(
                                                        value.selectedDate[1]);

                                              return Text(
                                                'Tanggal: $text',
                                                style:
                                                    kProductNameSmallScreenTextStyle,
                                              );
                                            }),
                                            SizedBox(width: 20),
                                            GestureDetector(
                                              child: FaIcon(
                                                FontAwesomeIcons.calendarDay,
                                                color: Colors.blue,
                                                size: 35,
                                              ),
                                              onTap: () async {
                                                var pickedDate =
                                                    await dateRangePicker
                                                        .showDatePicker(
                                                  context: context,
                                                  initialFirstDate:
                                                      DateTime.now(),
                                                  initialLastDate:
                                                      DateTime.now().add(
                                                          Duration(days: 7)),
                                                  firstDate: DateTime(2020),
                                                  lastDate: DateTime(2040),
                                                );
                                                if (pickedDate != null &&
                                                    pickedDate.length == 2) {
                                                  generalProvider.selectedDate =
                                                      pickedDate;
                                                } else if (pickedDate != null &&
                                                    pickedDate.length == 1) {
                                                  generalProvider.selectedDate =
                                                      pickedDate;
                                                }
                                              },
                                            ),
                                            SizedBox(width: 20),
                                            GestureDetector(
                                              child: FaIcon(
                                                FontAwesomeIcons.syncAlt,
                                                color: Colors.green,
                                                size: 35,
                                              ),
                                              onTap: () {
                                                Provider.of<GeneralProvider>(
                                                        context,
                                                        listen: false)
                                                    .selectedDate = [];
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            'Jumlah List:',
                                            style:
                                                kProductNameSmallScreenTextStyle,
                                          ),
                                          SizedBox(width: 15),
                                          Consumer<GeneralProvider>(
                                            builder: (_, value, __) => FutureBuilder<
                                                    List<TransactionOrder>>(
                                                future: value
                                                        .selectedDate.isEmpty
                                                    ? _firestoreServices
                                                        .getAllTransactionOrder(
                                                            currentUser
                                                                .shopName)
                                                    : _firestoreServices
                                                        .getDocumentByDate(
                                                            currentUser
                                                                .shopName,
                                                            value.selectedDate),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasError)
                                                    return Text(
                                                      'An Error has Occured ${snapshot.error}',
                                                      style: kPriceTextStyle,
                                                    );
                                                  else if (!snapshot.hasData)
                                                    return Text(
                                                      '0',
                                                      style: kPriceTextStyle,
                                                    );
                                                  switch (snapshot
                                                      .connectionState) {
                                                    case ConnectionState
                                                        .waiting:
                                                      return CircularProgressIndicator();

                                                      break;
                                                    default:
                                                      return Text(
                                                        snapshot.data.length
                                                                .toString() ??
                                                            ['null'],
                                                        style:
                                                            kProductNameSmallScreenTextStyle,
                                                      );
                                                  }
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Consumer<GeneralProvider>(
                                  builder: (_, value, __) =>
                                      FutureBuilder<List<TransactionOrder>>(
                                    future: value.selectedDate.isEmpty
                                        ? _firestoreServices
                                            .getAllTransactionOrder(
                                                currentUser.shopName)
                                        : _firestoreServices.getDocumentByDate(
                                            currentUser.shopName,
                                            value.selectedDate),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError)
                                        return Text(
                                          'An Error has Occured ${snapshot.error}',
                                          style: kPriceTextStyle,
                                        );
                                      if (!snapshot.hasData ||
                                          snapshot.connectionState ==
                                              ConnectionState.waiting)
                                        return Expanded(
                                          child: Container(
                                              alignment: Alignment.center,
                                              child:
                                                  CircularProgressIndicator()),
                                        );

                                      if (snapshot.data.isEmpty)
                                        return Expanded(
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Belum Ada Transaksi',
                                              style:
                                                  kProductNameBigScreenTextStyle,
                                            ),
                                          ),
                                        );
                                      return Expanded(
                                        child: GridView.count(
                                          crossAxisCount: 4,
                                          children: snapshot.data
                                              .map((data) =>
                                                  _buildCardFromFirestore(data))
                                              .toList(),
                                        ),
                                      );
                                    },
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
              );
            }));
  }

  Container _buildCardFromFirestore(TransactionOrder item) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFFf4f4f4),
        border: Border.all(color: Colors.black),
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
              item.cashierName ?? '[null]',
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
                Builder(
                  builder: (context) => Row(
                    children: <Widget>[
                      GestureDetector(
                        child: Icon(
                          Icons.info,
                          color: Colors.blue,
                          size: 25,
                        ),
                        onTap: () => Navigator.pushNamed(
                          context,
                          RouteGenerator.kRouteDetailTransaction,
                          arguments: item.id,
                        ),
                      ),
                      SizedBox(width: 5),
                      GestureDetector(
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 25,
                          ),
                          onTap: () {
                            CostumDialogBox.showCostumDialogBox(
                                title: 'Konfirmasi',
                                context: context,
                                contentString:
                                    'Anda Akan menhapus Transaksi ID.[${item.id}], Hapus ?',
                                icon: Icons.delete,
                                iconColor: Colors.red,
                                confirmButtonTitle: 'Hapus',
                                onConfirmPressed: () async {
                                  var currentUser =
                                      await CurrentUserLoggedIn.currentUser;
                                  _firestoreServices.deleteTransaction(
                                      currentUser.shopName, item.id);
                                  Navigator.pop(context);
                                });
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
