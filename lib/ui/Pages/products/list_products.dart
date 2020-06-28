import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/core/Models/products.dart';
import 'package:urawai_pos/core/Models/users.dart';
import 'package:urawai_pos/core/Provider/general_provider.dart';
import 'package:urawai_pos/core/Services/firebase_auth.dart';
import 'package:urawai_pos/core/Services/firestore_service.dart';
import 'package:urawai_pos/ui/Widgets/costum_DialogBox.dart';
import 'package:urawai_pos/ui/Widgets/drawerMenu.dart';
import 'package:urawai_pos/ui/Widgets/loading_card.dart';
import 'package:urawai_pos/ui/utils/constans/formatter.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';
import 'package:urawai_pos/ui/utils/functions/routeGenerator.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final _textQuery = TextEditingController();
  final locatorAuth = GetIt.I<FirebaseAuthentication>();
  final locatorFirestore = GetIt.I<FirestoreServices>();

  Future<Users> _currentUser;

  @override
  void dispose() {
    _textQuery.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _currentUser = locatorAuth.currentUserXXX;
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GeneralProvider>(context);

    return SafeArea(
        child: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: TextFormField(
                controller: _textQuery,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  hintText: 'Cari Produk, Makanan, Minuman',
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                  ),
                  suffixIcon: _textQuery.text.isEmpty
                      ? IconButton(
                          icon: Icon(Icons.search, color: Colors.white),
                          onPressed: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            //rebuild state
                            state.isDrawerShow = false;
                          },
                        )
                      : IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            //make a delay
                            Future.microtask(() => _textQuery.clear());
                            //rebuild state
                            state.isDrawerShow = false;
                          }),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2,
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 1,
                      )),
                ),
              ),
            ),
          ),
          drawer: FutureBuilder<Users>(
              future: _currentUser,
              builder: (_, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting)
                  return Container();
                return DrawerMenu(snapshot.data);
              }),
          body: FutureBuilder<Users>(
              future: _currentUser,
              builder: (context, snapshot) {
                Users currentUser = snapshot.data;

                if (snapshot.hasError)
                  return Center(
                    child: Text(snapshot.error.toString(),
                        style: kProductNameBigScreenTextStyle),
                  );
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting)
                  return LoadingCard();

                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Daftar Produk:',
                        style: kProductNameBigScreenTextStyle,
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: FutureBuilder<List<Product>>(
                            future: (_textQuery.text.isEmpty ||
                                    _textQuery.text.length < 3)
                                ? locatorFirestore
                                    .getProducts(currentUser.shopName)
                                : locatorFirestore.getDocumentByProductName(
                                    currentUser.shopName, _textQuery.text),
                            builder: (context, snapshot) {
                              if (snapshot.hasError)
                                return Center(
                                    child: Text(
                                  'An Error has Occured ${snapshot.error}',
                                  style: kPriceTextStyle,
                                ));
                              else if (!snapshot.hasData ||
                                  snapshot.connectionState ==
                                      ConnectionState.waiting)
                                return Center(
                                    child: CircularProgressIndicator());
                              else if (snapshot.data.isEmpty)
                                return Center(
                                    child: Text(
                                  'Belum Ada Produk',
                                  style: kPriceTextStyle,
                                ));

                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    Product product = snapshot.data[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: greyColor,
                                                ),
                                                child: Container(
                                                  width: 100,
                                                  height: 100,
                                                  margin: EdgeInsets.all(15),
                                                  child:
                                                      FadeInImage.assetNetwork(
                                                    placeholder:
                                                        'assets/images/placeholder.gif',
                                                    image: product.image,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Text(
                                                            'Nama Produk: ',
                                                            style:
                                                                kProductNameSmallScreenTextStyle,
                                                          ),
                                                          Text(
                                                            product.name,
                                                            style:
                                                                kProductNameSmallScreenTextStyle,
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Text(
                                                            'Harga: ',
                                                            style:
                                                                kPriceTextStyle,
                                                          ),
                                                          Text(
                                                            Formatter
                                                                .currencyFormat(
                                                                    product
                                                                        .price),
                                                            style:
                                                                kPriceTextStyle,
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Text(
                                                            'Kategori: ',
                                                            style:
                                                                kPriceTextStyle,
                                                          ),
                                                          Text(
                                                            product.category,
                                                            style:
                                                                kPriceTextStyle,
                                                          )
                                                        ],
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Text(
                                                            'Diskon: ',
                                                            style:
                                                                kPriceTextStyle,
                                                          ),
                                                          Text(
                                                            product.discount
                                                                    .toString() +
                                                                ' %',
                                                            style:
                                                                kPriceTextStyle,
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Text(
                                                            'Populer: ',
                                                            style:
                                                                kPriceTextStyle,
                                                          ),
                                                          Text(
                                                            product.isRecommended
                                                                ? 'Ya'
                                                                : 'Tidak',
                                                            style:
                                                                kPriceTextStyle,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              IconButton(
                                                  icon: Icon(
                                                    Icons.edit,
                                                  ),
                                                  iconSize: 35,
                                                  color: Colors.blue,
                                                  onPressed: () =>
                                                      Navigator.pushNamed(
                                                          context,
                                                          RouteGenerator
                                                              .kRouteEditProductPage,
                                                          arguments: product)),
                                              IconButton(
                                                  icon: Icon(
                                                    Icons.delete,
                                                  ),
                                                  iconSize: 35,
                                                  color: Colors.red,
                                                  onPressed: () {
                                                    CostumDialogBox
                                                        .showCostumDialogBox(
                                                            context: context,
                                                            title: 'Konfirmasi',
                                                            icon: Icons.delete,
                                                            iconColor:
                                                                Colors.red,
                                                            contentString:
                                                                'Anda Akan Menghapus Produk "${product.name}"?',
                                                            confirmButtonTitle:
                                                                'Hapus',
                                                            onConfirmPressed:
                                                                () {
                                                              final gProvider =
                                                                  Provider.of<
                                                                          GeneralProvider>(
                                                                      context,
                                                                      listen:
                                                                          false);
                                                              locatorFirestore
                                                                  .deleteProduct(
                                                                      currentUser
                                                                          .shopName,
                                                                      product
                                                                          .id);
                                                              Navigator.pop(
                                                                  context);
                                                              gProvider
                                                                      .isLoading =
                                                                  false;
                                                            });
                                                  }),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            }),
                      ),
                    ],
                  ),
                );
              })),
    ));
  }
}
