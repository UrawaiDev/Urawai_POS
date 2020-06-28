import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:get_it/get_it.dart';
import 'package:urawai_pos/core/Models/orderList.dart';
import 'package:urawai_pos/core/Models/transaction.dart';
import 'package:urawai_pos/core/Models/users.dart';
import 'package:urawai_pos/core/Services/firebase_auth.dart';
import 'package:urawai_pos/core/Services/firestore_service.dart';
import 'package:urawai_pos/core/Services/printer_service.dart';
import 'package:urawai_pos/ui/Widgets/costum_DialogBox.dart';
import 'package:urawai_pos/ui/Widgets/costum_button.dart';
import 'package:urawai_pos/ui/Widgets/footer_OrderList.dart';
import 'package:urawai_pos/ui/utils/constans/formatter.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';
import 'package:urawai_pos/ui/utils/functions/paymentHelpers.dart';

class DetailTransactionPage extends StatefulWidget {
  final String boxKey;

  DetailTransactionPage({@required this.boxKey});

  @override
  _DetailTransactionPageState createState() => _DetailTransactionPageState();
}

class _DetailTransactionPageState extends State<DetailTransactionPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuthentication _firebaseAuthentication =
      FirebaseAuthentication();

  final FirestoreServices _firestoreServices = FirestoreServices();

  final locatorAuth = GetIt.I<FirebaseAuthentication>();
  static const int BLUETOOTH_DISCONNECTED = 10;
  int bluetoothStatus;
  BluetoothManager bluetoothManager = BluetoothManager.instance;
  String _shopName;

  @override
  void initState() {
    super.initState();

    locatorAuth.currentUserXXX.then((data) {
      _shopName = data.shopName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      body: Row(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Container(
                child: _buildDetailTransactionFromFirestore(context),
              )),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  width: 1.5,
                  color: Colors.grey,
                )),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: FutureBuilder<DocumentSnapshot>(
                    future: _getDocumentbyID(),
                    builder: (context, snaphot) {
                      if (snaphot.hasError)
                        return Expanded(
                            child: Text(
                          snaphot.error.toString(),
                          style: kErrorTextStyle,
                        ));
                      if (snaphot.connectionState == ConnectionState.waiting ||
                          !snaphot.hasData)
                        return Center(child: CircularProgressIndicator());

                      var transaction =
                          TransactionOrder.fromJson(snaphot.data.data);

                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Daftar Pesanan:',
                              style: kProductNameSmallScreenTextStyle,
                            ),
                            Divider(thickness: 1.5),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Container(
                                  child: ListView.builder(
                                      itemCount: transaction.itemList.length,
                                      itemBuilder: (context, index) {
                                        OrderList itemList =
                                            transaction.itemList[index];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5.0, horizontal: 5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    AutoSizeText(
                                                      'x${itemList.quantity}',
                                                      style: kPriceTextStyle,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Container(
                                                      width: 200,
                                                      child: AutoSizeText(
                                                        itemList.productName,
                                                        style: kPriceTextStyle,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: AutoSizeText(
                                                    Formatter.currencyFormat(
                                                        itemList.price *
                                                            itemList.quantity),
                                                    style: kPriceTextStyle,
                                                  ),
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Pembayaran',
                                        style: kPriceTextStyle,
                                      ),
                                      Text(
                                        transaction.paymentStatus.toString() ==
                                                'PaymentType.CASH'
                                            ? Formatter.currencyFormat(
                                                transaction.tender)
                                            : Formatter.currencyFormat(
                                                transaction.grandTotal),
                                        style: kPriceTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Kembali',
                                        style: kPriceTextStyle,
                                      ),
                                      Text(
                                        transaction.paymentType.toString() ==
                                                'PaymentType.CASH'
                                            ? Formatter.currencyFormat(
                                                transaction.change)
                                            : 'Rp. 0',
                                        style: kPriceTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            FooterOrderList(
                              dicount: transaction.discount,
                              grandTotal: transaction.grandTotal,
                              subtotal: transaction.subtotal,
                              vat: transaction.vat,
                            ),
                          ]);
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                // color: Colors.yellow,
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CostumButton.squareButtonSmall(
                        'Cetak Kwitansi',
                        prefixIcon: Icons.print,
                        borderColor: Colors.green,
                        onTap: () async {
                          PosPrintResult result = await printStruck();
                          if (result == null)
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(content: Text('An Error Occured.')));
                          else
                            _scaffoldKey.currentState.showSnackBar(
                                SnackBar(content: Text(result.msg)));
                        },
                      ),
                      //* Hide For Now
                      // SizedBox(height: 20),
                      // CostumButton.squareButtonSmall(
                      //   'Kirim Kwitansi',
                      //   prefixIcon: Icons.share,
                      // ),
                      SizedBox(height: 20),
                      CostumButton.squareButtonSmall(
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

  Future<PosPrintResult> printStruck() async {
    bluetoothManager.state.listen((status) {
      print(status);
      bluetoothStatus = status;
    });

    var documentSnapshot = await _getDocumentbyID();
    var printer = await PrinterService.loadPrinterDevice();

    if (printer.name != null &&
        bluetoothStatus != BLUETOOTH_DISCONNECTED &&
        _shopName != null) {
      print(documentSnapshot.data['paymentStatus'].toString());
      var result = PrinterService.printStruckDetailTransaction(
        printer: PrinterBluetooth(printer),
        documents: documentSnapshot,
        shopName: _shopName,
        paymentStatus: PaymentHelper.getPaymentStatusAsString(
            documentSnapshot.data['paymentStatus'].toString()),
      );
      return result;
    } else {
      CostumDialogBox.showDialogInformation(
        context: context,
        title: 'Informasi',
        contentText:
            'Printer Tidak terhubung. \n• Periksa Koneksi Bluetooth. \n• Printer belum diset pada pengaturan',
        icon: Icons.bluetooth_disabled,
        iconColor: Colors.blue,
        onTap: () => Navigator.pop(context),
      );
      print(
          'Something when wrong with the printer, please check connection and make sure you have set the printer.');
      return null;
    }
  }

  Future<DocumentSnapshot> _getDocumentbyID() async {
    Users currentUser = await _firebaseAuthentication.currentUserXXX;
    var result =
        _firestoreServices.getDocumentByID(currentUser.shopName, widget.boxKey);
    return result;
  }

  Widget _buildDetailTransactionFromFirestore(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: _getDocumentbyID(),
        builder: (context, document) {
          var data = document.data;

          if (!document.hasData)
            return Center(child: CircularProgressIndicator());
          else {
            int totalOrder =
                (data['orderlist'] as List).fold(0, (prev, element) {
              return prev + element['quantity'];
            });
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
                        FutureBuilder<Users>(
                            future: _firebaseAuthentication.currentUserXXX,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData ||
                                  snapshot.connectionState ==
                                      ConnectionState.waiting)
                                return Text(
                                  'Loading',
                                  style: kPriceTextStyle,
                                );

                              return Text(snapshot.data.shopName.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 20,
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
                              totalOrder.toString(),
                              style: kPriceTextStyle,
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 2,
                        )
                      ],
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
              ),
            );
          }
        });
  }
}
