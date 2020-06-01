import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urawai_pos/core/Models/orderList.dart';
import 'package:urawai_pos/core/Models/products.dart';
import 'package:urawai_pos/core/Provider/orderList_provider.dart';
import 'package:urawai_pos/core/Provider/postedOrder_provider.dart';
import 'package:urawai_pos/core/Services/firebase_auth.dart';
import 'package:urawai_pos/core/Services/firestore_service.dart';
import 'package:urawai_pos/ui/Widgets/card_menu.dart';
import 'package:urawai_pos/ui/Widgets/loading_card.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';

class AddtionalItemOrderPage extends StatelessWidget {
  final FirestoreServices _firestoreServices = FirestoreServices();
  final FirebaseAuthentication _firebaseAuthentication =
      FirebaseAuthentication();
  final dynamic stateProvider;

  AddtionalItemOrderPage(this.stateProvider);

  Future<List<Product>> _getCurrentUser() async {
    var user = await _firebaseAuthentication.currentUserXXX;

    return _firestoreServices.getProducts(user.shopName);
  }

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
                  future: _getCurrentUser(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return Text(
                        'An Error has Occured ${snapshot.error}',
                        style: kPriceTextStyle,
                      );
                    if (!snapshot.hasData ||
                        snapshot.connectionState == ConnectionState.waiting)
                      return LoadingCard();
                    if (snapshot.data.isEmpty)
                      return Text(
                        'Belum Ada Produk.',
                        style: kPriceTextStyle,
                      );

                    return GridView.count(
                      padding: EdgeInsets.all(8),
                      crossAxisCount: 5,
                      children: snapshot.data
                          .map((product) => CardMenu(
                                product,
                                onDoubleTap: () async {
                                  SharedPreferences _prefs =
                                      await SharedPreferences.getInstance();
                                  if (stateProvider is OrderListProvider) {
                                    stateProvider.addToList(
                                      item: product,
                                      referenceOrder:
                                          stateProvider.referenceOrder,
                                      vat: _prefs.getBool('vat'),
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
                                      vat: _prefs.getBool('vat'),
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
