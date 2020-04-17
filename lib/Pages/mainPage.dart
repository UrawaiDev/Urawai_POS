import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/Models/orderList.dart';
import 'package:urawai_pos/Models/postedOrder.dart';
import 'package:urawai_pos/Models/products.dart';
import 'package:urawai_pos/Pages/payment_screen_draftOrder.dart';
import 'package:urawai_pos/Pages/payment_success.dart';

import 'package:urawai_pos/Provider/general_provider.dart';
import 'package:urawai_pos/Provider/orderList_provider.dart';
import 'package:urawai_pos/Widgets/costum_DialogBox.dart';
import 'package:urawai_pos/Widgets/detail_itemOrder.dart';
import 'package:urawai_pos/Widgets/footer_OrderList.dart';
import 'package:urawai_pos/constans/utils.dart';
import 'package:urawai_pos/main.dart';
import 'package:uuid/uuid.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
  static const postedBoxName = "posted_order";
}

class _MainPageState extends State<MainPage> {
  final _formatCurrency = NumberFormat.currency(
    symbol: 'Rp.',
    locale: 'en_US',
    decimalDigits: 0,
  );
  final _uuid = Uuid();

  List<Product> products = [
    Product(
      id: 1,
      name: 'Nasi Goreng',
      image: 'assets/images/nasi_goreng.jpg',
      price: 20000,
      isRecommended: false,
      category: 1,
    ),
    Product(
      id: 2,
      name: 'Bakmi Ayam Pedas',
      image: 'assets/images/bakmi_ayam_pedas.jpg',
      price: 25000,
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
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    var orderlistState = Provider.of<OrderListProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
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
                                        ? drawerMenu(screenHeight)
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
                                          children: products.map((p) {
                                            return _cardMenu(
                                              id: p.id,
                                              productName: p.name,
                                              productPrice: p.price,
                                              imagePath: p.image,
                                              isRecommended: p.isRecommended,
                                            );
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Container(
                                child: Consumer<OrderListProvider>(
                                  builder: (context, orderlistState, _) =>
                                      ListView.builder(
                                          itemCount:
                                              orderlistState.orderlist.length,
                                          itemBuilder: (context, index) {
                                            var currentOrderList =
                                                orderlistState.orderlist;
                                            final itemKey =
                                                currentOrderList[index];

                                            return Dismissible(
                                              key: ValueKey(itemKey),
                                              background: Container(
                                                alignment: Alignment.center,
                                                color: Colors.red,
                                                child: Text(
                                                  'Hapus',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 35,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              onDismissed: (direction) {
                                                orderlistState
                                                    .removeFromList(index);
                                              },
                                              child: DetailItemOrder(
                                                productName:
                                                    currentOrderList[index]
                                                        .productName,
                                                price: currentOrderList[index]
                                                    .price,
                                                quantity:
                                                    currentOrderList[index]
                                                        .quantity,
                                                onLongPress: () {
                                                  print(currentOrderList[index]
                                                      .productName);
                                                },
                                                onMinusButtonTap: () =>
                                                    orderlistState
                                                        .decrementQuantity(
                                                            index),
                                                onPlusButtonTap: () =>
                                                    orderlistState
                                                        .incrementQuantity(
                                                            index),
                                                childWidget: Container(),
                                              ),
                                            );
                                          }),
                                ),
                              ),
                            ),
                          ),

                    Column(
                      children: <Widget>[
                        Container(
                          child: FooterOrderList(
                            dicount: 0,
                            grandTotal: orderlistState.getGrandTotal(),
                            subtotal: orderlistState.getSubtotal(),
                            tax: 0.1,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                _bottomButton(
                                    icon: Icon(Icons.save, color: Colors.blue),
                                    title: 'Simpan',
                                    onTap: () {
                                      if (orderlistState.orderID.isNotEmpty &&
                                          orderlistState.orderlist.isNotEmpty) {
                                        print(
                                            'save ${orderlistState.orderlist.length} Item(s) to DB');

                                        var orderBox = Hive.box<PostedOrder>(
                                            postedOrderBox);

                                        var hiveValue = PostedOrder(
                                          id: orderlistState.orderID,
                                          orderDate: orderlistState.orderDate,
                                          subtotal:
                                              orderlistState.getSubtotal(),
                                          discount: 0,
                                          grandTotal:
                                              orderlistState.getGrandTotal(),
                                          orderList:
                                              orderlistState.orderlist.toList(),
                                          paidStatus: PaidStatus.UnPaid,
                                        );

                                        //SAVE TO DATABASE
                                        orderBox.put(
                                            orderlistState.orderID, hiveValue);

                                        showDialog(
                                          barrierDismissible: false,
                                          child: AlertDialog(
                                            title: Text('Informasi Pesanan',
                                                style: kDialogTextStyle),
                                            content: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.info,
                                                  size: 40,
                                                  color: Colors.blue,
                                                ),
                                                SizedBox(width: 10),
                                                Text('Pesanan sudah disimpan.',
                                                    style: kDialogTextStyle),
                                              ],
                                            ),
                                            actions: <Widget>[
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);

                                                    orderlistState
                                                        .resetOrderList();
                                                  },
                                                  child: Text('OK',
                                                      style: kDialogTextStyle))
                                            ],
                                          ),
                                          context: context,
                                        );
                                      }
                                    }),
                                _bottomButton(
                                    icon: Icon(Icons.disc_full),
                                    title: 'Diskon'),
                                _bottomButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    title: 'Hapus',
                                    onTap: () {
                                      if (orderlistState.orderlist.isNotEmpty) {
                                        CostumDialogBox.showCostumDialogBox(
                                            context: context,
                                            title: 'Konfirmasi',
                                            contentString:
                                                'List Order akan di Hapus',
                                            icon: Icons.delete,
                                            iconColor: Colors.red,
                                            onCancelPressed: () =>
                                                Navigator.pop(context),
                                            confirmButtonTitle: 'Hapus',
                                            onConfirmPressed: () {
                                              orderlistState.orderlist.clear();
                                              orderlistState.resetOrderList();
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
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PaymentSuccess(
                                                      itemList: orderlistState
                                                          .orderlist)));
                                  }),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ))

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
            WatchBoxBuilder(
              box: Hive.box<PostedOrder>(postedOrderBox),
              builder: (context, boxOrder) => Stack(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.restaurant_menu),
                    iconSize: 35,
                    onPressed: () {
                      showDialog(
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
                                    // color: Colors.yellow,
                                    child: ListView.builder(
                                        itemCount: boxOrder.length,
                                        itemBuilder: (context, index) {
                                          var item = boxOrder.getAt(index)
                                              as PostedOrder;
                                          return ListTile(
                                            contentPadding: EdgeInsets.all(8),
                                            leading: CircleAvatar(
                                              child:
                                                  Text((index + 1).toString()),
                                            ),
                                            title: Text(item.id ?? '-',
                                                style: TextStyle(fontSize: 22)),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                    'Jumlah Pesanan : ${item.orderList.length}',
                                                    style: TextStyle(
                                                        fontSize: 22)),
                                                Text(
                                                    'Total Bayar ' +
                                                        _formatCurrency.format(
                                                            item.grandTotal),
                                                    style: TextStyle(
                                                        fontSize: 22)),
                                              ],
                                            ),
                                            trailing: Icon(
                                              Icons.play_arrow,
                                              size: 35,
                                              color: Colors.blue,
                                            ),
                                            onLongPress: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PaymentScreenDraftOrder(
                                                              item)));
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
            IconButton(
              icon: Icon(Icons.add),
              iconSize: 35,
              onPressed: () {
                if (orderlistProvider.orderlist.isEmpty) {
                  orderlistProvider.createNewOrder();
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
                      orderlistProvider.resetOrderList();
                      orderlistProvider.createNewOrder();
                      Navigator.pop(context);
                    },
                    onCancelPressed: () => Navigator.pop(context),
                  );
                }
              },
            ),
          ],
        ),
        Divider(
          thickness: 3,
          color: greyColor,
        ),
        Consumer<OrderListProvider>(
          builder: (_, orderlistState, __) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                child: Text(
                  'Order List #' + orderlistState.orderID.toString(),
                  style: TextStyle(
                    color: priceColor,
                    fontSize: 18,
                  ),
                ),
              ),
              Expanded(
                child: Text(orderlistState.orderDate.toString(),
                    style: TextStyle(
                      color: priceColor,
                      fontSize: 16,
                    )),
              ),
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

  Widget _cardMenu({
    int id,
    String productName,
    double productPrice,
    bool isRecommended = false,
    String imagePath,
  }) {
    var orderlistProvider =
        Provider.of<OrderListProvider>(context, listen: false);

    return GestureDetector(
      child: Container(
        // color: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: 210,
                  height: 185,
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
                            imagePath,
                          ),
                          fit: BoxFit.cover,
                        )),
                    // color: Colors.yellow,
                  ),
                ),
                isRecommended
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
            SizedBox(height: 10),
            Text(
              productName,
              style: kHeaderTextStyle,
            ),
            SizedBox(height: 5),
            Text(
              _formatCurrency.format(productPrice),
              style: kPriceTextStyle,
            ),
          ],
        ),
      ),
      onDoubleTap: () {
        if (orderlistProvider.orderID.isNotEmpty) {
          orderlistProvider.addToList(OrderList(
            id: _uuid.v1(),
            productName: productName,
            price: productPrice,
            dateTime: DateTime.now().toIso8601String(),
            quantity: 1,
          ));
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
