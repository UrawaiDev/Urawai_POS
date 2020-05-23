import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:urawai_pos/core/Provider/orderList_provider.dart';
import 'package:urawai_pos/core/Provider/postedOrder_provider.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';

class ExtraDiscoutDialog extends StatefulWidget {
  final dynamic state;
  ExtraDiscoutDialog(this.state);
  @override
  _ExtraDiscoutDialogState createState() => _ExtraDiscoutDialogState();
}

class _ExtraDiscoutDialogState extends State<ExtraDiscoutDialog> {
  final _formKey = GlobalKey<FormState>();
  var _textExtraDiscount = TextEditingController();

  List<bool> _isSelected = [true, false];
  int _currentIndex = 0;

  @override
  void dispose() {
    _textExtraDiscount.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Diskon',
        style: kDialogTextStyle,
      ),
      content: Container(
        width: 400,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _textExtraDiscount,
                  keyboardType: TextInputType.number,
                  maxLength: _isSelected[0] ? 7 : 2,
                  style: kDialogTextStyle,
                  decoration: InputDecoration(
                    icon: Text(
                      _isSelected[0] ? 'Rp.' : '%',
                      style: kDialogTextStyle,
                    ),
                    hintText: 'Masukkan Angka',
                  ),
                  validator: (value) {
                    if (value.isEmpty)
                      return 'Tidak Boleh Kosong.';
                    else if (!_isNumeric(value))
                      return 'Yang dimasukkan harus angka';
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(width: 10),
            ToggleButtons(
              children: <Widget>[
                Text(
                  'Rp',
                  style: kDialogTextStyle,
                ),
                Text(
                  '%',
                  style: kDialogTextStyle,
                )
              ],
              isSelected: _isSelected,
              onPressed: (int index) {
                _currentIndex = index;
                setState(() {
                  int count = 0;
                  _isSelected.forEach((bool val) {
                    if (val) count++;
                  });

                  if (_isSelected[index] && count < 2) return;
                  for (int buttonIndex = 0;
                      buttonIndex < _isSelected.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      _isSelected[buttonIndex] = !_isSelected[buttonIndex];
                    } else {
                      _isSelected[buttonIndex] = false;
                    }
                  }
                  _textExtraDiscount.clear();
                });
              },
            )
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            'Batal',
            style: kDialogTextStyle,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text(
            'OK',
            style: kDialogTextStyle,
          ),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              if (_currentIndex == 0) {
                if (widget.state is OrderListProvider)
                  widget.state.extraDicount =
                      double.tryParse(_textExtraDiscount.text);
                else if (widget.state is PostedOrderProvider)
                  widget.state.extraDicount =
                      double.tryParse(_textExtraDiscount.text);
              } else if (_currentIndex == 1) {
                if (widget.state is OrderListProvider)
                  widget.state.extraDicount = widget.state.subTotal *
                      (double.tryParse(_textExtraDiscount.text) / 100);
                else if (widget.state is PostedOrderProvider)
                  widget.state.extraDicount = widget.state.subTotal *
                      (double.tryParse(_textExtraDiscount.text) / 100);
              }

              Navigator.pop(context);
            }
          },
        )
      ],
    );
  }

  bool _isNumeric(String value) => num.tryParse(value) != null;
}
