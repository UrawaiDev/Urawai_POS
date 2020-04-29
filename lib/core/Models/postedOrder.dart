import 'package:hive/hive.dart';
import 'package:urawai_pos/core/Models/orderList.dart';

part 'postedOrder.g.dart';

@HiveType(typeId: 1)
enum PaidStatus {
  @HiveField(0)
  Paid,
  @HiveField(1)
  UnPaid,
  @HiveField(2)
  Pending,
  @HiveField(3)
  PO,
}

@HiveType(typeId: 0)
class PostedOrder extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  DateTime dateTime;
  @HiveField(2)
  double subtotal;
  @HiveField(3)
  double discount;
  @HiveField(4)
  double grandTotal;
  @HiveField(5)
  List<OrderList> orderList;
  @HiveField(6)
  PaidStatus paidStatus;
  @HiveField(7)
  String cashierName;
  @HiveField(8)
  String refernceOrder;

  PostedOrder({
    this.id,
    this.dateTime,
    this.subtotal,
    this.discount,
    this.grandTotal,
    this.orderList,
    this.paidStatus,
    this.cashierName,
    this.refernceOrder,
  });
}
