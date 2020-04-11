import 'package:hive/hive.dart';
import 'package:urawai_pos/Models/orderList.dart';

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
  String orderDate;
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

  PostedOrder(
      {this.id,
      this.orderDate,
      this.subtotal,
      this.discount,
      this.grandTotal,
      this.orderList,
      this.paidStatus});
}
