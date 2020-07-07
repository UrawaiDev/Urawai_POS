import 'dart:async';

import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:urawai_pos/core/Models/postedOrder.dart';
import 'package:urawai_pos/core/Models/products.dart';
import 'package:urawai_pos/core/Models/users.dart';
import 'package:urawai_pos/core/Provider/general_provider.dart';
import 'package:urawai_pos/core/Provider/orderList_provider.dart';
import 'package:urawai_pos/core/Provider/postedOrder_provider.dart';
import 'package:urawai_pos/core/Services/firebase_auth.dart';
import 'package:urawai_pos/core/Services/firestore_service.dart';
import 'package:urawai_pos/ui/Widgets/connection_status.dart';
import 'package:urawai_pos/ui/Widgets/costum_DialogBox.dart';
import 'package:urawai_pos/ui/Widgets/costum_button.dart';
import 'package:urawai_pos/ui/Widgets/detail_itemOrder.dart';
import 'package:urawai_pos/ui/Widgets/drawerMenu.dart';
import 'package:urawai_pos/ui/Widgets/extraDiscount.dart';
import 'package:urawai_pos/ui/Widgets/floating_button.dart';
import 'package:urawai_pos/ui/Widgets/footer_OrderList.dart';
import 'package:urawai_pos/ui/Widgets/loading_card.dart';
import 'package:urawai_pos/ui/utils/constans/formatter.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';
import 'package:urawai_pos/ui/utils/functions/general_function.dart';
import 'package:urawai_pos/ui/utils/functions/routeGenerator.dart';

class POSPage extends StatefulWidget {
  @override
  _POSPageState createState() => _POSPageState();
  static const String postedBoxName = "posted_order";
  static const String transactionBoxName = "TransactionOrder";
}

class _POSPageState extends State<POSPage> with SingleTickerProviderStateMixin {
  final TextEditingController _textReferenceOrder = TextEditingController();
  final TextEditingController _textNote = TextEditingController();
  final TextEditingController _textExtraDiscount = TextEditingController();
  final TextEditingController _textQuery = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirestoreServices _firestoreServices = FirestoreServices();
  final FirebaseAuthentication _auth = FirebaseAuthentication();
  final locatorAuth = GetIt.I<FirebaseAuthentication>();
  final locatorFirestore = GetIt.I<FirestoreServices>();

  AnimationController _animationController;
  Animation<double> _scalebtnAdd;
  Future<Users> currentUser;
  Future _getProduct;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      value: 0.5,
      duration: Duration(milliseconds: 700),
    );

    _scalebtnAdd = CurvedAnimation(
        parent: _animationController, curve: Curves.elasticInOut);
    _animationController.forward();

    currentUser = locatorAuth.currentUserXXX;
    currentUser.then((user) {
      _getProduct = locatorFirestore.getProducts(user.shopName);
    });
  }

  @override
  void dispose() {
    _textReferenceOrder.dispose();
    _textNote.dispose();
    _textExtraDiscount.dispose();
    _animationController.dispose();
    _textQuery.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<bool> _isBackButtonPressed() {
    return CostumDialogBox.showCostumDialogBox(
        context: context,
        title: 'Konfirmasi',
        icon: FontAwesomeIcons.signOutAlt,
        iconColor: Colors.red,
        contentString: 'Keluar dari Aplikasi?',
        confirmButtonTitle: 'Keluar',
        onConfirmPressed: () {
          locatorAuth.signOut();
          SystemNavigator.pop();
        });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final orderlistState =
        Provider.of<OrderListProvider>(context, listen: false);
    final generalProvider =
        Provider.of<GeneralProvider>(context, listen: false);

    DeviceScreenType deviceType = getDeviceType(MediaQuery.of(context).size);

    return SafeArea(
      child: FutureBuilder<Users>(
          future: currentUser,
          builder: (context, snapshot) {
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

            Users currentUser = snapshot.data;

            return GestureDetector(
              onTap: () {
                //dismiss softkeyboard
                FocusScope.of(context).unfocus();
              },
              child: WillPopScope(
                onWillPop: () => _isBackButtonPressed(),
                child: Scaffold(
                  floatingActionButton: deviceType == DeviceScreenType.tablet
                      ? Container()
                      : Container(
                          margin: EdgeInsets.only(left: 10),
                          alignment: Alignment.bottomLeft,
                          child: FloatingButton(
                            onDeleteTap: () => _onDeleteTap(orderlistState),
                            onDiscountTap: () => _onDiscountTap(orderlistState),
                            onSaveTap: () => _onSaveTap(orderlistState),
                            onPayTap: () => _onPayTap(orderlistState),
                          ),
                        ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                  resizeToAvoidBottomPadding: false,
                  appBar: AppBar(
                    title: Row(
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: AutoSizeText(
                              currentUser.shopName ?? '[null]',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          onDoubleTap: () => _logOut(context),
                          onLongPress: () => _logOut(context),
                        ),
                        SizedBox(width: 30),
                        Expanded(
                          child: TextFormField(
                            controller: _textQuery,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              hintText: 'Cari Produk, Makanan, Minuman',
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                              ),
                              suffixIcon: _textQuery.text.isEmpty
                                  ? IconButton(
                                      icon: Icon(Icons.search,
                                          color: Colors.white),
                                      onPressed: () {
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());
                                        generalProvider.isDrawerShow = false;
                                      },
                                    )
                                  : IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        Future.microtask(
                                            () => _textQuery.clear());
                                        generalProvider.isDrawerShow = false;
                                      }),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                  )),
                            ),
                          ),
                        )
                      ],
                    ),
                    actions: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Kasir: ${currentUser.username}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Consumer<ConnectivityResult>(
                            builder: (context, value, _) =>
                                ConnectionStatusWidget(TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                          ),
                        ],
                      )
                    ],
                  ),
                  drawer: DrawerMenu(currentUser),
                  body: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //lefside - halaman menu
                        Expanded(
                            flex: 2,
                            child: _productGridView(screenHeight, currentUser)),
                        //RIGHT SIDE MENU ORDER LIST
                        Expanded(
                            child: _orderListSideBar(
                                orderlistState, deviceType, context)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget _orderListSideBar(OrderListProvider orderlistState,
      DeviceScreenType deviceType, BuildContext context) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(5, 0, 5, 10),
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
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Container(
                          child: Consumer<OrderListProvider>(
                            builder: (context, orderlistState, _) =>
                                ListView.builder(
                                    itemCount: orderlistState.orderlist.length,
                                    itemBuilder: (context, index) {
                                      var currentOrderList =
                                          orderlistState.orderlist;
                                      final itemKey = currentOrderList[index];

                                      return Dismissible(
                                        key: ValueKey(itemKey),
                                        background: Container(
                                          alignment: Alignment.center,
                                          color: Colors.red,
                                          child: Text(
                                            'Hapus',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        onDismissed: (direction) {
                                          orderlistState.removeFromList(index);
                                        },
                                        child: DetailItemOrder(
                                          itemList: currentOrderList[index],
                                          onMinusButtonTap: () => orderlistState
                                              .decrementQuantity(index),
                                          onPlusButtonTap: () => orderlistState
                                              .incrementQuantity(index),
                                          onAddNoteTap: () {
                                            CostumDialogBox.showInputDialogBox(
                                                formKey: _formKey,
                                                context: context,
                                                textEditingController:
                                                    _textNote,
                                                title: 'Catatan',
                                                confirmButtonTitle: 'OK',
                                                onConfirmPressed: () {
                                                  orderlistState.addNote(
                                                      _textNote.text, index);
                                                  _textNote.clear();

                                                  Navigator.pop(context);
                                                });
                                          },
                                          childWidget: Container(),
                                        ),
                                      );
                                    }),
                          ),
                        ),
                      ),
                    ),

              deviceType == DeviceScreenType.tablet
                  ? Column(
                      children: <Widget>[
                        Container(
                          child: FooterOrderList(
                            dicount: orderlistState.discountTotal,
                            grandTotal: orderlistState.grandTotal,
                            subtotal: orderlistState.subTotal,
                            vat: orderlistState.taxFinal,
                          ),
                        ),
                        transactionButton(orderlistState, context),
                      ],
                    )
                  : Container()
            ]));
  }

  Widget _productGridView(double screenHeight, Users currentUser) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0),
      child: Column(
        children: <Widget>[
          Consumer<GeneralProvider>(
            builder: (context, generalState, _) => Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.all(10),
                  color: Color(0xFFfbfcfe),
                  height: screenHeight - 120,
                  child: FutureBuilder<List<Product>>(
                      future:
                          _textQuery.text.isEmpty || _textQuery.text.length < 3
                              ? _getProduct
                              : _firestoreServices.getDocumentByProductName(
                                  currentUser.shopName, _textQuery.text),
                      builder: (context, snapshot) {
                        if (snapshot.hasError)
                          return Center(
                            child: Text(
                              'An Error has Occured ${snapshot.error}',
                              style: kErrorTextStyle,
                            ),
                          );

                        if (!snapshot.hasData ||
                            snapshot.connectionState == ConnectionState.waiting)
                          return _shimmerLoading(generalState.isDrawerShow);

                        if (snapshot.data.isEmpty)
                          return Container(
                              alignment: Alignment.center,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Flexible(
                                      child: Container(
                                          width: 300,
                                          height: 300,
                                          child: Image.asset(
                                              'assets/images/empty_state.png')),
                                    ),
                                    Flexible(
                                      child: Text(
                                        'Belum Ada Produk',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        CostumButton.squareButtonSmall(
                                            'Tambah Produk', onTap: () {
                                          Navigator.pushNamed(
                                              context,
                                              RouteGenerator
                                                  .kRouteAddProductPage);
                                        }, prefixIcon: Icons.add),
                                        SizedBox(width: 8),
                                        CostumButton.squareButtonSmall(
                                          'Refresh',
                                          onTap: () {
                                            Navigator.pushReplacementNamed(
                                                context,
                                                RouteGenerator.kRoutePOSPage);
                                          },
                                          prefixIcon: Icons.sync,
                                          borderColor: Colors.green,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ));

                        return GridView.count(
                          crossAxisCount: generalState.isDrawerShow ? 2 : 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          children: snapshot.data
                              .map((product) => _cardMenu(product))
                              .toList(),
                        );
                      }),
                )),
          ),
        ],
      ),
    );
  }

  Future<void> _logOut(BuildContext context) async {
    CostumDialogBox.showCostumDialogBox(
        context: context,
        title: 'Konfirmasi',
        icon: FontAwesomeIcons.signOutAlt,
        iconColor: Colors.red,
        contentString: 'Logout dari Akun Anda?',
        confirmButtonTitle: 'Keluar',
        onConfirmPressed: () async {
          await _auth.signOut();
          // Navigator.pushNamed(context, RouteGenerator.kRouteLoginPage);
          Navigator.pushNamedAndRemoveUntil(
              context,
              RouteGenerator.kRouteLoginPage,
              ModalRoute.withName(RouteGenerator.kRouteLoginPage));
        });
  }

  void _onSaveTap(OrderListProvider orderlistState) {
    if (orderlistState.orderID.isNotEmpty &&
        orderlistState.orderlist.isNotEmpty) {
      if (orderlistState.addPostedOrder(orderlistState)) {
        CostumDialogBox.showDialogInformation(
            title: 'Information',
            contentText: 'Pesanan telah disimpan kedalam Draft',
            context: context,
            icon: Icons.info,
            iconColor: Colors.blue,
            onTap: () {
              orderlistState.resetOrderList();
              Navigator.pop(context);
            });
      }
      //set cashier name for PostedOrder Provider
      Provider.of<PostedOrderProvider>(context, listen: false).cashierName =
          orderlistState.cashierName;
    } else if (orderlistState.orderlist.isEmpty) {
      _dialogBoxOnEmptyList();
    }
  }

  void _onDiscountTap(OrderListProvider orderlistState) {
    if (orderlistState.orderlist.isNotEmpty) {
      showModal(
          configuration: FadeScaleTransitionConfiguration(
            barrierDismissible: false,
            transitionDuration: Duration(milliseconds: 500),
          ),
          context: context,
          builder: (context) => ExtraDiscoutDialog(orderlistState));
    }
  }

  void _onDeleteTap(OrderListProvider orderlistState) {
    if (orderlistState.orderlist.isNotEmpty ||
        orderlistState.orderID.isNotEmpty) {
      CostumDialogBox.showCostumDialogBox(
          context: context,
          title: 'Konfirmasi',
          contentString: 'List Order akan di Hapus',
          icon: Icons.delete,
          iconColor: Colors.red,
          confirmButtonTitle: 'Hapus',
          onConfirmPressed: () {
            orderlistState.resetOrderList();
            Navigator.pop(context);
          });
    }
  }

  void _onPayTap(OrderListProvider orderlistState) {
    if (orderlistState.orderlist.isNotEmpty)
      Navigator.pushNamed(context, RouteGenerator.kRoutePaymentScreen,
          arguments: orderlistState.orderlist);
    else if (orderlistState.orderlist.isEmpty) {
      _dialogBoxOnEmptyList();
    }
  }

  void _dialogBoxOnEmptyList() {
    CostumDialogBox.showDialogInformation(
      context: context,
      title: 'Informasi',
      icon: Icons.info,
      iconColor: Colors.yellow,
      contentText: 'List Pesanan Masih Kosong.',
      onTap: () => Navigator.pop(context),
    );
  }

  Row transactionButton(
      OrderListProvider orderlistState, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _bottomButton(
                icon: Icon(Icons.save, color: Colors.blue),
                title: 'Simpan',
                onTap: () => _onSaveTap(orderlistState)),
            _bottomButton(
                icon: Icon(Icons.disc_full),
                title: 'Diskon',
                onTap: () => _onDiscountTap(orderlistState)),
            _bottomButton(
                icon: Icon(Icons.delete, color: Colors.red),
                title: 'Hapus',
                onTap: () => _onDeleteTap(orderlistState)),
          ],
        ),
        Expanded(
          child: RaisedButton(
              padding: EdgeInsets.all(0),
              child: Container(
                  alignment: Alignment.center,
                  height: 60,
                  color: Color(0xFF408be5),
                  child: AutoSizeText(
                    'BAYAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              onPressed: () => _onPayTap(orderlistState)),
        )
      ],
    );
  }

  void _showDialogWarningUnsaveOrder(
      OrderListProvider orderlistProvider, Function onOkTap) {
    CostumDialogBox.showCostumDialogBox(
      context: context,
      title: 'Information',
      contentString: 'Pesanan Belum disimpan, \n Tetap Lanjut?',
      icon: Icons.warning,
      iconColor: Colors.yellow,
      confirmButtonTitle: 'Ya',
      onConfirmPressed: onOkTap,
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
                    iconSize: 25,
                    onPressed: () {
                      if (orderlistProvider.referenceOrder.isNotEmpty) {
                        _showDialogWarningUnsaveOrder(orderlistProvider, () {
                          Navigator.pop(context); //close dialogBox
                          orderlistProvider.resetOrderList();
                          _showPostedOrderList(context, boxOrder);
                        });
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
            Consumer<OrderListProvider>(builder: (_, orderlistState, __) {
              return Text(
                'Pesanan (${totalOrderLength(orderlistState.orderlist)})',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              );
            }),
            ScaleTransition(
              scale: _scalebtnAdd,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Consumer<GeneralProvider>(
                  builder: (_, generalProvider, __) => generalProvider.isLoading
                      ? Container(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(),
                        )
                      : IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          iconSize: 25,
                          onPressed: () {
                            if (orderlistProvider.orderlist.isEmpty) {
                              _createNewOrder(orderlistProvider);
                            } else if (orderlistProvider.orderlist.isNotEmpty) {
                              _showDialogWarningUnsaveOrder(orderlistProvider,
                                  () {
                                Navigator.pop(context); //close dialogBox
                                _createNewOrder(orderlistProvider);
                              });
                            }
                          },
                        ),
                ),
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
                fontSize: 17,
              ),
            ),
            Container(
              child: Consumer<OrderListProvider>(
                builder: (context, state, _) => Text(
                  state.referenceOrder ?? '[null]',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: priceColor,
                    fontSize: 17,
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
                  'Order ID: ' + orderlistState.orderID.toString(),
                  style: TextStyle(
                    color: priceColor,
                    fontSize: 17,
                  ),
                ),
              ),
              Text(Formatter.dateFormat(orderlistState.orderDate),
                  style: TextStyle(
                    color: priceColor,
                    fontSize: 17,
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
    return showModal(
      context: context,
      configuration: FadeScaleTransitionConfiguration(
        transitionDuration: Duration(milliseconds: 500),
      ),
      builder: (context) => Dialog(
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

                            int totalOrderlist = item.orderList.fold(
                                0, (prev, current) => prev + current.quantity);
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
                                  Text('Jumlah Pesanan : $totalOrderlist',
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
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(
                                    context, RouteGenerator.kRoutePaymentScreen,
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

  void _createNewOrder(OrderListProvider orderlistProvider) async {
    //* set loading to prevent double click new Order
    Provider.of<GeneralProvider>(context, listen: false).isLoading = true;

    var currentUser = await _auth.currentUserXXX;

    if (currentUser != null) {
      Provider.of<GeneralProvider>(context, listen: false).isLoading = false;

      CostumDialogBox.showInputDialogBox(
          formKey: _formKey,
          context: context,
          textEditingController: _textReferenceOrder,
          title: 'Referensi',
          hint: 'Nama Pelanggan atau Nomor Meja',
          confirmButtonTitle: 'OK',
          onConfirmPressed: () {
            if (_formKey.currentState.validate()) {
              orderlistProvider.resetOrderList();
              orderlistProvider.referenceOrder = _textReferenceOrder.text;
              orderlistProvider.cashierName = currentUser.username;

              orderlistProvider.createNewOrder();
              _textReferenceOrder.clear();
              Navigator.pop(context);
            }
          });
    }
  }

  Widget _shimmerLoading(bool isDrawerShow) {
    return GridView.count(
      crossAxisCount: isDrawerShow ? 2 : 3,
      crossAxisSpacing: 10,
      children: <Widget>[
        _shimmerCard(),
        _shimmerCard(),
        _shimmerCard(),
        _shimmerCard(),
      ],
    );
  }

  Widget _shimmerCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 7.0),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 200,
                        height: 20.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                      ),
                      Container(
                        width: 150,
                        height: 20.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
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
                              image: NetworkImage(
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
        onTap: () {
          if (orderlistProvider.orderID.isEmpty)
            _animationController.forward(from: 0.0);
        },
        onLongPress: () => _addItemtoOrderList(
            orderlistProvider: orderlistProvider, product: product),
        onDoubleTap: () => _addItemtoOrderList(
            orderlistProvider: orderlistProvider, product: product));
  }

  Future<void> _addItemtoOrderList(
      {OrderListProvider orderlistProvider, Product product}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    if (orderlistProvider.orderID.isNotEmpty) {
      orderlistProvider.addToList(
        item: product,
        referenceOrder: orderlistProvider.referenceOrder,
        vat: _prefs.getBool('vat'),
      );
    } else {
      _animationController.forward(from: 0.0);
      // if (_animationController.isCompleted)
      //   _animationController.reverse();
      // else if (_animationController.isDismissed) _animationController.forward();

      // print(_animationController.status);
    }
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
}
