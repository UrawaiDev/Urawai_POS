import 'package:urawai_pos/Pages/Models/orderList.dart';

class PostedOrder {
  String id;
  String orderDate;
  double subtotal;
  double discount;
  double grandTotal;
  List<OrderList> orderList;

  PostedOrder(
      {this.id,
      this.orderDate,
      this.subtotal,
      this.discount,
      this.grandTotal,
      this.orderList});
}
