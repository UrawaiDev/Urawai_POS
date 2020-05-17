import 'package:flutter/material.dart';
import 'package:urawai_pos/core/Models/products.dart';
import 'package:urawai_pos/ui/utils/constans/formatter.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';

class CardMenu extends StatelessWidget {
  final Product product;
  final Function onDoubleTap;
  CardMenu(this.product, {this.onDoubleTap});

  @override
  Widget build(BuildContext context) {
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
                      width: 150,
                      height: 150,
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
      onDoubleTap: onDoubleTap,
    );
  }
}
