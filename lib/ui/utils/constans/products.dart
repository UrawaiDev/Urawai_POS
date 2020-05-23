import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductsEntity {
  static List<ProductCategories> productCategories = [
    ProductCategories(FontAwesomeIcons.utensils, 'MAKANAN'),
    ProductCategories(FontAwesomeIcons.glassMartiniAlt, 'MINUMAN'),
    ProductCategories(FontAwesomeIcons.cookieBite, 'MAKANAN RINGAN'),
    ProductCategories(FontAwesomeIcons.stroopwafel, 'MAKANAN PEMBUKA'),
    ProductCategories(FontAwesomeIcons.iceCream, 'MAKANAN PENUTUP'),
  ];
}

class ProductCategories {
  IconData icon;
  String categoryName;
  ProductCategories(this.icon, this.categoryName);
}
