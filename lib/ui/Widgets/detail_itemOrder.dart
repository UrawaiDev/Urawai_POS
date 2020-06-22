import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/core/Models/orderList.dart';
import 'package:urawai_pos/core/Provider/orderList_provider.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';

class DetailItemOrder extends StatelessWidget {
  final OrderList itemList;

  final Function onAddNoteTap;
  final Function onMinusButtonTap;
  final Function onPlusButtonTap;
  final _formatCurrency = NumberFormat("#,##0", "en_US");
  final Widget childWidget;

  DetailItemOrder(
      {@required this.itemList,
      this.onAddNoteTap,
      this.onMinusButtonTap,
      this.onPlusButtonTap,
      this.childWidget});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          itemList.productName,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Rp. ' + _formatCurrency.format(itemList.price),
                          style: kPriceTextStyle,
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              child: Icon(Icons.note),
                              onTap: onAddNoteTap,
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: Consumer<OrderListProvider>(
                                builder: (context, state, _) => Text(
                                  itemList.note ?? '-',
                                  style: kNoteTextStyle,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  //Button plus & minus
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          GestureDetector(
                            child: Container(
                              width: 25,
                              height: 25,
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
                              itemList.quantity.toString(),
                              style: screenWidth > 1024
                                  ? kProductNameBigScreenTextStyle
                                  : kProductNameSmallScreenTextStyle,
                            ),
                          ),
                          GestureDetector(
                            child: Container(
                              width: 25,
                              height: 25,
                              color: greyColor,
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                            onTap: onPlusButtonTap,
                          ),
                          SizedBox(width: 10),
                          childWidget,
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}
