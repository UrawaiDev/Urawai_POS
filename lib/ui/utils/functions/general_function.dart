import 'package:urawai_pos/core/Models/carousel_intro.dart';
import 'package:urawai_pos/core/Models/orderList.dart';

int totalOrderLength(List<OrderList> orderlist) {
  int result = orderlist.fold(0, (prev, element) => prev + element.quantity);

  return result;
}
