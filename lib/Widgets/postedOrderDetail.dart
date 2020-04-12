import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/Models/postedOrder.dart';
import 'package:urawai_pos/Provider/orderList_provider.dart';

import 'detail_itemOrder.dart';
import 'footer_OrderList.dart';

class PostedOrderDetail extends StatelessWidget {
  final PostedOrder postedOrder;

  PostedOrderDetail(this.postedOrder);

  @override
  Widget build(BuildContext context) {
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
              // _headerOrderList()
            ],
          ),
          //ORDERED ITEM LIST
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Container(
                child: Consumer<OrderListProvider>(
                  builder: (context, orderlistState, _) => ListView.builder(
                      itemCount: postedOrder.orderList.length,
                      itemBuilder: (context, index) {
                        var currentOrderList = postedOrder.orderList;
                        final itemKey = postedOrder.orderList[index];

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
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          onDismissed: (direction) {
                            orderlistState.removeFromList(index);
                          },
                          child: DetailItemOrder(
                              productName: currentOrderList[index].productName,
                              price: currentOrderList[index].price,
                              quantity: currentOrderList[index].quantity,
                              onLongPress: () {
                                print(currentOrderList[index].productName);
                              },
                              onMinusButtonTap: () {
                                if (currentOrderList[index].quantity > 1)
                                  orderlistState.decrementQuantity(index);
                              },
                              onPlusButtonTap: () {
                                if (currentOrderList[index].quantity <= 999)
                                  orderlistState.incrementQuantity(index);
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
    ));
  }
}
