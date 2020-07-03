import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:urawai_pos/core/Models/orderList.dart';
import 'package:urawai_pos/core/Models/transaction.dart';
import 'package:urawai_pos/core/Provider/orderList_provider.dart';
import 'package:urawai_pos/core/Provider/transactionOrder_provider.dart';
import 'package:urawai_pos/ui/Pages/pos/pos_Page.dart';
import 'package:urawai_pos/ui/Widgets/costum_DialogBox.dart';
import 'package:urawai_pos/ui/Widgets/extraDiscount.dart';
import 'package:urawai_pos/ui/Widgets/footer_OrderList.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';
import 'package:urawai_pos/ui/utils/functions/general_function.dart';
import 'package:urawai_pos/ui/utils/functions/getCurrentUser.dart';
import 'package:urawai_pos/ui/utils/functions/routeGenerator.dart';

import 'detail_itemOrder.dart';

class PaymentScreenLeftOrderList extends StatefulWidget {
  final List<OrderList> orderList;
  PaymentScreenLeftOrderList(this.orderList);

  @override
  _PaymentScreenLeftOrderListState createState() =>
      _PaymentScreenLeftOrderListState();
}

class _PaymentScreenLeftOrderListState
    extends State<PaymentScreenLeftOrderList> {
  TextEditingController _textNote = TextEditingController();

  @override
  void dispose() {
    _textNote.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderListProvider =
        Provider.of<OrderListProvider>(context, listen: false);
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
                  Consumer<OrderListProvider>(builder: (context, state, _) {
                    return Text(
                      'Pesanan (${totalOrderLength(state.orderlist)})',
                      style: kHeaderTextStyle,
                    );
                  }),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, RouteGenerator.kRouteAddtionalItemOrderPage,
                          arguments: orderListProvider);
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      Provider.of<OrderListProvider>(context, listen: false)
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
              child: Consumer<OrderListProvider>(
                builder: (context, state, _) => Container(
                  child: ListView.builder(
                      itemCount: state.orderlist.length,
                      itemBuilder: (context, index) {
                        var item = state.orderlist[index];
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
                                    orderListProvider.removeFromList(index);
                                    Navigator.pop(context);
                                  });
                            },
                          ),
                          onPlusButtonTap: () =>
                              orderListProvider.incrementQuantity(index),
                          onMinusButtonTap: () =>
                              orderListProvider.decrementQuantity(index),
                          onAddNoteTap: () {
                            CostumDialogBox.showInputDialogBox(
                                context: context,
                                title: 'Masukkan Catatan',
                                confirmButtonTitle: 'OK',
                                textEditingController: _textNote,
                                onConfirmPressed: () {
                                  orderListProvider.addNote(
                                      _textNote.text, index);
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

          Consumer<OrderListProvider>(
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
                      GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width:
                              (MediaQuery.of(context).size.width * 0.4) * 0.6,
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
                            contentString: 'Anda akan menghapus transaksi ini?',
                            confirmButtonTitle: 'Hapus',
                            onConfirmPressed: () async {
                              var currentUser =
                                  await CurrentUserLoggedIn.currentUser;
                              final transactionProvider =
                                  Provider.of<TransactionOrderProvider>(context,
                                      listen: false);
                              final connectionStatus =
                                  Provider.of<ConnectivityResult>(context,
                                      listen: false);
                              if (connectionStatus == ConnectivityResult.none) {
                                // Add to HIVE db When Offline
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
                                    shopName: currentUser.shopName);
                              }

                              Navigator.pop(context); //close Hapus dialogBOx

                              CostumDialogBox.showDialogInformation(
                                  context: context,
                                  icon: Icons.info,
                                  iconColor: Colors.blue,
                                  title: 'Informasi',
                                  contentText: 'Transaksi berhasil di Hapus.',
                                  onTap: () {
                                    //clear list
                                    stateProvider.resetOrderList();
                                    //back to main page
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => POSPage()),
                                      ModalRoute.withName(
                                          RouteGenerator.kRoutePOSPage),
                                    );
                                  });
                            }),
                      ),
                      GestureDetector(
                        onTap: () => showModal(
                          configuration: FadeScaleTransitionConfiguration(
                            barrierDismissible: false,
                            transitionDuration: Duration(milliseconds: 500),
                          ),
                          context: context,
                          builder: (context) =>
                              ExtraDiscoutDialog(orderListProvider),
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
}
