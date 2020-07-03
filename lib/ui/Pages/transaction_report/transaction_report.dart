import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urawai_pos/core/Models/orderList.dart';
import 'package:urawai_pos/core/Models/products.dart';
import 'package:urawai_pos/core/Models/transaction.dart';
import 'package:urawai_pos/core/Models/users.dart';
import 'package:urawai_pos/core/Provider/general_provider.dart';
import 'package:urawai_pos/core/Services/firestore_service.dart';
import 'package:urawai_pos/ui/Widgets/charts/line_sales_chart.dart';
import 'package:urawai_pos/ui/Widgets/costum_button.dart';
import 'package:urawai_pos/ui/Widgets/drawerMenu.dart';
import 'package:urawai_pos/ui/Widgets/loading_card.dart';
import 'package:urawai_pos/ui/utils/constans/formatter.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';
import 'package:date_range_picker/date_range_picker.dart' as dateRangePicker;
import 'package:urawai_pos/ui/utils/functions/getCurrentUser.dart';
import 'package:urawai_pos/ui/utils/functions/routeGenerator.dart';

class TransactionReport extends StatelessWidget {
  final FirestoreServices _firestoreServices = FirestoreServices();

  @override
  Widget build(BuildContext context) {
    final generalProvider = Provider.of<GeneralProvider>(context);
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
                  appBar: AppBar(title: Text('Laporan Penjualan')),
                  drawer: Drawer(
                    child: DrawerMenu(currentUser),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Beranda', style: kHeaderTextStyle),
                              Row(
                                children: <Widget>[
                                  Consumer<GeneralProvider>(
                                      builder: (_, value, __) {
                                    String text;
                                    if (value.selectedDate == null ||
                                        value.selectedDate.isEmpty)
                                      text = 'Semua Transaksi';
                                    else if (value.selectedDate.length == 1)
                                      text = DateFormat('d-M-y')
                                          .format(value.selectedDate[0]);
                                    else if (value.selectedDate.length == 2)
                                      text = DateFormat('d-M-y')
                                              .format(value.selectedDate[0]) +
                                          ' s/d ' +
                                          DateFormat('d-M-y')
                                              .format(value.selectedDate[1]);

                                    return Text(
                                      'Tanggal: $text',
                                      style: kProductNameSmallScreenTextStyle,
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
                          Expanded(
                            child: Consumer<GeneralProvider>(
                              builder: (context, value, _) => FutureBuilder<
                                      List<TransactionOrder>>(
                                  future: value.selectedDate.isEmpty
                                      ? _firestoreServices
                                          .getAllDocumentsWithoutVOID(
                                              currentUser.shopName)
                                      : _firestoreServices.getDocumentByDate(
                                          currentUser.shopName,
                                          value.selectedDate,
                                          includeVoid: false,
                                        ),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError)
                                      return Text(
                                        'An Error has Occured ${snapshot.error}',
                                        style: kProductNameBigScreenTextStyle,
                                      );

                                    if (snapshot.connectionState ==
                                            ConnectionState.waiting ||
                                        !snapshot.hasData)
                                      return CircularProgressIndicator();

                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        _headerCard(
                                          'Total Penjualan',
                                          Colors.lightGreen,
                                          _getBruto(snapshot),
                                        ),
                                        FutureBuilder<String>(
                                          future: _getNetto(snapshot),
                                          builder: (_, dataSnapshot) {
                                            if (!dataSnapshot.hasData)
                                              return _headerCard(
                                                  'Total Keuntungan',
                                                  Colors.amber,
                                                  'Loading...');
                                            return _headerCard(
                                                'Total Keuntungan',
                                                Colors.amber,
                                                dataSnapshot.data);
                                          },
                                        ),
                                        _headerCard(
                                          'Total Transaksi',
                                          Colors.blue,
                                          snapshot.data.length.toString(),
                                        ),
                                        _headerCard(
                                          'Rata-Rata Transaksi',
                                          Colors.red,
                                          _getAverage(snapshot),
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                          ),
                          SizedBox(height: 8),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Produk Terlaris',
                                                style: kHeaderTextStyle,
                                              ),
                                              Text(
                                                'Produk dengan penjualan terbanyak',
                                                style: kPriceTextStyle,
                                              ),
                                              Divider(thickness: 4),
                                            ],
                                          ),
                                          Expanded(
                                            child: Consumer<GeneralProvider>(
                                              builder: (_, value, __) =>
                                                  FutureBuilder<
                                                          List<
                                                              TransactionOrder>>(
                                                      future: value.selectedDate
                                                              .isEmpty
                                                          ? _firestoreServices
                                                              .getAllDocumentsWithoutVOID(
                                                                  currentUser
                                                                      .shopName)
                                                          : _firestoreServices
                                                              .getDocumentByDate(
                                                                  currentUser.shopName,
                                                                  value.selectedDate,
                                                                  includeVoid: false),
                                                      builder: (context, snapshot) {
                                                        if (snapshot.hasError)
                                                          return Text(
                                                            'An Error has Occured ${snapshot.error}',
                                                            style:
                                                                kProductNameBigScreenTextStyle,
                                                          );

                                                        return FutureBuilder<
                                                                List<Product>>(
                                                            future: _firestoreServices
                                                                .getProducts(
                                                                    currentUser
                                                                        .shopName),
                                                            builder: (context,
                                                                products) {
                                                              if (products
                                                                      .hasError ||
                                                                  !products
                                                                      .hasData)
                                                                return Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: <
                                                                        Widget>[
                                                                      CircularProgressIndicator(),
                                                                      SizedBox(
                                                                          height:
                                                                              20),
                                                                      Text(
                                                                        'Loading...',
                                                                        style:
                                                                            kPriceTextStyle,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );

                                                              if (products
                                                                  .data.isEmpty)
                                                                return Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: <
                                                                            Widget>[
                                                                          Text(
                                                                            'Belum Ada Produk Saat ini.',
                                                                            style:
                                                                                kProductNameBigScreenTextStyle,
                                                                          ),
                                                                          SizedBox(
                                                                              height: 30),
                                                                          CostumButton.squareButtonSmall(
                                                                              'Buat',
                                                                              onTap: () => Navigator.pushNamed(context, RouteGenerator.kRouteAddProductPage),
                                                                              prefixIcon: Icons.add),
                                                                        ],
                                                                      ),
                                                                    ));

                                                              return ListView
                                                                  .builder(
                                                                      itemCount:
                                                                          products.data.length ??=
                                                                              0,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        var data = _getTopSellingProducts(
                                                                            snapshot,
                                                                            products);

                                                                        return ListTile(
                                                                          leading:
                                                                              Chip(
                                                                            label:
                                                                                Text(
                                                                              (index + 1).toString(),
                                                                              style: kProductNameSmallScreenTextStyle,
                                                                            ),
                                                                          ),
                                                                          title:
                                                                              Text(
                                                                            data.keys.elementAt(index),
                                                                            style:
                                                                                kPriceTextStyle,
                                                                          ),
                                                                          trailing:
                                                                              Text(
                                                                            data.values.elementAt(index).toString(),
                                                                            style:
                                                                                kProductNameSmallScreenTextStyle,
                                                                          ),
                                                                        );
                                                                      });
                                                            });
                                                      }),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Consumer<GeneralProvider>(
                                      builder: (context, value, _) =>
                                          FutureBuilder<List<TransactionOrder>>(
                                              future: value.selectedDate.isEmpty
                                                  ? _firestoreServices
                                                      .getAllDocumentsWithoutVOID(
                                                          currentUser.shopName)
                                                  : _firestoreServices
                                                      .getDocumentByDate(
                                                          currentUser.shopName,
                                                          value.selectedDate,
                                                          includeVoid: false),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasError)
                                                  return Text(
                                                    'An Erro Occured. ${snapshot.error}',
                                                    style: kPriceTextStyle,
                                                  );
                                                if (!snapshot.hasData ||
                                                    snapshot.connectionState ==
                                                        ConnectionState.waiting)
                                                  return CircularProgressIndicator();

                                                return SalesChart
                                                    .lineChartSales(
                                                        snapshot.data,
                                                        generalProvider
                                                            .selectedDate);
                                              }),
                                    ),
                                  ),
                                )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ));
            }));
  }

  LinkedHashMap<dynamic, dynamic> _getTopSellingProducts(
      AsyncSnapshot<List<TransactionOrder>> snapshot,
      AsyncSnapshot<List<Product>> products) {
    int total = 0;
    int count = 0;

    Map<String, int> mapper = Map<String, int>();
    for (var product in products.data) {
      if (snapshot.hasData) {
        snapshot.data.forEach((element) {
          if (element.paymentStatus.toString() != 'PaymentStatus.VOID') {
            for (OrderList data in element.itemList) {
              if (data.productName.toString().trim().toUpperCase() ==
                  product.name.trim().toUpperCase()) {
                count++;
                total = total + data.quantity;
              }
            }
          }
        });
      }
      mapper.addAll({product.name: total});

      count = 0;
      total = 0;
    }

    var sortedKeys = mapper.keys.toList(growable: false)
      ..sort((k1, k2) => mapper[k2].compareTo(mapper[k1]));
    LinkedHashMap sortedMap = new LinkedHashMap.fromIterable(sortedKeys,
        key: (k) => k, value: (k) => mapper[k]);

    return sortedMap;
  }

  String _getBruto(AsyncSnapshot<List<TransactionOrder>> snapshot) {
    double result =
        snapshot.data.fold(0, (prev, element) => prev + element.grandTotal);

    return Formatter.currencyFormat(result);
  }

  Future<String> _getNetto(
      AsyncSnapshot<List<TransactionOrder>> snapshot) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    double result = 0;
    double total =
        snapshot.data.fold(0, (prev, element) => prev + element.grandTotal);
    bool hasVAT = _prefs.getBool('vat');
    if (hasVAT)
      result = (total * 100 / 110);
    else
      result = total;

    return Formatter.currencyFormat(result);
  }

  String _getAverage(AsyncSnapshot<List<TransactionOrder>> snapshot) {
    double total =
        snapshot.data.fold(0, (prev, element) => prev + element.grandTotal);

    double result = total / snapshot.data.length;

    return Formatter.currencyFormat(result);
  }

  Widget _headerCard(String title, Color color, String value) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text(
                      title,
                      style: kPriceTextStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    child: Text(
                      value,
                      style: kGrandTotalTextStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 20,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
