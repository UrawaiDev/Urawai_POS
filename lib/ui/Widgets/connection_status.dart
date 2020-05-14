import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';

class ConnectionStatusWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: Consumer<ConnectivityResult>(
        builder: (context, value, _) => Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text('Connection Status:', style: kPriceTextStyle),
            SizedBox(width: 10),
            CircleAvatar(
              maxRadius: 8,
              backgroundColor: value == ConnectivityResult.none || value == null
                  ? Colors.red
                  : Colors.green,
            )
          ],
        ),
      ),
    );
  }
}
