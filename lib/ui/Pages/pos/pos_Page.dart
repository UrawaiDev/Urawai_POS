import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/core/Models/postedOrder.dart';
import 'package:urawai_pos/core/Models/products.dart';
import 'package:urawai_pos/core/Provider/general_provider.dart';
import 'package:urawai_pos/core/Provider/orderList_provider.dart';
import 'package:urawai_pos/core/Provider/postedOrder_provider.dart';
import 'package:urawai_pos/core/Services/connectivity_service.dart';
import 'package:urawai_pos/ui/Pages/Transacation_history/transaction_history.dart';
import 'package:urawai_pos/ui/Pages/payment_screen/payment_screen.dart';
import 'package:urawai_pos/ui/Pages/transaction_report/transaction_report.dart';
import 'package:urawai_pos/ui/Widgets/costum_DialogBox.dart';
import 'package:urawai_pos/ui/Widgets/detail_itemOrder.dart';
import 'package:urawai_pos/ui/Widgets/extraDiscount.dart';
import 'package:urawai_pos/ui/Widgets/footer_OrderList.dart';
import 'package:urawai_pos/ui/utils/constans/formatter.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';

class POSPage extends StatefulWidget {
  @override
  _POSPageState createState() => _POSPageState();
  static const String routeName = '/pos';
  static const String postedBoxName = "posted_order";
  static const String transactionBoxName = "TransactionOrder";
}

class _POSPageState extends State<POSPage> with SingleTickerProviderStateMixin {
  final TextEditingController _textReferenceOrder = TextEditingController();
  final TextEditingController _textNote = TextEditingController();
  final TextEditingController _textExtraDiscount = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  AnimationController _animationController;
  Animation<double> _animationScale;

  List<Product> products = [
    Product(
      id: 1,
      name: 'Nasi Goreng',
      image: 'assets/images/nasi_goreng.jpg',
      price: 20000,
      isRecommended: false,
      category: 1,
      discount: 10,
    ),
    Product(
      id: 2,
      name: 'Bakmi Ayam Pedas',
      image: 'assets/images/bakmi_ayam_pedas.jpg',
      price: 25030,
      isRecommended: false,
      category: 1,
    ),
    Product(
      id: 3,
      name: 'Bakmi Ayam Spesial',
      image: 'assets/images/bakmi_ayam_spesial.png',
      price: 25000,
      isRecommended: true,
      category: 1,
    ),
    Product(
      id: 4,
      name: 'Bakmi Biasa',
      image: 'assets/images/bakmi.jpg',
      price: 25000,
      isRecommended: false,
      category: 1,
    ),
    Product(
      id: 5,
      name: 'Bakso Sapi',
      image: 'assets/images/bakso.jpg',
      price: 30000,
      isRecommended: true,
      category: 1,
    ),
    Product(
      id: 6,
      name: 'Pizza Double Cheese',
      image: 'assets/images/pizza_cheese.png',
      price: 80000,
      isRecommended: false,
      category: 1,
    ),
    Product(
      id: 7,
      name: 'Es Kopi Susu',
      image: 'assets/images/eskopi_susu.jpg',
      price: 22000,
      isRecommended: true,
      category: 1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      value: 0.1,
      duration: Duration(seconds: 1),
    );

    _animationScale = CurvedAnimation(
        parent: _animationController, curve: Curves.bounceInOut);
    _animationController.forward();
  }

  @override
  void dispose() {
    _textReferenceOrder.dispose();
    _textNote.dispose();
    _textExtraDiscount.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    var orderlistState = Provider.of<OrderListProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //lefside - halaman menu
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0),
                    child: SingleChildScrollView(
                      child: Container(
                          color: Colors.white,
                          // width: MediaQuery.of(context).size.width * 0.6,
                          child: Column(
                            children: <Widget>[
                              MyAppBar(),
                              Consumer<GeneralProvider>(
                                builder: (context, generalState, _) => Row(
                                  children: <Widget>[
                                    //drawer Menue
                                    generalState.isDrawerShow
                                        ? listMenu(screenHeight)
                                        : Container(),

                                    //menu content
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        color: Color(0xFFfbfcfe),
                                        // color: Colors.yellow,
                                        height: screenHeight - 120,
                                        child: GridView.count(
                                          shrinkWrap: true,
                                          crossAxisCount:
                                              generalState.isDrawerShow ? 2 : 3,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 10,
                                          children: products.map((itemProduct) {
                                            return _cardMenu(itemProduct);
                                          }).toList(),
                                        ),
                                      ),
                                    ),

                                    //menu in GridView
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ),
                  )),
              //RIGHT SIDE MENU ORDER LIST
              Expanded(
                  child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.fromLTRB(5, 20, 5, 15),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Consumer<ConnectivityResult>(
                                builder: (context, value, _) =>
                                    Text('$value' ?? '[null]')),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[_headerOrderList()],
                            ),
                            //ORDERED ITEM LIST
                            orderlistState.orderlist.isEmpty
                                ? Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Tidak Ada Pesanan',
                                        style: kPriceTextStyle,
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5.0),
                                      child: Container(
                                        child: Consumer<OrderListProvider>(
                                          builder: (context, orderlistState,
                                                  _) =>
                                              ListView.builder(
                                                  itemCount: orderlistState
                                                      .orderlist.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var currentOrderList =
                                                        orderlistState
                                                            .orderlist;
                                                    final itemKey =
                                                        currentOrderList[index];

                                                    return Dismissible(
                                                      key: ValueKey(itemKey),
                                                      background: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        color: Colors.red,
                                                        child: Text(
                                                          'Hapus',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 35,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      onDismissed: (direction) {
                                                        orderlistState
                                                            .removeFromList(
                                                                index);
                                                      },
                                                      child: DetailItemOrder(
                                                        itemList:
                                                            currentOrderList[
                                                                index],
                                                        onMinusButtonTap: () =>
                                                            orderlistState
                                                                .decrementQuantity(
                                                                    index),
                                                        onPlusButtonTap: () =>
                                                            orderlistState
                                                                .incrementQuantity(
                                                                    index),
                                                        onAddNoteTap: () {
                                                          CostumDialogBox
                                                              .showInputDialogBox(
                                                                  formKey:
                                                                      _formKey,
                                                                  context:
                                                                      context,
                                                                  textEditingController:
                                                                      _textNote,
                                                                  title:
                                                                      'Catatan',
                                                                  confirmButtonTitle:
                                                                      'OK',
                                                                  onConfirmPressed:
                                                                      () {
                                                                    orderlistState.addNote(
                                                                        _textNote
                                                                            .text,
                                                                        index);
                                                                    _textNote
                                                                        .clear();

                                                                    Navigator.pop(
                                                                        context);
                                                                  });
                                                        },
                                                        childWidget:
                                                            Container(),
                                                      ),
                                                    );
                                                  }),
                                        ),
                                      ),
                                    ),
                                  ),
                            Container(
                              child: FooterOrderList(
                                dicount: orderlistState.discountTotal,
                                grandTotal: orderlistState.grandTotal,
                                subtotal: orderlistState.subTotal,
                                tax: 0.1,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    _bottomButton(
                                        icon: Icon(Icons.save,
                                            color: Colors.blue),
                                        title: 'Simpan',
                                        onTap: () {
                                          if (orderlistState
                                                  .orderID.isNotEmpty &&
                                              orderlistState
                                                  .orderlist.isNotEmpty) {
                                            if (orderlistState.addPostedOrder(
                                                orderlistState)) {
                                              CostumDialogBox
                                                  .showDialogInformation(
                                                      title: 'Information',
                                                      contentText:
                                                          'Daftar sudah disimpan kedalam Draft',
                                                      context: context,
                                                      icon: Icons.info,
                                                      iconColor: Colors.blue,
                                                      onTap: () {
                                                        orderlistState
                                                            .resetOrderList();
                                                        Navigator.pop(context);
                                                      });
                                            }
                                            //set cashier name for PostedOrder Provider
                                            Provider.of<PostedOrderProvider>(
                                                        context,
                                                        listen: false)
                                                    .cashierName =
                                                orderlistState.cashierName;
                                          }
                                        }),
                                    _bottomButton(
                                        icon: Icon(Icons.disc_full),
                                        title: 'Diskon',
                                        onTap: () {
                                          //   var box = Hive.box<TransactionOrder>(
                                          //       POSPage.transactionBoxName);

                                          //   print('------------------');
                                          //   print(
                                          //       'Jumlah Transaction Order (${box.length})');
                                          //   print('------------------');

                                          //   box.values.forEach((f) {
                                          //     print(f.id);
                                          //     // box.delete(f.id);
                                          //     print('Order Date : ${f.date}');
                                          //     print(
                                          //         'Jumlah item : ${f.itemList.length}');
                                          //     print(f.paymentStatus);
                                          //   });

                                          if (orderlistState
                                              .orderlist.isNotEmpty) {
                                            showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) =>
                                                    ExtraDiscoutDialog());
                                          }
                                        }),
                                    _bottomButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        title: 'Hapus',
                                        onTap: () {
                                          if (orderlistState
                                              .orderlist.isNotEmpty) {
                                            CostumDialogBox.showCostumDialogBox(
                                                context: context,
                                                title: 'Konfirmasi',
                                                contentString:
                                                    'List Order akan di Hapus',
                                                icon: Icons.delete,
                                                iconColor: Colors.red,
                                                confirmButtonTitle: 'Hapus',
                                                onConfirmPressed: () {
                                                  orderlistState
                                                      .resetOrderList();
                                                  Navigator.pop(context);
                                                });
                                          }
                                        }),
                                  ],
                                ),
                                Expanded(
                                  child: RaisedButton(
                                      padding: EdgeInsets.all(0),
                                      child: Container(
                                          alignment: Alignment.center,
                                          height: 60,
                                          color: Color(0xFF408be5),
                                          child: Text(
                                            'BAYAR',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )),
                                      onPressed: () {
                                        //SEMENTARA
                                        if (orderlistState.orderlist.isNotEmpty)
                                          Navigator.pushNamed(
                                              context, PaymentScreen.routeName,
                                              arguments:
                                                  orderlistState.orderlist);
                                      }),
                                )
                              ],
                            ),
                          ]))),

              //Right side -- menu penjuala
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerOrderList() {
    var orderlistProvider = Provider.of<OrderListProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ValueListenableBuilder(
              valueListenable:
                  Hive.box<PostedOrder>(POSPage.postedBoxName).listenable(),
              builder: (context, boxOrder, _) => Stack(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.restaurant_menu),
                    iconSize: 35,
                    onPressed: () {
                      if (orderlistProvider.referenceOrder.isNotEmpty) {
                        CostumDialogBox.showCostumDialogBox(
                          context: context,
                          title: 'Information',
                          contentString:
                              'Orderlist Sebelumnya belum disimpan, \n Tetap Lanjut?',
                          icon: Icons.info,
                          iconColor: Colors.blue,
                          confirmButtonTitle: 'Ya',
                          onConfirmPressed: () {
                            Navigator.pop(context); //close dialogBox
                            orderlistProvider.resetOrderList();
                            _showPostedOrderList(context, boxOrder);
                          },
                        );
                      } else {
                        _showPostedOrderList(context, boxOrder);
                      }
                    },
                  ),
                  //Notification PostedOrder
                  boxOrder.length != 0
                      ? Positioned(
                          top: 0,
                          right: 0,
                          child: CircleAvatar(
                            maxRadius: 13,
                            backgroundColor: Colors.red,
                            child: Text(
                              boxOrder.length.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            Consumer<OrderListProvider>(
              builder: (_, orderlistState, __) => Text(
                'Pesanan (${orderlistState.orderlist.length})',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            ScaleTransition(
              scale: _animationScale,
              child: IconButton(
                icon: Icon(Icons.add),
                iconSize: 35,
                onPressed: () {
                  if (orderlistProvider.orderlist.isEmpty) {
                    _createNewOrder(orderlistProvider);
                  } else if (orderlistProvider.orderlist.isNotEmpty) {
                    CostumDialogBox.showCostumDialogBox(
                      context: context,
                      title: 'Information',
                      contentString:
                          'Orderlist Sebelumnya belum disimpan, \nApakah akan tetap dibuatkan order List Baru?',
                      icon: Icons.info,
                      iconColor: Colors.blue,
                      confirmButtonTitle: 'Ya',
                      onConfirmPressed: () {
                        Navigator.pop(context); //close dialogBox
                        _createNewOrder(orderlistProvider);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
        Divider(
          thickness: 3,
          color: greyColor,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Ref. Order: ',
              style: TextStyle(
                color: priceColor,
                fontSize: 18,
              ),
            ),
            Container(
              child: Consumer<OrderListProvider>(
                builder: (context, state, _) => Text(
                  state.referenceOrder ?? '[null]',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: priceColor,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
        Consumer<OrderListProvider>(
          builder: (_, orderlistState, __) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: Text(
                  'Order List: ' + orderlistState.orderID.toString(),
                  style: TextStyle(
                    color: priceColor,
                    fontSize: 18,
                  ),
                ),
              ),
              Text(Formatter.dateFormat(orderlistState.orderDate),
                  style: TextStyle(
                    color: priceColor,
                    fontSize: 16,
                  )),
            ],
          ),
        ),
        Divider(
          thickness: 3,
          color: greyColor,
        ),
      ],
    );
  }

  Future _showPostedOrderList(BuildContext context, boxOrder) {
    return showDialog(
      context: context,
      child: Dialog(
        child: Container(
          width: 500,
          height: 500,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.format_list_bulleted,
                      color: Colors.blue,
                      size: 35,
                    ),
                    SizedBox(width: 10),
                    Text('Daftar Pesanan yang tersimpan.',
                        style: TextStyle(fontSize: 22)),
                  ],
                ),
                SizedBox(height: 15),
                Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  child: boxOrder.length == 0
                      ? Text('Tidak Ada Pesanan dalam Draft',
                          style: TextStyle(fontSize: 22))
                      : ListView.builder(
                          itemCount: boxOrder.length,
                          itemBuilder: (context, index) {
                            var item = boxOrder.getAt(index) as PostedOrder;
                            return ListTile(
                              contentPadding: EdgeInsets.all(8),
                              leading: CircleAvatar(
                                child: Text((index + 1).toString()),
                              ),
                              title: Text(item.refernceOrder ?? '-',
                                  style: TextStyle(fontSize: 22)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      'Jumlah Pesanan : ${item.orderList.length}',
                                      style: TextStyle(fontSize: 22)),
                                  Text(
                                      'Total Bayar ' +
                                          Formatter.currencyFormat(
                                              item.grandTotal),
                                      style: TextStyle(fontSize: 22)),
                                ],
                              ),
                              trailing: Icon(
                                Icons.play_arrow,
                                size: 35,
                                color: Colors.blue,
                              ),
                              onLongPress: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(
                                    context, PaymentScreen.routeName,
                                    arguments: item);
                              },
                            );
                          }),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _createNewOrder(OrderListProvider orderlistProvider) {
    CostumDialogBox.showInputDialogBox(
        formKey: _formKey,
        context: context,
        textEditingController: _textReferenceOrder,
        title: 'Nama Pelanggan / Nomor Meja',
        confirmButtonTitle: 'OK',
        onConfirmPressed: () {
          if (_formKey.currentState.validate()) {
            orderlistProvider.resetOrderList();
            orderlistProvider.referenceOrder = _textReferenceOrder.text;
            orderlistProvider.cashierName =
                'Dummy Cashier XXX'; //override Cashier Name HERE
            orderlistProvider.createNewOrder();
            _textReferenceOrder.clear();
            Navigator.pop(context);
          }
        });
  }

  Widget _cardMenu(Product product) {
    var orderlistProvider =
        Provider.of<OrderListProvider>(context, listen: false);

    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      child: Container(
        // color: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: greyColor,
                    ),
                    child: Container(
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(
                              product.image,
                            ),
                            fit: BoxFit.cover,
                          )),
                      // color: Colors.yellow,
                    ),
                  ),
                  product.isRecommended
                      ? Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            width: 30,
                            height: 30,
                            child: Image.asset('assets/images/chef-hat.png'),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              product.name,
              style: screenWidth > 1024
                  ? kProductNameBigScreenTextStyle
                  : kProductNameSmallScreenTextStyle,
            ),
            SizedBox(height: 5),
            product.discount == 0 || product.discount == null
                ? Text(
                    Formatter.currencyFormat(product.price),
                    style: kPriceTextStyle,
                  )
                : Column(
                    children: <Widget>[
                      Text(
                        Formatter.currencyFormat(product.price),
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Text(
                        Formatter.currencyFormat(product.price -
                            (product.price * (product.discount / 100))),
                        style: kPriceTextStyle,
                      ),
                    ],
                  )
          ],
        ),
      ),
      onDoubleTap: () {
        if (orderlistProvider.orderID.isNotEmpty) {
          orderlistProvider.addToList(
            item: product,
            referenceOrder: orderlistProvider.referenceOrder,
          );
        } else {
          _animationController.forward();
        }
      },
    );
  }

  Widget _bottomButton({String title, Icon icon, Function onTap}) {
    return GestureDetector(
      child: Container(
        width: 60,
        height: 60,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: greyColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon,
            Text(
              title,
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
      onTap: onTap,
    );
  }

  Widget listMenu(double screenHeight) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Container(
          color: Colors.white,
          height: screenHeight - 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                color: Color(0xFFebf2fd),
                child: ListTile(
                  leading: Icon(Icons.home),
                  title: (Text(
                    'Beranda',
                    style: kMainMenuStyle,
                  )),
                  selected: true,
                  onTap: () {},
                ),
              ),
              ListTile(
                  leading: FaIcon(FontAwesomeIcons.cashRegister),
                  title: (Text(
                    'Transaksi',
                    style: kMainMenuStyle,
                  ))),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.clipboardList),
                title: (Text(
                  'Riwayat Transaksi',
                  style: kMainMenuStyle,
                )),
                onTap: () => Navigator.pushNamed(
                    context, TransactionHistoryPage.routeName),
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.book),
                title: (Text(
                  'Laporan',
                  style: kMainMenuStyle,
                )),
                onTap: () =>
                    Navigator.pushNamed(context, TransactionReport.routeName),
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.cog),
                title: (Text(
                  'Pengaturan',
                  style: kMainMenuStyle,
                )),
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.lifeRing),
                title: (Text('Bantuan', style: kMainMenuStyle)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawerMenu(double screenHeight) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: Container(
          color: Colors.white,
          height: screenHeight - 120,
          child: ListView(
            children: <Widget>[
              Container(
                child: Text(
                  'MAIN DISH',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                color: Color(0xFFebf2fd),
                child: ListTile(
                  leading: Icon(Icons.home),
                  title: (Text('Bakmie')),
                  selected: true,
                  onTap: () {},
                ),
              ),
              ListTile(
                leading: Icon(Icons.hot_tub),
                title: (Text('Nasi Goreng')),
              ),
              ListTile(
                leading: Icon(Icons.http),
                title: (Text('Beef Steak')),
              ),
              ListTile(
                leading: Icon(Icons.import_export),
                title: (Text('Bakso')),
              ),
              Container(
                child: Text(
                  'LIGHT BITES',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: (Text('Crispy Chikens')),
              ),
              ListTile(
                leading: Icon(Icons.hot_tub),
                title: (Text('Roti Bakar')),
              ),
              ListTile(
                leading: Icon(Icons.http),
                title: (Text('French Fries Original')),
              ),
              ListTile(
                leading: Icon(Icons.import_export),
                title: (Text('Muffin')),
              ),
              Container(
                child: Text(
                  'DRINKS',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: (Text('Hot Coffee')),
              ),
              ListTile(
                leading: Icon(Icons.hot_tub),
                title: (Text('Cappucino Hot/Cold')),
              ),
              ListTile(
                leading: Icon(Icons.http),
                title: (Text('Kopi Hitam')),
              ),
              ListTile(
                leading: Icon(Icons.import_export),
                title: (Text('Kopi Arang')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 5, 8),
      child: Container(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.menu),
              iconSize: 35,
              color: Color(0xFFcdd3d6),
              onPressed: () {
                var state =
                    Provider.of<GeneralProvider>(context, listen: false);
                state.isDrawerShow = !state.isDrawerShow;
              },
            ),
            Row(
              children: <Widget>[
                Icon(Icons.archive),
                SizedBox(width: 20),
                Text('Urawai POS',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFf0f5f6),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Cari menu, Makanan , dll',
                    suffixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
