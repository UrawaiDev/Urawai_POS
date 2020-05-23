import 'package:flutter/material.dart';
import 'package:urawai_pos/core/Models/orderList.dart';
import 'package:urawai_pos/core/Models/products.dart';
import 'package:urawai_pos/core/Provider/orderList_provider.dart';
import 'package:urawai_pos/core/Provider/postedOrder_provider.dart';
import 'package:urawai_pos/core/Services/firestore_service.dart';
import 'package:urawai_pos/ui/Widgets/card_menu.dart';
import 'package:urawai_pos/ui/utils/constans/const.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';

class AddtionalItemOrderPage extends StatelessWidget {
  final FirestoreServices _firestoreServices = FirestoreServices();
  final dynamic stateProvider;

  AddtionalItemOrderPage(this.stateProvider);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Pesanan Tambahan',
            style: kProductNameBigScreenTextStyle,
          ),
          SizedBox(height: 30),
          Expanded(
              flex: 1,
              child: Container(
                // color: Colors.yellow,
                child: FutureBuilder<List<Product>>(
                  future: _firestoreServices.getProducts(kShopName),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    else if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError)
                        return Text(
                          'An Error has Occured ${snapshot.error}',
                          style: kPriceTextStyle,
                        );
                      else if (!snapshot.hasData)
                        return Text(
                          'Loading....',
                          style: kPriceTextStyle,
                        );
                      else if (snapshot.data.isEmpty)
                        return Text(
                          'Belum Ada Produk',
                          style: kPriceTextStyle,
                        );
                    }
                    return GridView.count(
                      padding: EdgeInsets.all(8),
                      crossAxisCount: 5,
                      children: snapshot.data
                          .map((product) => CardMenu(
                                product,
                                onDoubleTap: () {
                                  if (stateProvider is OrderListProvider) {
                                    stateProvider.addToList(
                                      item: product,
                                      referenceOrder:
                                          stateProvider.referenceOrder,
                                    );
                                    Navigator.pop(context);
                                  } else if (stateProvider
                                      is PostedOrderProvider) {
                                    stateProvider.addItem(
                                      stateProvider.postedOrder,
                                      OrderList(
                                        productName: product.name,
                                        price: product.price,
                                        id: product.id,
                                        discount: product.discount,
                                        quantity: 1,
                                      ),
                                    );
                                    Navigator.pop(context);
                                  }
                                },
                              ))
                          .toList(),
                    );
                  },
                ),
              )),
          Text(
            '* Double Tap untuk memilih menu tambahan',
            style: kPriceTextStyle,
          ),
        ],
      ),
    )));
  }
}
