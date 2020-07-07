import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:urawai_pos/ui/Widgets/costum_DialogBox.dart';
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

  static const int DISCOUNT_WITH_PRICE = 0;
  static const int DISCOUNT_WITH_PERCENTAGE = 1;

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
              if (_currentIndex == DISCOUNT_WITH_PRICE) {
                double extraDiscount = double.tryParse(_textExtraDiscount.text);
                if (extraDiscount > widget.state.grandTotal) {
                  _showWarning();
                } else
                  _setExtraDiscount(extraDiscount);
              } else if (_currentIndex == DISCOUNT_WITH_PERCENTAGE) {
                double extraDiscount = widget.state.subTotal *
                    (double.tryParse(_textExtraDiscount.text) / 100);

                if (extraDiscount > widget.state.grandTotal) {
                  _showWarning();
                } else {
                  _setExtraDiscount(extraDiscount);
                }
              }

              // Navigator.pop(context);
            }
          },
        )
      ],
    );
  }

  bool _isNumeric(String value) => num.tryParse(value) != null;

  void _showWarning() {
    CostumDialogBox.showDialogInformation(
      context: context,
      icon: Icons.warning,
      iconColor: Colors.yellow,
      title: 'Informasi',
      contentText: 'Ups!!!. Diskon Melebihi Total Bayar.',
      onTap: () => Navigator.pop(context),
    );
  }

  void _setExtraDiscount(double extraDiscount) {
    widget.state.extraDicount = extraDiscount;
    Navigator.pop(context);
  }
}
