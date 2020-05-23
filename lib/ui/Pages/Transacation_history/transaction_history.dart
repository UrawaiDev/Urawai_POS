import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/core/Provider/general_provider.dart';
import 'package:urawai_pos/core/Services/firestore_service.dart';
import 'package:urawai_pos/ui/Widgets/costum_DialogBox.dart';
import 'package:urawai_pos/ui/Widgets/drawerMenu.dart';
import 'package:urawai_pos/ui/utils/constans/const.dart';
import 'package:urawai_pos/ui/utils/constans/formatter.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';
import 'package:urawai_pos/ui/utils/functions/paymentHelpers.dart';
import 'package:date_range_picker/date_range_picker.dart' as dateRangePicker;
import 'package:urawai_pos/ui/utils/functions/routeGenerator.dart';

class TransactionHistoryPage extends StatelessWidget {
  final FirestoreServices _firestoreServices = FirestoreServices();

  @override
  Widget build(BuildContext context) {
    // var box = Hive.box<TransactionOrder>(POSPage.transactionBoxName);
    final generalProvider =
        Provider.of<GeneralProvider>(context, listen: false);

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text('Riwayat Transasksi'),
      ),
      drawer: Drawer(
        child: DrawerMenu(),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            // Expanded(
            //   child: Container(
            //     color: Colors.blue,
            //   ),
            // ),
            Expanded(
              // flex: 3,
              child: Container(
                // color: Color(0xFFfafbfd),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Cari Berdasarkan Tanggal:',
                                  style: kProductNameSmallScreenTextStyle),
                              Row(
                                children: <Widget>[
                                  Consumer<GeneralProvider>(
                                      builder: (_, value, __) {
                                    String text;
                                    if (value.selectedDate == null ||
                                        value.selectedDate.isEmpty)
                                      text = 'Semua Transaksi';
                                    else if (value.selectedDate.length == 1)
                                      text = Formatter.dateFormat(
                                          value.selectedDate[0]);
                                    else if (value.selectedDate.length == 2)
                                      text = Formatter.dateFormat(
                                              value.selectedDate[0]) +
                                          ' s/d ' +
                                          Formatter.dateFormat(
                                              value.selectedDate[1]);

                                    return Text(
                                      'Tanggal: $text',
                                      style: kPriceTextStyle,
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
                                      //================ [ Single Date ] ================
                                      // DateTime selectedDate =
                                      //     await showDatePicker(
                                      //         context: context,
                                      //         initialDate: DateTime.now(),
                                      //         firstDate: DateTime(2020),
                                      //         lastDate: DateTime(2040));

                                      // Provider.of<GeneralProvider>(context,
                                      //         listen: false)
                                      //     .selectedDate = selectedDate;
                                      //===================================================
                                      var pickedDate =
                                          await dateRangePicker.showDatePicker(
                                        context: context,
                                        initialFirstDate: DateTime.now(),
                                        initialLastDate: DateTime.now()
                                            .add(Duration(days: 7)),
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
                                      Provider.of<GeneralProvider>(context,
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
                                  style: kProductNameSmallScreenTextStyle,
                                ),
                                SizedBox(width: 15),
                                Consumer<GeneralProvider>(
                                  builder: (_, value, __) =>
                                      StreamBuilder<QuerySnapshot>(
                                          stream: value.selectedDate.isEmpty
                                              ? _firestoreServices
                                                  .getDocumentLength(kShopName)
                                              : _firestoreServices
                                                  .getDocumentByDate(kShopName,
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
                                            switch (snapshot.connectionState) {
                                              case ConnectionState.waiting:
                                                return CircularProgressIndicator();

                                                break;
                                              default:
                                                return Text(
                                                  snapshot.data.documents.length
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
                      // ====================[ OFFLINE CODE ] ======================
                      // (box.length == 0)
                      //     ? Expanded(
                      //         child: Container(
                      //         alignment: Alignment.center,
                      //         child: Text("Belum Anda Transasksi",
                      //             style: kProductNameBigScreenTextStyle),
                      //       ))
                      //     : _loadTransactionList(box,
                      //                 Provider.of<GeneralProvider>(context))
                      //             .isNotEmpty
                      //         ? Expanded(
                      //             child: Consumer2<GeneralProvider,
                      //                 TransactionOrderProvider>(
                      //               builder: (context, state, state2, _) =>
                      //                   GridView.count(
                      //                       shrinkWrap: true,
                      //                       crossAxisCount: 4,
                      //                       mainAxisSpacing: 20,
                      //                       crossAxisSpacing: 15,
                      //                       children: _loadTransactionList(
                      //                           box, state)),
                      //             ),
                      //           )
                      //         : Expanded(
                      //             child: Container(
                      //             alignment: Alignment.center,
                      //             child: Text("Belum Anda Transasksi",
                      //                 style: kProductNameBigScreenTextStyle),
                      //           ))
                      // ==========================================================

                      Consumer<GeneralProvider>(
                        builder: (_, value, __) => StreamBuilder<QuerySnapshot>(
                          stream: value.selectedDate.isEmpty
                              ? _firestoreServices.getAllDocuments(kShopName)
                              : _firestoreServices.getDocumentByDate(
                                  kShopName, value.selectedDate),
                          builder: (context, snapshot) {
                            if (snapshot.hasError)
                              return Text(
                                'An Error has Occured ${snapshot.error}',
                                style: kPriceTextStyle,
                              );
                            if (!snapshot.hasData)
                              return Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Consumer<GeneralProvider>(
                                    builder: (_, value, __) =>
                                        _noTransactionDataResult(
                                            value.selectedDate),
                                  ),
                                ),
                              );
                            if (snapshot.data.documents.isEmpty)
                              return Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Belum Ada Transaksi',
                                    style: kProductNameBigScreenTextStyle,
                                  ),
                                ),
                              );
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Expanded(
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                                break;
                              default:
                                if (snapshot.data.documents.length == 0)
                                  return Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Consumer<GeneralProvider>(
                                        builder: (_, value, __) =>
                                            _noTransactionDataResult(
                                                value.selectedDate),
                                      ),
                                    ),
                                  );
                                else
                                  return Expanded(
                                    // =============== [ LISTVIEW STYLE ] ===================
                                    // child: ListView.builder(
                                    //     itemCount: snapshot.data.documents.length,
                                    //     itemBuilder: (context, index) {
                                    //       var data =
                                    //           snapshot.data.documents[index];

                                    //       return _buildCardFromFirestore(data);
                                    //     }),
                                    // ======================================================
                                    child: GridView.count(
                                      crossAxisCount: 4,
                                      children: snapshot.data.documents
                                          .map((data) =>
                                              _buildCardFromFirestore(data))
                                          .toList(),
                                    ),
                                  );
                              // return ListView(
                              //   children: snapshot.data.documents
                              //       .map((DocumentSnapshot document) {
                              //     return ListTile(
                              //       title: Text(document['id']),
                              //       subtitle: Text(document['cashierName']),
                              //       trailing:
                              //           Text(document['grandTotal'].toString()),
                              //     );
                              //   }).toList(),
                              // );
                            }
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
    ));
  }

  Widget _noTransactionDataResult(List<DateTime> selectedData) {
    if (selectedData.length == 1)
      return Text(
        'Tidak Ada Data pada Tanggal ${Formatter.dateFormat(selectedData[0])}',
        style: kProductNameBigScreenTextStyle,
      );
    else if (selectedData.length == 2)
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Tidak Ada Data pada Tanggal ',
            style: kProductNameBigScreenTextStyle,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${Formatter.dateFormat(selectedData[0])} S/D ',
                style: kProductNameBigScreenTextStyle,
              ),
              Text(
                '${Formatter.dateFormat(selectedData[1])}',
                style: kProductNameBigScreenTextStyle,
              ),
            ],
          )
        ],
      );
    return CircularProgressIndicator();
  }

  // List<Widget> _loadTransactionList(
  //     Box<TransactionOrder> box, GeneralProvider state) {
  //   if (state.selectedDate == null) {
  //     var result = box.values
  //         .map((itemList) => _buildCardTransaction(itemList))
  //         .toList();
  //     return result;
  //   } else {
  //     var result = box.values
  //         .where((item) {
  //           bool result = DateFormat("dMy").format(item.date) ==
  //               DateFormat("dMy").format(state.selectedDate);
  //           return result;
  //         })
  //         .map((itemList) => _buildCardTransaction(itemList))
  //         .toList();

  //     // if (result.length == 0) {
  //     //   return [
  //     //     Container(
  //     //       alignment: Alignment.center,
  //     //       child: Text("Belum Anda Transasksi",
  //     //           style: kProductNameBigScreenTextStyle),
  //     //     )
  //     //   ];
  //     // } else
  //     //   return result;

  //     return result;
  //   }
  // }

  //==================[ Build Card From Hive Offline DB ]=======================
  // Container _buildCardTransaction(TransactionOrder item) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Color(0xFFf4f4f4),
  //       border: Border.all(color: Colors.black),
  //       borderRadius: BorderRadius.circular(10),
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(
  //         horizontal: 8.0,
  //         vertical: 10,
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: <Widget>[
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: <Widget>[
  //               Text(
  //                 'Order ID:',
  //                 style: kPriceTextStyle,
  //               ),
  //               Text(
  //                 item.id,
  //                 style: kPriceTextStyle,
  //               ),
  //             ],
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: <Widget>[
  //               Text(
  //                 'Waktu:',
  //                 style: kPriceTextStyle,
  //               ),
  //               Text(
  //                 Formatter.dateFormat(item.date),
  //                 style: kPriceTextStyle,
  //               ),
  //             ],
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: <Widget>[
  //               Text(
  //                 'Status:',
  //                 style: kPriceTextStyle,
  //               ),
  //               Text(
  //                 PaymentHelper.getPaymentStatus(item.paymentStatus),
  //                 style: kPriceTextStyle,
  //               ),
  //             ],
  //           ),
  //           Divider(
  //             color: item.paymentStatus == PaymentStatus.VOID
  //                 ? Colors.red
  //                 : item.paymentStatus == PaymentStatus.PENDING
  //                     ? Colors.blue
  //                     : Colors.green,
  //             thickness: 2,
  //           ),
  //           Text(
  //             'Nama Kasir:',
  //             style: kPriceTextStyle,
  //           ),
  //           Text(
  //             item.cashierName ?? '[null]',
  //             style: kPriceTextStyle,
  //           ),
  //           SizedBox(height: 5),
  //           Text(
  //             'Transaksi:',
  //             style: kPriceTextStyle,
  //           ),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: <Widget>[
  //               Text(
  //                 Formatter.currencyFormat(item.grandTotal),
  //                 style: kProductNameBigScreenTextStyle,
  //               ),
  //               Builder(
  //                 builder: (context) => Row(
  //                   children: <Widget>[
  //                     GestureDetector(
  //                       child: Icon(
  //                         Icons.info,
  //                         color: Colors.blue,
  //                         size: 25,
  //                       ),
  //                       onTap: () => Navigator.pushNamed(
  //                         context,
  //                         DetailTransactionPage.routeName,
  //                         arguments: item.id,
  //                       ),
  //                     ),
  //                     SizedBox(width: 5),
  //                     GestureDetector(
  //                         child: Icon(
  //                           Icons.delete,
  //                           color: Colors.red,
  //                           size: 25,
  //                         ),
  //                         onTap: () {
  //                           CostumDialogBox.showCostumDialogBox(
  //                               title: 'Konfirmasi',
  //                               context: context,
  //                               contentString:
  //                                   'Anda Akan menhapus Transaksi ID.[${item.id}], Hapus ?',
  //                               icon: Icons.delete,
  //                               iconColor: Colors.red,
  //                               confirmButtonTitle: 'Hapus',
  //                               onConfirmPressed: () {
  //                                 Provider.of<TransactionOrderProvider>(context,
  //                                         listen: false)
  //                                     .deleteTransaction(item.id);

  //                                 Navigator.pop(context);
  //                               });
  //                         }),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
// }
  //==========================================================================

  Container _buildCardFromFirestore(DocumentSnapshot item) {
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
                  item['id'],
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
                  Formatter.dateFormat(
                      ((item['orderDate']) as Timestamp).toDate()),
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
                  PaymentHelper.getPaymentStatusAsString(item['paymentStatus']),
                  style: kPriceTextStyle,
                ),
              ],
            ),
            Divider(
              color: item['paymentStatus'] == 'PaymentStatus.VOID'
                  ? Colors.red
                  : item['paymentStatus'] == 'PaymentStatus.PENDING'
                      ? Colors.blue
                      : Colors.green,
              thickness: 2,
            ),
            Text(
              'Nama Kasir:',
              style: kPriceTextStyle,
            ),
            Text(
              item['cashierName'] ?? '[null]',
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
                  Formatter.currencyFormat(item['grandTotal']),
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
                          arguments: item['id'],
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
                                    'Anda Akan menhapus Transaksi ID.[${item['id']}], Hapus ?',
                                icon: Icons.delete,
                                iconColor: Colors.red,
                                confirmButtonTitle: 'Hapus',
                                onConfirmPressed: () {
                                  _firestoreServices.deleteTransaction(
                                      kShopName, item['id']);
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
