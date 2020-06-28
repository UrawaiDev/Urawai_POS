import 'package:app_settings/app_settings.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:urawai_pos/core/Services/printer_service.dart';
import 'package:urawai_pos/ui/Widgets/costum_DialogBox.dart';

class SearchPrinterPage extends StatefulWidget {
  @override
  _SearchPrinterPageState createState() => _SearchPrinterPageState();
}

class _SearchPrinterPageState extends State<SearchPrinterPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PrinterBluetoothManager _printerBluetoothManager = PrinterBluetoothManager();
  BluetoothManager _bluetoothManager = BluetoothManager.instance;
  List<PrinterBluetooth> _devices = [];

  static const int BLUETOOTH_DISCONNECTED = 10;
  int connectionStatus;

  @override
  void initState() {
    super.initState();
    _bluetoothManager.state.listen((result) {
      connectionStatus = result;
      if (result == BLUETOOTH_DISCONNECTED)
        print('Bluetooth is OFF');
      else
        print('Bluetooth is ON');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Pengaturan Bluetooth Printer'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.print),
            onPressed: () async {
              if (connectionStatus == BLUETOOTH_DISCONNECTED) {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Bluetooth tidak Aktif'),
                    IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () => AppSettings.openBluetoothSettings()),
                  ],
                )));
              } else {
                var printer = await loadPrinterDevice();

                if (printer.name != null)
                  // _testPrint(PrinterBluetooth(printer));
                  PrinterService.testPrint();
                else {
                  CostumDialogBox.showDialogInformation(
                    context: context,
                    title: 'Informasi',
                    contentText: 'Printer Belum diSet.',
                    icon: Icons.info,
                    iconColor: Colors.blue,
                    onTap: () => Navigator.pop(context),
                  );
                }
              }
            },
          )
        ],
      ),
      floatingActionButton: StreamBuilder<bool>(
          stream: _bluetoothManager.isScanning,
          builder: (context, snapshot) {
            if (snapshot.data == true) return _stopScan();
            return _starScan();
          }),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'List Available Devices:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 10),
            Expanded(
                child: ListView.builder(
                    itemCount: _devices.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_devices[index].name),
                        subtitle: Text(_devices[index].address),
                        trailing: RaisedButton(
                            child: Text(
                              'Set',
                              style: TextStyle(fontSize: 15),
                            ),
                            onPressed: () async {
                              SharedPreferences _pref =
                                  await SharedPreferences.getInstance();

                              _pref.setString(
                                  'deviceName', _devices[index].name);
                              _pref.setString(
                                  'deviceAddress', _devices[index].address);
                              _pref.setInt('deviceType', _devices[index].type);

                              CostumDialogBox.showDialogInformation(
                                context: context,
                                title: 'Informasi',
                                contentText:
                                    'Printer telah di Set. \nNama Printer: ${_devices[index].name} \nSilahkan Tekan Icon Printer untuk Test Printer.',
                                icon: Icons.check_box,
                                iconColor: Colors.green,
                                onTap: () => Navigator.pop(context),
                              );
                            }),
                      );
                    }))
          ],
        ),
      ),
    );
  }

  FloatingActionButton _stopScan() {
    return FloatingActionButton(
      backgroundColor: Colors.red,
      child: Icon(Icons.stop),
      onPressed: () => _printerBluetoothManager.stopScan(),
    );
  }

  FloatingActionButton _starScan() {
    return FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () async {
          if (connectionStatus == BLUETOOTH_DISCONNECTED ||
              connectionStatus == null) {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Bluetooth tidak Aktif'),
                IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () => AppSettings.openBluetoothSettings()),
              ],
            )));
          } else {
            _printerBluetoothManager.startScan(Duration(seconds: 4));
            _printerBluetoothManager.scanResults.listen(
              (scannedDevices) {
                // print(scannedDevices);
                if (scannedDevices != null) {
                  setState(() => _devices = scannedDevices);
                }
              },
              onError: () => print('error happen'),
            );
          }
        });
  }

  Future<BluetoothDevice> loadPrinterDevice() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    BluetoothDevice bluetoothDevice = BluetoothDevice();

    bluetoothDevice.name = _pref.getString('deviceName');
    bluetoothDevice.address = _pref.getString('deviceAddress');
    bluetoothDevice.type = _pref.getInt('deviceType');

    return bluetoothDevice;
  }
}
