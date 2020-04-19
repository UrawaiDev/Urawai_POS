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
  final TextEditingController _textNoteOrder = TextEditingController();

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
                          productName,
                          style: screenWidth > 1024
                              ? kProductNameBigScreenTextStyle
                              : kProductNameSmallScreenTextStyle,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Rp. ' + _formatCurrency.format(price),
                          style: kPriceTextStyle,
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              child: Icon(Icons.note),
                              onTap: () {
                                // TODO: will check later OverFlow
                                // CostumDialogBox.showInputDialogBox(
                                //     context: context,
                                //     textEditingController: _textNoteOrder,
                                //     title: 'Nama Pelanggan / Nomor Meja',
                                //     confirmButtonTitle: 'OK',
                                //     onConfirmPressed: () {
                                //       print(_textNoteOrder.text);
                                //       Navigator.pop(context);
                                //     });
                              },
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Catatan',
                              style: kNoteTextStyle,
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
                              width: 30,
                              height: 30,
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
                              style: screenWidth > 1024
                                  ? kProductNameBigScreenTextStyle
                                  : kProductNameSmallScreenTextStyle,
                            ),
                          ),
                          GestureDetector(
                            child: Container(
                              width: 30,
                              height: 30,
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
