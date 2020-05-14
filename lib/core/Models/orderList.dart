import 'package:hive/hive.dart';

part 'orderList.g.dart';

@HiveType(typeId: 2)
class OrderList {
  @HiveField(0)
  String id;
  @HiveField(1)
  String productName;
  @HiveField(2)
  double price;
  @HiveField(3)
  int quantity;
  @HiveField(4)
  String note;
  @HiveField(5)
  DateTime dateTime;
  @HiveField(6)
  String cashierName;
  @HiveField(7)
  String referenceOrder;
  @HiveField(8)
  int discount;

  //TODO: delete column cashier Name , Reference Order , dateTime

  OrderList({
    this.id,
    this.productName,
    this.price,
    this.quantity,
    this.note,
    this.dateTime,
    this.referenceOrder,
    this.cashierName,
    this.discount,
  });

  OrderList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['productName'];
    price = json['price'];
    quantity = json['quantity'];
    note = json['note'];
    dateTime = json['dateTime'];
    referenceOrder = json['referenceOrder'];
    cashierName = json['cashierName'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['productName'] = this.productName;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['note'] = this.note;
    // data['dateTime'] = this.dateTime;
    // data['referenceOrder'] = this.referenceOrder;
    // data['cashierName'] = this.cashierName;
    // data['discount'] = this.discount;

    return data;
  }
}
