import 'package:flutter/material.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';

class LoadingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.grey.withOpacity(0.6),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          width: 250,
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: 80, height: 80, child: CircularProgressIndicator()),
              SizedBox(height: 10),
              Text('Loading...', style: kPriceTextStyle),
            ],
          ),
        ),
      ),
    );
  }
}
