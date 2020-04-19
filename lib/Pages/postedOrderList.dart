import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:urawai_pos/Models/postedOrder.dart';

class PostedOrderList extends StatelessWidget {
  static const postedBoxName = "posted_order";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
            future: Hive.openBox<PostedOrder>(postedBoxName),
            builder: (context, snapshot) {
              var orderBox = Hive.box<PostedOrder>(postedBoxName);
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return ListView.builder(
                    itemCount: orderBox.length,
                    itemBuilder: (context, index) {
                      var item = orderBox.getAt(index);

                      return ListTile(
                        title: Text(item.id),
                        subtitle: Column(
                          children: <Widget>[
                            Text(item.orderList[0].productName),
                            Text(item.orderList[0].price.toString()),
                            Text(item.orderList[0].quantity.toString()),
                            Text(item.paidStatus.toString()),
                          ],
                        ),
                      );
                    });
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
