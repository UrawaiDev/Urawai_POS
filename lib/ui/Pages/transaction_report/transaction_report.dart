import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:urawai_pos/core/Models/products.dart';
import 'package:urawai_pos/core/Services/firestore_service.dart';
import 'package:urawai_pos/ui/Widgets/costum_button.dart';
import 'package:urawai_pos/ui/Widgets/drawerMenu.dart';
import 'package:urawai_pos/ui/utils/constans/const.dart';
import 'package:urawai_pos/ui/utils/constans/formatter.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';

class TransactionReport extends StatelessWidget {
  final FirestoreServices _firestoreServices = FirestoreServices();
  @override
  Widget build(BuildContext context) {
    // var box = Hive.box<TransactionOrder>(TransactionOrder.boxName);

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(title: Text('Laporan Penjualan')),
            drawer: Drawer(
              child: DrawerMenu(),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('Beranda', style: kHeaderTextStyle),
                        CostumButton.squareButton('Periode Penjualan'),
                      ],
                    ),
                    SizedBox(height: 20),
                    StreamBuilder<QuerySnapshot>(
                        stream: _firestoreServices.getAllDocuments(kShopName),
                        builder: (context, snapshot) {
                          if (snapshot.hasError)
                            return Text(
                              'An Error has Occured ${snapshot.error}',
                              style: kProductNameBigScreenTextStyle,
                            );
                          if (!snapshot.hasData)
                            return Text(
                              'Belum Ada data Penjualan.',
                              style: kProductNameBigScreenTextStyle,
                            );
                          if (snapshot.connectionState ==
                              ConnectionState.waiting)
                            return CircularProgressIndicator();
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              _headerCard(
                                'Total Penjualan Kotor',
                                Colors.lightGreen,
                                _getBruto(snapshot),
                              ),
                              _headerCard(
                                'Total Keuntungan',
                                Colors.amber,
                                _getNetto(snapshot),
                              ),
                              _headerCard(
                                'Total Transaksi',
                                Colors.blue,
                                snapshot.data.documents.length.toString(),
                              ),
                              _headerCard(
                                'Rata-Rata Nilai Transaksi',
                                Colors.red,
                                _getAverage(snapshot),
                              ),
                            ],
                          );
                        }),
                    SizedBox(height: 20),
                    Expanded(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      child: StreamBuilder<QuerySnapshot>(
                                          // TODO: create function to return All document without Transaction VOID
                                          stream: _firestoreServices
                                              .getAllDocuments(kShopName),
                                          builder: (context, snapshot) {
                                            //TODO: refactory this widget since use multiple area
                                            if (snapshot.hasError)
                                              return Text(
                                                'An Error has Occured ${snapshot.error}',
                                                style:
                                                    kProductNameBigScreenTextStyle,
                                              );
                                            if (!snapshot.hasData)
                                              return Text(
                                                'Belum Ada data Penjualan.',
                                                style:
                                                    kProductNameBigScreenTextStyle,
                                              );
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting)
                                              return CircularProgressIndicator();

                                            return FutureBuilder<List<Product>>(
                                                future: _firestoreServices
                                                    .getProducts(kShopName),
                                                builder: (context, products) {
                                                  if (products.hasError ||
                                                      !products.hasData)
                                                    return Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          CircularProgressIndicator(),
                                                          SizedBox(height: 20),
                                                          Text(
                                                            'Loading...',
                                                            style:
                                                                kPriceTextStyle,
                                                          ),
                                                        ],
                                                      ),
                                                    );

                                                  if (products.data.isEmpty)
                                                    return Container(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Center(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Text(
                                                                'Belum Ada Produk Saat ini.',
                                                                style:
                                                                    kProductNameBigScreenTextStyle,
                                                              ),
                                                              SizedBox(
                                                                  height: 30),
                                                              CostumButton
                                                                  .squareButtonSmall(
                                                                      'Buat',
                                                                      onTap:
                                                                          () {
                                                                //TODO:will place Navigator to Add Product Page
                                                              },
                                                                      prefixIcon:
                                                                          Icons
                                                                              .add),
                                                            ],
                                                          ),
                                                        ));

                                                  switch (products
                                                      .connectionState) {
                                                    case ConnectionState
                                                        .waiting:
                                                      return Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                      break;
                                                    default:
                                                      return ListView.builder(
                                                          itemCount: products
                                                              .data
                                                              .length ??= 0,
                                                          itemBuilder:
                                                              (context, index) {
                                                            var data =
                                                                _getTopSellingProducts(
                                                                    snapshot,
                                                                    products);

                                                            return ListTile(
                                                              leading: Chip(
                                                                label: Text(
                                                                  (index + 1)
                                                                      .toString(),
                                                                  style:
                                                                      kProductNameSmallScreenTextStyle,
                                                                ),
                                                              ),
                                                              title: Text(
                                                                data.keys
                                                                    .elementAt(
                                                                        index),
                                                                style:
                                                                    kPriceTextStyle,
                                                              ),
                                                              trailing: Text(
                                                                data.values
                                                                    .elementAt(
                                                                        index)
                                                                    .toString(),
                                                                style:
                                                                    kProductNameSmallScreenTextStyle,
                                                              ),
                                                            );
                                                          });
                                                  }
                                                });
                                          }),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //Prepare for Chart
                          Expanded(
                              child: Container(
                            // color: Colors.blue,
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                'CHART',
                                style: kProductNameBigScreenTextStyle,
                              ),
                            ),
                          )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )));
  }

  LinkedHashMap<dynamic, dynamic> _getTopSellingProducts(
      AsyncSnapshot<QuerySnapshot> snapshot,
      AsyncSnapshot<List<Product>> products) {
    int total = 0;
    int count = 0;

    Map<String, int> mapper = Map<String, int>();
    for (var product in products.data) {
      snapshot.data.documents.forEach((element) {
        if (element['paymentStatus'] != 'PaymentStatus.VOID') {
          for (var data in element['orderlist']) {
            if (data['productName'].toString().trim().toUpperCase() ==
                product.name.trim().toUpperCase()) {
              count++;
              total = total + data['quantity'];
            }
          }
        }
      });

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

  String _getBruto(AsyncSnapshot<QuerySnapshot> snapshot) {
    double result = snapshot.data.documents
        .fold(0, (prev, element) => prev + element['grandTotal']);

    return Formatter.currencyFormat(result);
  }

  String _getNetto(AsyncSnapshot<QuerySnapshot> snapshot) {
    double total = snapshot.data.documents
        .fold(0, (prev, element) => prev + element['grandTotal']);

    double result = (total * 100 / 110);

    return Formatter.currencyFormat(result);
  }

  String _getAverage(AsyncSnapshot<QuerySnapshot> snapshot) {
    double total = snapshot.data.documents
        .fold(0, (prev, element) => prev + element['grandTotal']);

    double result = total / snapshot.data.documents.length;

    return Formatter.currencyFormat(result);
  }

  Widget _headerCard(String title, Color color, String value) {
    return Container(
      width: 230,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: kPriceTextStyle,
                ),
                SizedBox(height: 10),
                Text(
                  value,
                  style: kProductNameBigScreenTextStyle,
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
    );
  }
}
