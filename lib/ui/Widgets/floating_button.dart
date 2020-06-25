import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final Function onSaveTap;
  final Function onDiscountTap;
  final Function onDeleteTap;
  final Function onPayTap;

  const FloatingButton({
    Key key,
    this.onSaveTap,
    this.onDiscountTap,
    this.onDeleteTap,
    this.onPayTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedFloatingActionButton(
      colorStartAnimation: Colors.blue,
      colorEndAnimation: Colors.red,
      animatedIconData: AnimatedIcons.menu_close,
      fabButtons: <Widget>[
        _buttonSave(),
        _buttonDiscount(),
        _buttonDelete(),
        _buttonPay(),
      ],
    );
  }

  Widget _buttonSave() {
    return FloatingActionButton(
      child: Icon(Icons.save),
      heroTag: 'btnSave',
      tooltip: 'Simpan Pesanan',
      onPressed: onSaveTap,
    );
  }

  Widget _buttonDiscount() {
    return FloatingActionButton(
      heroTag: 'btnDiscount',
      tooltip: 'Diskon',
      child: Icon(
        Icons.disc_full,
      ),
      onPressed: onDiscountTap,
    );
  }

  Widget _buttonDelete() {
    return FloatingActionButton(
      backgroundColor: Colors.red,
      heroTag: 'btnDelete',
      tooltip: 'Hapus',
      child: Icon(
        Icons.delete,
      ),
      onPressed: onDeleteTap,
    );
  }

  Widget _buttonPay() {
    return FloatingActionButton(
      backgroundColor: Colors.green,
      heroTag: 'btnPay',
      tooltip: 'Proses Bayar',
      child: Icon(
        Icons.payment,
      ),
      onPressed: onPayTap,
    );
  }
}
