import 'package:urawai_pos/Pages/Models/orderList.dart';

class PostedOrder {
  String id;
  String orderDate;
  List<OrderList> orderList;

  PostedOrder({this.id, this.orderDate, this.orderList});
}
