import 'package:auto_size_text/auto_size_text.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/core/Models/transaction.dart';
import 'package:urawai_pos/core/Models/users.dart';
import 'package:urawai_pos/core/Provider/orderList_provider.dart';
import 'package:urawai_pos/core/Provider/postedOrder_provider.dart';
import 'package:urawai_pos/core/Services/firebase_auth.dart';
import 'package:urawai_pos/core/Services/printer_service.dart';
import 'package:urawai_pos/ui/Pages/pos/pos_Page.dart';
import 'package:urawai_pos/ui/Widgets/costum_DialogBox.dart';
import 'package:urawai_pos/ui/Widgets/costum_button.dart';
import 'package:urawai_pos/ui/Widgets/footer_OrderList.dart';
import 'package:urawai_pos/ui/utils/constans/formatter.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';

class PaymentSuccess extends StatefulWidget {
  final List<dynamic> itemList;
  final double pembayaran;
  final double kembali;
  final dynamic state;
  final PaymentType paymentType;

  PaymentSuccess({
    @required this.itemList,
    @required this.paymentType,
    @required this.pembayaran,
    @required this.kembali,
    @required this.state,
  });

  @override
  _PaymentSuccessState createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  final locatorAuth = GetIt.I<FirebaseAuthentication>();

  static const int BLUETOOTH_DISCONNECTED = 10;
  int bluetoothStatus;
  BluetoothManager bluetoothManager = BluetoothManager.instance;

  @override
  void initState() {
    super.initState();

    bluetoothManager.state.listen((status) {
      bluetoothStatus = status;
    });

    locatorAuth.currentUserXXX.then((data) {
      printStruck(data.shopName);
    });
  }

  @override
  Widget build(BuildContext context) {
    String _cashierName;
    String _referenceOrder;
    DateTime _orderDate;
    String _shopName;

    //Get header information
    if (widget.state is OrderListProvider) {
      var x = widget.state as OrderListProvider;
      _cashierName = x.cashierName;
      _referenceOrder = x.referenceOrder;
      _orderDate = x.orderDate;
    } else if (widget.state is PostedOrderProvider) {
      var x = widget.state as PostedOrderProvider;
      _cashierName = x.postedOrder.cashierName;
      _referenceOrder = x.postedOrder.refernceOrder;
      _orderDate = x.postedOrder.dateTime;
    }

    return WillPopScope(
      onWillPop: () => _onTransactionComplete(context),
      child: SafeArea(
        child: Scaffold(
          body: Container(
            child: Row(
              children: <Widget>[
                SizedBox(width: 10),
                //LEFT SIDE
                Container(
                  width: 1.5,
                  color: Colors.grey,
                ),
                SizedBox(width: 5),
                Expanded(
                  flex: 2,
                  child: Container(
                    // color: Colors.blue,
                    padding: EdgeInsets.fromLTRB(10, 5, 5, 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FutureBuilder<Users>(
                                future: locatorAuth.currentUserXXX,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData ||
                                      snapshot.connectionState ==
                                          ConnectionState.waiting)
                                    return Text(
                                      'Loading',
                                      style: kPriceTextStyle,
                                    );
                                  _shopName =
                                      snapshot.data.shopName.toUpperCase();
                                  return Text(
                                      snapshot.data.shopName.toUpperCase(),
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
                                Text('Ref. Order:'),
                                SizedBox(width: 8),
                                Text(_referenceOrder ?? '[null]'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Tanggal:'),
                                SizedBox(width: 8),
                                Text(Formatter.dateFormat(_orderDate)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Kasir:'),
                                SizedBox(width: 8),
                                Text(_cashierName ?? '[null]'),
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
                                  itemCount: widget.itemList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              AutoSizeText(
                                                'x${widget.itemList[index].quantity}',
                                              ),
                                              SizedBox(width: 15),
                                              Container(
                                                width: 250,
                                                child: AutoSizeText(
                                                  widget.itemList[index]
                                                      .productName,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            child: AutoSizeText(
                                              Formatter.currencyFormat(
                                                  widget.itemList[index].price *
                                                      widget.itemList[index]
                                                          .quantity),
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
                            FooterOrderList(
                              dicount: widget.state.discountTotal,
                              grandTotal: widget.state.grandTotal,
                              subtotal: widget.state.subTotal,
                              vat: widget.state.taxFinal,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Pembayaran',
                                    style: kGrandTotalTextStyle,
                                  ),
                                  Text(
                                    widget.paymentType == PaymentType.CASH
                                        ? Formatter.currencyFormat(
                                            widget.pembayaran)
                                        : Formatter.currencyFormat(
                                            widget.state.grandTotal),
                                    style: kGrandTotalTextStyle,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Kembali',
                                    style: kGrandTotalTextStyle,
                                  ),
                                  Text(
                                    widget.paymentType == PaymentType.CASH
                                        ? Formatter.currencyFormat(
                                            widget.kembali)
                                        : Formatter.currencyFormat(0),
                                    style: kGrandTotalTextStyle,
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
                ),
                SizedBox(width: 5),
                Container(
                  width: 1.5,
                  color: Colors.grey,
                ),

                //RIGHSIDE
                Expanded(
                    flex: 2,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  'Koneksi Bluetooth:',
                                  style: kPriceTextStyle,
                                ),
                                SizedBox(width: 10),
                                StreamBuilder<int>(
                                    stream: bluetoothManager.state,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError)
                                        return Text(snapshot.error.toString(),
                                            style: kPriceTextStyle);
                                      if (!snapshot.hasData ||
                                          snapshot.connectionState ==
                                              ConnectionState.waiting)
                                        return Text(
                                          'Loading...',
                                          style: kPriceTextStyle,
                                        );

                                      return snapshot.data ==
                                              BLUETOOTH_DISCONNECTED
                                          ? Text('Tidak Aktif',
                                              style: kPriceTextStyle)
                                          : Text(
                                              'Aktif',
                                              style: kPriceTextStyle,
                                            );
                                    }),
                                SizedBox(width: 10),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.check_circle_outline,
                                size: MediaQuery.of(context).size.width * 0.15,
                                color: Colors.green,
                              ),
                              Text(
                                'Pembayaran Berhasil',
                                style: TextStyle(fontSize: 25),
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget>[
                                    CostumButton.squareButtonSmall(
                                        'Cetak Kwitansi',
                                        prefixIcon: Icons.print,
                                        onTap: () => printStruck(_shopName)),
                                    SizedBox(height: 10),
                                    CostumButton.squareButtonSmall(
                                      'Selesai',
                                      prefixIcon: Icons.done,
                                      borderColor: Colors.green,
                                      onTap: () =>
                                          _onTransactionComplete(context),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> printStruck(String shopName) async {
    var printer = await PrinterService.loadPrinterDevice();
    //* Print if printer has set and bluetooth is active
    if (printer.name != null && bluetoothStatus != BLUETOOTH_DISCONNECTED) {
      PrinterService.printStruck(
        printer: PrinterBluetooth(printer),
        state: widget.state,
        shopName: shopName,
        itemList: widget.itemList,
        pembayaran: widget.pembayaran,
        kembali: widget.kembali,
      );
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
    }
  }

  Future<void> _onTransactionComplete(BuildContext context) {
    //reset variable
    Provider.of<PostedOrderProvider>(context, listen: false)
        .resetFinalPayment();
    Provider.of<OrderListProvider>(context, listen: false).resetFinalPayment();
    Provider.of<OrderListProvider>(context, listen: false).resetOrderList();

    //Navigate to Main Page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => POSPage()),
      ModalRoute.withName('/pos'),
    );

    return null;
  }
}
