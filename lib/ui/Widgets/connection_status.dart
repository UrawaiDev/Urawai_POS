import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';

class ConnectionStatusWidget extends StatelessWidget {
  final TextStyle textStyle;

  ConnectionStatusWidget(this.textStyle);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: Consumer<ConnectivityResult>(
        builder: (context, value, _) => Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text('Connection Status:', style: textStyle),
            SizedBox(width: 10),
            CircleAvatar(
              maxRadius: 8,
              backgroundColor: value == ConnectivityResult.none || value == null
                  ? Colors.red
                  : Colors.lightGreen,
            )
          ],
        ),
      ),
    );
  }
}
