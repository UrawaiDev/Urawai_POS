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
  String dateTime;
  @HiveField(6)
  String cashierName;
  @HiveField(7)
  String refernceOrder;

  OrderList({
    this.id,
    this.productName,
    this.price,
    this.quantity,
    this.note,
    this.dateTime,
    this.refernceOrder,
    this.cashierName,
  });
}
