import 'package:flutter/material.dart';
import 'package:urawai_pos/Pages/Models/orderList.dart';
import 'package:urawai_pos/Pages/Models/products.dart';
import 'constans/utils.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isDrawerShow = true;

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
  ];

  List<OrderList> orderLists = [];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                              _appBar(),
                              Row(
                                children: <Widget>[
                                  //drawer Menue
                                  isDrawerShow
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
                                        crossAxisCount: isDrawerShow ? 2 : 3,
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

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Container(
                          child: ListView.builder(
                              itemCount: orderLists.length,
                              itemBuilder: (context, index) {
                                final itemKey = orderLists[index];

                                return Dismissible(
                                  key: ValueKey(itemKey),
                                  background: Container(color: Colors.red),
                                  onDismissed: (direction) {
                                    setState(() {
                                      orderLists.removeAt(index);
                                    });
                                  },
                                  child: _detailItemOrder(
                                    productName: orderLists[index].productName,
                                    price: orderLists[index].price,
                                    quantity: orderLists[index].quantity,
                                    onLongPress: () {
                                      print(orderLists[index].productName);
                                    },
                                  ),
                                );

                                // return _detailItemOrder(
                                //     productName: orderLists[index].productName,
                                //     price: orderLists[index].price,
                                //     quantity: orderLists[index].quantity,
                                //     keyIndex: itemKey,
                                //     onLongPress: () {
                                //       print(orderLists[index].productName);
                                //     },
                                //     onDismiss: (direction) {
                                //       setState(() {
                                //         orderLists.removeAt(index);
                                //       });
                                //     });
                              }),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[_footerOrderList()],
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

  Widget _footerOrderList() {
    return Column(
      children: <Widget>[
        Divider(thickness: 3),
        SizedBox(height: 8),
        _bottomInfo(title: 'Subtotal', value: 'Rp. 177,247,-'),
        SizedBox(height: 8),
        _bottomInfo(title: 'Diskon (0%)', value: 'Rp. 0,-'),
        SizedBox(height: 8),
        _bottomInfo(title: 'Pajak (10%)', value: 'Rp. 17,724,-'),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _bottomButton(icon: Icons.save, title: 'Simpan'),
                _bottomButton(icon: Icons.disc_full, title: 'Diskon'),
                _bottomButton(
                    icon: Icons.check_box_outline_blank, title: 'Split Bill'),
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
                  onPressed: null),
            )
          ],
        ),
      ],
    );
  }

  Widget _headerOrderList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(Icons.restaurant_menu, size: 35),
            Text(
              'Pesanan (${orderLists.length})',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Icon(
              Icons.add,
              size: 35,
            ),
          ],
        ),
        Divider(
          thickness: 3,
          color: greyColor,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              'Order List #1',
              style: TextStyle(
                color: priceColor,
                fontSize: 18,
              ),
            ),
            Text('Kamis, 4 April 2020 | 17:20:01',
                style: TextStyle(
                  color: priceColor,
                  fontSize: 18,
                )),
          ],
        ),
        Divider(
          thickness: 3,
          color: greyColor,
        ),
      ],
    );
  }

  Widget _bottomButton({String title, IconData icon}) {
    return Container(
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
          Icon(icon),
          Text(
            title,
            style: TextStyle(color: Colors.black),
          )
        ],
      ),
    );
  }

  Widget _bottomInfo({String title, String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: priceTextStyle,
          ),
          Text(
            value,
            style: priceTextStyle,
          ),
        ],
      ),
    );
  }

  Widget _detailItemOrder({
    String productName,
    double price,
    int quantity,
    Function onLongPress,
  }) {
    return Column(
      children: <Widget>[
        GestureDetector(
          child: Container(
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
                        'Rp. ' + price.toString(),
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
                      Container(
                        width: 35,
                        height: 35,
                        color: greyColor,
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
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
                      Container(
                        width: 35,
                        height: 35,
                        color: greyColor,
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
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

  Widget _cardMenu(
      {int id,
      String productName,
      double productPrice,
      bool isRecommended = false,
      String imagePath}) {
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
              'Rp. ' + productPrice.toString(),
              style: priceTextStyle,
            ),
          ],
        ),
      ),
      onDoubleTap: () {
        print(productName);
        orderLists.add(OrderList(
          productName: productName,
          price: productPrice,
          dateTime: DateTime.now(),
          quantity: 1,
        ));
        setState(() {});
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

  Widget _appBar() {
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
                setState(() {
                  isDrawerShow = !isDrawerShow;
                });
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
