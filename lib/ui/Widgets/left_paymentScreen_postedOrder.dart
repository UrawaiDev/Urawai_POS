import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urawai_pos/core/Models/postedOrder.dart';
import 'package:urawai_pos/core/Models/transaction.dart';
import 'package:urawai_pos/core/Provider/postedOrder_provider.dart';
import 'package:urawai_pos/core/Provider/transactionOrder_provider.dart';
import 'package:urawai_pos/ui/Pages/pos/pos_Page.dart';
import 'package:urawai_pos/ui/Widgets/costum_DialogBox.dart';
import 'package:urawai_pos/ui/Widgets/detail_itemOrder.dart';
import 'package:urawai_pos/ui/Widgets/extraDiscount.dart';
import 'package:urawai_pos/ui/Widgets/footer_OrderList.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';
import 'package:urawai_pos/ui/utils/functions/general_function.dart';
import 'package:urawai_pos/ui/utils/functions/getCurrentUser.dart';
import 'package:urawai_pos/ui/utils/functions/routeGenerator.dart';

class PaymentScreenLeftPostedOrder extends StatefulWidget {
  final PostedOrder postedOrder;
  PaymentScreenLeftPostedOrder(this.postedOrder);

  @override
  _PaymentScreenLeftPostedOrderState createState() =>
      _PaymentScreenLeftPostedOrderState();
}

class _PaymentScreenLeftPostedOrderState
    extends State<PaymentScreenLeftPostedOrder> {
  TextEditingController _textNote = TextEditingController();

  @override
  void dispose() {
    _textNote.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postedOrderProvider =
        Provider.of<PostedOrderProvider>(context, listen: false);

    //load Posted Order
    postedOrderProvider.postedorder = widget.postedOrder;

    //set VAT if tax is Activated.
    _setTaxPostedOrder(postedOrderProvider);

    DeviceScreenType deviceScreenType =
        getDeviceType(MediaQuery.of(context).size);

    return Expanded(
        child: Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(5, 20, 5, 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Consumer<PostedOrderProvider>(builder: (context, state, _) {
                    return Text(
                      'Pesanan (${totalOrderLength(state.postedOrder.orderList)})',
                      style: kHeaderTextStyle,
                    );
                  }),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, RouteGenerator.kRouteAddtionalItemOrderPage,
                          arguments: postedOrderProvider);
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      var box = Hive.box<PostedOrder>(POSPage.postedBoxName);
                      box.put(
                          postedOrderProvider.postedOrder.id,
                          PostedOrder(
                            id: postedOrderProvider.postedOrder.id,
                            refernceOrder: widget.postedOrder.refernceOrder,
                            dateTime: postedOrderProvider.postedOrder.dateTime,
                            discount: postedOrderProvider.discountTotal,
                            grandTotal: postedOrderProvider.grandTotal,
                            subtotal: postedOrderProvider.subTotal,
                            orderList:
                                postedOrderProvider.postedOrder.orderList,
                            paidStatus: PaidStatus.UnPaid,
                            cashierName: postedOrderProvider.cashierName,
                          ));

                      Provider.of<PostedOrderProvider>(context, listen: false)
                          .resetFinalPayment();
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: deviceScreenType == DeviceScreenType.tablet
                          ? 120
                          : 50,
                      height: 40,
                      color: Colors.blue,
                      child: deviceScreenType == DeviceScreenType.tablet
                          ? Row(
                              children: <Widget>[
                                Icon(
                                  Icons.arrow_back,
                                  size: 25,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Kembali',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          : Icon(
                              Icons.arrow_back,
                              size: 25,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          //ORDERED ITEM LIST

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Consumer<PostedOrderProvider>(
                builder: (context, state, _) => Container(
                  child: ListView.builder(
                      itemCount: state.postedOrder.orderList.length,
                      itemBuilder: (context, index) {
                        var item = state.postedOrder.orderList[index];
                        return DetailItemOrder(
                          itemList: item,
                          childWidget: IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            iconSize: 35,
                            onPressed: () {
                              CostumDialogBox.showCostumDialogBox(
                                  context: context,
                                  icon: Icons.delete,
                                  iconColor: Colors.red,
                                  title: 'Konfirmasi',
                                  contentString:
                                      'Pesanan ${item.productName} akan diHapus?',
                                  confirmButtonTitle: 'Hapus',
                                  onConfirmPressed: () {
                                    postedOrderProvider
                                        .removeItemFromList(index);
                                    Navigator.pop(context);
                                  });
                            },
                          ),
                          onPlusButtonTap: () =>
                              postedOrderProvider.incrementQuantity(index),
                          onMinusButtonTap: () =>
                              postedOrderProvider.decrementQuantity(index),
                          onAddNoteTap: () {
                            CostumDialogBox.showInputDialogBox(
                                context: context,
                                title: 'Masukkan Catatan',
                                confirmButtonTitle: 'OK',
                                textEditingController: _textNote,
                                onConfirmPressed: () {
                                  state.addNote(_textNote.text, index);
                                  _textNote.clear();
                                  Navigator.pop(context);
                                });
                          },
                        );
                      }),
                ),
              ),
            ),
          ),

          Consumer<PostedOrderProvider>(
            builder: (context, stateProvider, _) => Container(
              child: Column(
                children: <Widget>[
                  FooterOrderList(
                    dicount: stateProvider.discountTotal,
                    grandTotal: stateProvider.grandTotal,
                    subtotal: stateProvider.subTotal,
                    vat: stateProvider.taxFinal,
                  ),
                  Divider(
                    thickness: 2.5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              border: Border.all(color: Colors.grey),
                            ),
                            child: AutoSizeText('Void Traksaksi',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          onTap: () => CostumDialogBox.showCostumDialogBox(
                              context: context,
                              icon: Icons.delete,
                              iconColor: Colors.red,
                              title: 'Konfirmasi',
                              contentString:
                                  'Anda akan menghapus transaksi ini?',
                              confirmButtonTitle: 'Hapus',
                              onConfirmPressed: () async {
                                var currentUser =
                                    await CurrentUserLoggedIn.currentUser;
                                final transactionProvider =
                                    Provider.of<TransactionOrderProvider>(
                                        context,
                                        listen: false);
                                final connectionStatus =
                                    Provider.of<ConnectivityResult>(context,
                                        listen: false);

                                if (connectionStatus ==
                                    ConnectivityResult.none) {
                                  // add to HIVE db When Offline
                                  Provider.of<TransactionOrderProvider>(context,
                                          listen: false)
                                      .addTransactionOrder(
                                          stateProvider: stateProvider,
                                          paymentStatus: PaymentStatus.VOID,
                                          paymentType: PaymentType.CASH);
                                } else {
                                  //Add to cloud FireStore when Online
                                  transactionProvider.addTransactionToFirestore(
                                    stateProvider: stateProvider,
                                    paymentStatus: PaymentStatus.VOID,
                                    paymentType: PaymentType.CASH,
                                    shopName: currentUser.shopName,
                                  );
                                }

                                stateProvider.deletePostedOrder(
                                    stateProvider.postedOrder.id);
                                stateProvider.resetFinalPayment();
                                Navigator.pop(context); //close dialogBOx
                                Navigator.pop(
                                    context); //Back to HomePage Screen
                              }),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => showModal(
                          context: context,
                          configuration: FadeScaleTransitionConfiguration(
                            barrierDismissible: false,
                            transitionDuration: Duration(milliseconds: 500),
                          ),
                          builder: (context) =>
                              ExtraDiscoutDialog(postedOrderProvider),
                        ),
                        child: Container(
                          width:
                              (MediaQuery.of(context).size.width * 0.4) * 0.2,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.disc_full,
                              ),
                              Text('Diskon'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Future<void> _setTaxPostedOrder(
      PostedOrderProvider postedOrderProvider) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    if (_prefs.getBool('vat') == true) postedOrderProvider.setVat = 0.1;
  }
}
