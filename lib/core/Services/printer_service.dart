import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urawai_pos/core/Models/orderList.dart';
import 'package:urawai_pos/core/Provider/orderList_provider.dart';
import 'package:urawai_pos/core/Provider/postedOrder_provider.dart';

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

  static Future<void> printStruck({
    @required PrinterBluetooth printer,
    @required dynamic state,
    @required String shopName,
    @required List<OrderList> itemList,
    @required double pembayaran,
    @required double kembali,
  }) async {
    String _cashierName;
    DateTime _orderDate;
    String _referenceOrder;

    PrinterBluetoothManager _printerBluetoothManager =
        PrinterBluetoothManager();
    _printerBluetoothManager.selectPrinter(printer);
    const PaperSize paper = PaperSize.mm58;

    final Ticket ticket = Ticket(paper);

    if (state is PostedOrderProvider) {
      _cashierName = state.cashierName;
      _orderDate = state.postedOrder.dateTime;
      _referenceOrder = state.postedOrder.refernceOrder;
    } else if (state is OrderListProvider) {
      _cashierName = state.cashierName;
      _orderDate = state.orderDate;
      _referenceOrder = state.referenceOrder;
    }

    //* NAMA TOKO
    ticket.text(shopName,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    //* ALAMAT TOKO
    ticket.text('Griya Jasmine Rawageni',
        styles: PosStyles(align: PosAlign.center));
    ticket.text('Kp. Rawageni No. 5',
        styles: PosStyles(align: PosAlign.center));
    ticket.text('Depok, Jawa Barat', styles: PosStyles(align: PosAlign.center));
    ticket.text('Web: www.warungmakyos.com',
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);

    ticket.hr();

    //* HEADER LIST ORDER
    ticket.row([
      PosColumn(text: 'Qty', width: 1),
      PosColumn(text: 'Item', width: 7),
      // PosColumn(
      //     text: 'Harga', width: 2, styles: PosStyles(align: PosAlign.right)),
      PosColumn(
          text: 'Total', width: 4, styles: PosStyles(align: PosAlign.right)),
    ]);

    //* ITEM LIST ORDER
    itemList.forEach((transaction) {
      ticket.row([
        PosColumn(text: transaction.quantity.toString(), width: 1),
        PosColumn(text: transaction.productName, width: 7),
        PosColumn(
            text: (transaction.price * transaction.quantity).toString(),
            width: 4,
            styles: PosStyles(align: PosAlign.right)),
      ]);
    });

    ticket.hr();

    // double grandTotal =
    //     _transactions.fold(0, (prev, curr) => prev + curr.grandTotal);

    ticket.row([
      PosColumn(
          text: 'TOTAL',
          width: 3,
          styles: PosStyles(
            height: PosTextSize.size1,
            width: PosTextSize.size1,
          )),
      PosColumn(
          text: '\Rp.${state.grandTotal}',
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
          text: '\Rp.$pembayaran',
          width: 8,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
    ]);

    ticket.row([
      PosColumn(
          text: 'Kembali',
          width: 4,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
      PosColumn(
          text: '\Rp.$kembali',
          width: 8,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
    ]);

    ticket.feed(2);
    ticket.text('Terima Kasih.',
        styles: PosStyles(align: PosAlign.center, bold: true));

    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy H:mm');
    final String timestamp = formatter.format(now);
    ticket.text(timestamp,
        styles: PosStyles(align: PosAlign.center), linesAfter: 2);

    ticket.feed(1);
    ticket.cut();

    final PosPrintResult res =
        await _printerBluetoothManager.printTicket(ticket);
    print(res);

    // _scaffoldKey.currentState.showSnackBar(SnackBar(
    //   content: Text(res.msg),
    //   duration: Duration(seconds: 2),
    // ));
  }
}
