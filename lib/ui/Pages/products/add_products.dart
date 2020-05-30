import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/core/Provider/general_provider.dart';
import 'package:urawai_pos/ui/Widgets/costum_button.dart';
import 'package:urawai_pos/ui/utils/constans/products.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';
import 'package:urawai_pos/ui/utils/functions/getCurrentUser.dart';
import 'package:urawai_pos/ui/utils/functions/imagePicker.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  bool _isPopular = false;
  String _categoryValue;
  String _imageMsg = '';

  File _imageFile;
  final _formKey = GlobalKey<FormState>();
  final _textProductName = TextEditingController();
  final _textProductPrice = TextEditingController();
  final _textDiscount = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _textDiscount.dispose();
    _textProductName.dispose();
    _textProductPrice.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Tambah Produk',
                        style: kProductNameBigScreenTextStyle,
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //Left Side
                            Expanded(
                                flex: 3,
                                child: Form(
                                  key: _formKey,
                                  child: Container(
                                    // color: Colors.blue,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        TextFormField(
                                          controller: _textProductName,
                                          style: kPriceTextStyle,
                                          decoration: InputDecoration(
                                            labelText: '[ Nama Produk ]',
                                            labelStyle:
                                                kProductNameSmallScreenTextStyle,
                                            hintText: 'Nama Produk',
                                            hintStyle: kPriceTextStyle,
                                            border: OutlineInputBorder(),
                                            errorStyle: kErrorTextStyle,
                                          ),
                                          textInputAction: TextInputAction.done,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          autocorrect: false,
                                          validator: (value) {
                                            if (value.isEmpty)
                                              return 'Kolom Ini Tidak Boleh Kosong.';
                                            else if (value.length < 3)
                                              return 'Minimal 3 Karakter.';
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 40),
                                        TextFormField(
                                          controller: _textProductPrice,
                                          style: kPriceTextStyle,
                                          decoration: InputDecoration(
                                            labelText: '[ Harga Produk ]',
                                            labelStyle:
                                                kProductNameSmallScreenTextStyle,
                                            hintText: 'Harga Produk',
                                            hintStyle: kPriceTextStyle,
                                            border: OutlineInputBorder(),
                                            errorStyle: kErrorTextStyle,
                                          ),
                                          textInputAction: TextInputAction.done,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  decimal: false),
                                          autocorrect: false,
                                          validator: (value) {
                                            if (value.isEmpty)
                                              return 'Kolom Ini Tidak Boleh Kosong.';

                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 40),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: 200,
                                                      child: TextFormField(
                                                        controller:
                                                            _textDiscount,
                                                        style: kPriceTextStyle,
                                                        maxLength: 3,
                                                        decoration:
                                                            InputDecoration(
                                                          counterText: '',
                                                          labelText:
                                                              '[ Diskon ]',
                                                          labelStyle:
                                                              kProductNameSmallScreenTextStyle,
                                                          hintText:
                                                              'Dalam Persen (%)',
                                                          hintStyle:
                                                              kPriceTextStyle,
                                                          border:
                                                              OutlineInputBorder(),
                                                          errorStyle:
                                                              kErrorTextStyle,
                                                        ),
                                                        textInputAction:
                                                            TextInputAction
                                                                .done,
                                                        textCapitalization:
                                                            TextCapitalization
                                                                .words,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        autocorrect: false,
                                                      ),
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text(
                                                      '%',
                                                      style:
                                                          kProductNameSmallScreenTextStyle,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  '*Diskon Produk dalam % [Optional]',
                                                  style: kPriceTextStyle,
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text('Produk Populer',
                                                    style:
                                                        kProductNameSmallScreenTextStyle),
                                                SizedBox(height: 8),
                                                CupertinoSwitch(
                                                    value: _isPopular,
                                                    onChanged: (value) {
                                                      _isPopular = value;
                                                    }),
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 40),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Kategori Produk',
                                                style:
                                                    kProductNameSmallScreenTextStyle),
                                            SizedBox(height: 8),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              child: DropdownButtonFormField<
                                                      String>(
                                                  icon: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: Colors.blue,
                                                  ),
                                                  decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    errorStyle: kErrorTextStyle,
                                                  ),
                                                  hint: Text('Kategori',
                                                      style: kPriceTextStyle),
                                                  value: _categoryValue,
                                                  items: ProductsEntity
                                                      .productCategories
                                                      .map((data) =>
                                                          DropdownMenuItem<
                                                              String>(
                                                            child:
                                                                _buildDropdownMenu(
                                                                    data),
                                                            value: data
                                                                .categoryName,
                                                          ))
                                                      .toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _categoryValue = value;
                                                    });
                                                  },
                                                  style: kPriceTextStyle,
                                                  validator: (value) => value ==
                                                          null
                                                      ? 'Silahkan Pilih Kategori'
                                                      : null),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                            //Right Side
                            Expanded(
                                flex: 2,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: 300,
                                      height: 250,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 3,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: _imageFile == null
                                          ? Image.asset(
                                              'assets/images/noimage.png',
                                              fit: BoxFit.cover,
                                            )
                                          : FadeInImage(
                                              placeholder: AssetImage(
                                                  'assets/images/placeholder.gif'),
                                              image: FileImage(_imageFile),
                                              fit: BoxFit.cover),
                                    ),
                                    SizedBox(height: 8),
                                    _imageMsg.isNotEmpty
                                        ? Text(
                                            _imageMsg,
                                            style: kErrorTextStyle,
                                          )
                                        : Container(),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        CostumButton.squareButtonSmall(
                                            'Gallery',
                                            prefixIcon: Icons.image,
                                            borderColor: Colors.black,
                                            onTap: () async {
                                          File pickedImage =
                                              await ImagePicker.pickImage(
                                                  source: ImageSource.gallery);

                                          if (pickedImage != null) {
                                            if (await pickedImage.length() >
                                                3000000) {
                                              setState(() {
                                                _imageMsg =
                                                    'Ukuran File Gambar Max. 3mb';
                                                _imageFile = null;
                                              });
                                            } else
                                              setState(() {
                                                _imageMsg = '';
                                                _imageFile = pickedImage;
                                              });
                                          }
                                        }),
                                        SizedBox(height: 20),
                                        CostumButton.squareButtonSmall('Camera',
                                            prefixIcon: Icons.camera_alt,
                                            borderColor: Colors.black,
                                            onTap: () async {
                                          File pickedImage =
                                              await ImagePicker.pickImage(
                                                  source: ImageSource.camera);

                                          if (pickedImage != null) {
                                            if (await pickedImage.length() >
                                                3000000) {
                                              setState(() {
                                                _imageMsg =
                                                    'Ukuran File Gambar Max. 3mb';
                                                _imageFile = null;
                                              });
                                            } else
                                              setState(() {
                                                _imageMsg = '';
                                                _imageFile = pickedImage;
                                              });
                                          }
                                        }),
                                      ],
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      CostumButton.squareButton('Simpan',
                          prefixIcon: Icons.save, onTap: () async {
                        var currentUser = await CurrentUserLoggedIn.currentUser;

                        if (_imageFile == null)
                          setState(() {
                            _imageMsg = 'Foto Produk Tidak Boleh Kosong.';
                          });
                        else {
                          setState(() {
                            _imageMsg = '';
                          });
                        }

                        if (_formKey.currentState.validate() &&
                            _categoryValue != null &&
                            _imageFile != null) {
                          var result = await uploadAndSavetoFirebase(
                            shopName: currentUser.shopName,
                            productName: _textProductName.text,
                            productPrice:
                                double.tryParse(_textProductPrice.text),
                            discount:
                                double.tryParse(_textDiscount.text ?? '0'),
                            imageFile: _imageFile,
                            isPopular: _isPopular,
                            productCategory: _categoryValue,
                            appState: Provider.of<GeneralProvider>(context,
                                listen: false),
                          );
                          if (result == true) {
                            _textProductName.clear();
                            _textProductPrice.clear();
                            _textDiscount.clear();
                            _imageFile = null;
                            _isPopular = false;
                            setState(() {});
                          }
                        }
                      }),
                    ],
                  ),
                ),
              ),
            ),
            Consumer<GeneralProvider>(builder: (_, value, __) {
              if (value.isLoading)
                return _showLoading(context);
              else
                return Container();
            })
          ],
        ),
      ),
    ));
  }

  Widget _buildDropdownMenu(ProductCategories data) {
    return Row(
      children: <Widget>[
        FaIcon(
          data.icon,
          size: 25,
          color: Colors.blue,
        ),
        SizedBox(width: 15),
        Text(data.categoryName, style: kPriceTextStyle),
      ],
    );
  }

  Widget _showLoading(BuildContext context) {
    return Positioned.fill(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey.withOpacity(0.6),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            width: 250,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: 80, height: 80, child: CircularProgressIndicator()),
                SizedBox(height: 10),
                Text('Menyimpan produk ...', style: kPriceTextStyle),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
