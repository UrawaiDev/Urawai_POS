import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/core/Models/orderList.dart';
import 'package:urawai_pos/core/Models/products.dart';
import 'package:urawai_pos/core/Models/transaction.dart';
import 'package:urawai_pos/core/Provider/orderList_provider.dart';
import 'package:urawai_pos/core/Provider/transactionOrder_provider.dart';
import 'package:urawai_pos/ui/Pages/pos/pos_Page.dart';
import 'package:urawai_pos/ui/Widgets/costum_DialogBox.dart';
import 'package:urawai_pos/ui/Widgets/footer_OrderList.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';

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
                  Consumer<OrderListProvider>(
                    builder: (context, state, _) => Text(
                      'Pesanan (${state.orderlist.length})',
                      style: kHeaderTextStyle,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      var state = Provider.of<OrderListProvider>(context,
                          listen: false);
                      //TEMPORARY
                      state.addToList(
                        item: Product(
                          id: 0,
                          category: 1,
                          image: 'dummy path',
                          isRecommended: true,
                          name: 'Nasi Putih',
                          price: 5000,
                        ),
                        referenceOrder: orderListProvider.referenceOrder,
                      );
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
                      width: 120,
                      height: 40,
                      color: Colors.blue,
                      child: Row(
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
                    tax: 0.1,
                  ),
                  Divider(
                    thickness: 2.5,
                  ),
                  GestureDetector(
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 400,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Text('Void Traksaksi',
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
                        onConfirmPressed: () {
                          Provider.of<TransactionOrderProvider>(context,
                                  listen: false)
                              .addTransactionOrder(
                                  stateProvider: stateProvider,
                                  paymentStatus: PaymentStatus.VOID,
                                  paymentType: PaymentType.CASH);

                          stateProvider.resetOrderList();
                          Navigator.pop(context); //close dialogBOx

                          //back to main page
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => POSPage()),
                            ModalRoute.withName(POSPage.routeName),
                          );
                        }),
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
