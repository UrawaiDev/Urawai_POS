import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/Models/orderList.dart';
import 'package:urawai_pos/Models/products.dart';
import 'package:urawai_pos/Pages/postedOrderList.dart';

import 'package:urawai_pos/Provider/general_provider.dart';
import 'package:urawai_pos/Provider/orderList_provider.dart';
import 'package:urawai_pos/Widgets/costum_DialogBox.dart';
import 'package:urawai_pos/Widgets/footer_OrderList.dart';
import 'package:urawai_pos/constans/utils.dart';
import 'package:uuid/uuid.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _formatCurrency = NumberFormat("#,##0", "en_US");
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

  // List<OrderList> orderLists = [];

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
                                style: priceTextStyle,
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
                                              child: _detailItemOrder(
                                                  productName:
                                                      currentOrderList[index]
                                                          .productName,
                                                  price: currentOrderList[index]
                                                      .price,
                                                  quantity:
                                                      currentOrderList[index]
                                                          .quantity,
                                                  onLongPress: () {
                                                    print(
                                                        currentOrderList[index]
                                                            .productName);
                                                  },
                                                  onMinusButtonTap: () {
                                                    if (currentOrderList[index]
                                                            .quantity >
                                                        1)
                                                      orderlistState
                                                          .decrementQuantity(
                                                              index);
                                                  },
                                                  onPlusButtonTap: () {
                                                    if (currentOrderList[index]
                                                            .quantity <=
                                                        999)
                                                      orderlistState
                                                          .incrementQuantity(
                                                              index);
                                                  }),
                                            );
                                          }),
                                ),
                              ),
                            ),
                          ),

                    Container(
                      child: FooterOrderList(),
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
            IconButton(
              icon: Icon(Icons.restaurant_menu),
              iconSize: 35,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PostedOrderList()));
              },
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
                  CostumDialogBox myDialog = CostumDialogBox();

                  myDialog.showCostumDialogBox(
                    context: context,
                    title: 'Information',
                    contentString:
                        'Orderlist Sebelumnya belum disimpan, Apakah akan tetap dibuatkan order List Baru?',
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

  Widget _detailItemOrder({
    String productName,
    double price,
    int quantity,
    Function onLongPress,
    Function onMinusButtonTap,
    Function onPlusButtonTap,
  }) {
    return Column(
      children: <Widget>[
        GestureDetector(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 700),
            curve: Curves.bounceOut,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Item Detail
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        productName,
                        style: bodyTextStyle,
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Rp. ' + _formatCurrency.format(price),
                        style: priceTextStyle,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          Icon(Icons.note),
                          SizedBox(width: 5),
                          Text(
                            'Catatan',
                            style: noteTextStyle,
                          )
                        ],
                      )
                    ],
                  ),

                  //Button plus & minus
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          width: 35,
                          height: 35,
                          color: greyColor,
                          child: Icon(
                            Icons.remove,
                            color: Colors.white,
                          ),
                        ),
                        onTap: onMinusButtonTap,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 35,
                        color: Colors.white,
                        child: Text(
                          quantity.toString(),
                          style: bodyTextStyle,
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          width: 35,
                          height: 35,
                          color: greyColor,
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                        onTap: onPlusButtonTap,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          onLongPress: onLongPress,
        ),
        Divider(),
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
              style: bodyTextStyle,
            ),
            SizedBox(height: 5),
            Text(
              'Rp. ' + _formatCurrency.format(productPrice),
              style: priceTextStyle,
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
