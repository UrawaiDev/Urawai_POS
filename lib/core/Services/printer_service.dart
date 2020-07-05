import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urawai_pos/core/Models/transaction.dart';
import 'package:urawai_pos/ui/utils/constans/formatter.dart';
import 'package:urawai_pos/ui/utils/functions/paymentHelpers.dart';

class PrinterService {
  static Future<BluetoothDevice> loadPrinterDevice() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    BluetoothDevice bluetoothDevice = BluetoothDevice();

    bluetoothDevice.name = _pref.getString('deviceName');
    bluetoothDevice.address = _pref.getString('deviceAddress');
    bluetoothDevice.type = _pref.getInt('deviceType');

    return bluetoothDevice;
  }

  static Future<void> testPrint() async {
    PrinterBluetoothManager _printerBluetoothManager =
        PrinterBluetoothManager();
    var printer = await loadPrinterDevice();

    if (printer.name != null) {
      _printerBluetoothManager.selectPrinter(PrinterBluetooth(printer));

      const PaperSize paper = PaperSize.mm58;

      final Ticket ticket = Ticket(paper);

      ticket.text('Printer is Connected',
          styles: PosStyles(align: PosAlign.center));
      ticket.text('Printer is Ready to Work.',
          styles: PosStyles(align: PosAlign.center));

      ticket.feed(1);
      ticket.cut();

      final PosPrintResult res =
          await _printerBluetoothManager.printTicket(ticket);

      print(res);
    } else
      print('printer is not set');
  }

  static Future<PosPrintResult> printStruck({
    @required PrinterBluetooth printer,
    @required String shopName,
    @required TransactionOrder dataTransaction,
  }) async {
    PrinterBluetoothManager _printerBluetoothManager =
        PrinterBluetoothManager();
    _printerBluetoothManager.selectPrinter(printer);
    const PaperSize paper = PaperSize.mm58;

    final Ticket ticket = Ticket(paper);

    //* NAMA TOKO
    ticket.text(shopName,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    // //* ALAMAT TOKO
    // ticket.text('Jl. Pinggir kali',
    //     styles: PosStyles(align: PosAlign.center));
    // ticket.text('Kp. Kali asin No. 5',
    //     styles: PosStyles(align: PosAlign.center));
    // ticket.text('Depok, Jawa Barat', styles: PosStyles(align: PosAlign.center));
    // ticket.text('Web: www.warungmakyos.com',
    //     styles: PosStyles(align: PosAlign.center), linesAfter: 1);

    ticket.hr();

    //* HEADER LIST ORDER
    ticket.row([
      PosColumn(text: 'Qty', width: 2),
      PosColumn(text: 'Harga', width: 6),
      PosColumn(
          text: 'Total', width: 4, styles: PosStyles(align: PosAlign.right)),
    ]);

    ticket.hr();

    //* ITEM LIST ORDER
    dataTransaction.itemList.forEach((transaction) {
      ticket.row([
        PosColumn(text: transaction.productName.toString(), width: 12),
      ]);

      ticket.row([
        PosColumn(text: 'x${transaction.quantity}', width: 2),
        PosColumn(text: Formatter.currencyFormat(transaction.price), width: 6),
        PosColumn(
            text: Formatter.currencyFormat(
                transaction.price * transaction.quantity),
            width: 4,
            styles: PosStyles(align: PosAlign.right)),
      ]);
    });

    ticket.hr();

    ticket.row([
      PosColumn(
          text: 'DISKON',
          width: 3,
          styles: PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(
          text: Formatter.currencyFormat(dataTransaction.discount),
          width: 9,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
    ]);

    ticket.row([
      PosColumn(
          text: 'PAJAK (PPN)',
          width: 3,
          styles: PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(
          text: Formatter.currencyFormat(dataTransaction.vat),
          width: 9,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
    ]);

    ticket.row([
      PosColumn(
          text: 'TOTAL BAYAR',
          width: 3,
          styles: PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(
          text: Formatter.currencyFormat(dataTransaction.grandTotal),
          width: 9,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
    ]);

    ticket.hr(ch: '=', linesAfter: 1);

    ticket.row([
      PosColumn(
          text: 'Bayar',
          width: 4,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
      PosColumn(
          text: Formatter.currencyFormat(dataTransaction.tender),
          width: 8,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
    ]);

    ticket.row([
      PosColumn(
          text: 'Kembali',
          width: 4,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
      PosColumn(
          text: Formatter.currencyFormat(dataTransaction.change),
          width: 8,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
    ]);

    ticket.row([
      PosColumn(
          text: 'Jenis Bayar',
          width: 4,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
      PosColumn(
          text: PaymentHelper.getPaymentType(dataTransaction.paymentType),
          width: 8,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
    ]);

    ticket.row([
      PosColumn(
          text: 'Keterangan',
          width: 4,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
      PosColumn(
          text: PaymentHelper.getPaymentStatus(dataTransaction.paymentStatus),
          width: 8,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
    ]);

    ticket.feed(1);
    ticket.text('Terima Kasih.',
        styles: PosStyles(align: PosAlign.center, bold: true));

    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:mm');
    final String timestamp = formatter.format(now);
    ticket.text(timestamp,
        styles: PosStyles(align: PosAlign.center), linesAfter: 2);

    ticket.cut();

    final PosPrintResult result =
        await _printerBluetoothManager.printTicket(ticket);
    return result;
  }
}
