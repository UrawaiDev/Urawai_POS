import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:urawai_pos/constans/utils.dart';

class DetailItemOrder extends StatelessWidget {
  final String productName;
  final double price;
  final int quantity;
  final Function onLongPress;
  final Function onMinusButtonTap;
  final Function onPlusButtonTap;
  final _formatCurrency = NumberFormat("#,##0", "en_US");
  final Widget childWidget;

  DetailItemOrder(
      {this.productName,
      this.price,
      this.quantity,
      this.onLongPress,
      this.onMinusButtonTap,
      this.onPlusButtonTap,
      this.childWidget});

  @override
  Widget build(BuildContext context) {
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
                      ),
                    ],
                  ),

                  //Button plus & minus
                  Column(
                    children: <Widget>[
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
          onLongPress: onLongPress,
        ),
        Divider(),
      ],
    );
  }
}
