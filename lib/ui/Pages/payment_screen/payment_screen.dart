import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:urawai_pos/core/Models/orderList.dart';
import 'package:urawai_pos/core/Models/postedOrder.dart';
import 'package:urawai_pos/core/Models/transaction.dart';
import 'package:urawai_pos/core/Provider/general_provider.dart';
import 'package:urawai_pos/core/Provider/orderList_provider.dart';
import 'package:urawai_pos/core/Provider/postedOrder_provider.dart';
import 'package:urawai_pos/core/Provider/transactionOrder_provider.dart';
import 'package:urawai_pos/core/Services/connectivity_service.dart';
import 'package:urawai_pos/core/Services/firebase_auth.dart';
import 'package:urawai_pos/ui/Widgets/costum_DialogBox.dart';
import 'package:urawai_pos/ui/Widgets/left_paymentScreen_OrderList.dart';
import 'package:urawai_pos/ui/Widgets/left_paymentScreen_postedOrder.dart';
import 'package:urawai_pos/ui/utils/constans/formatter.dart';
import 'package:urawai_pos/ui/utils/constans/utils.dart';
import 'package:urawai_pos/ui/utils/functions/paymentHelpers.dart';
import 'package:urawai_pos/ui/utils/functions/routeGenerator.dart';

class PaymentScreen extends StatefulWidget {
  final dynamic itemList;
  static const String postedOrderBox = "Posted_Order";

  PaymentScreen(this.itemList);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final locatorAuth = GetIt.I<FirebaseAuthentication>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final generalState = Provider.of<GeneralProvider>(context);

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Container(
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                StreamProvider<ConnectivityResult>(
                  create: (builder) =>
                      ConnectivityService().networkStatusController.stream,
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        //LEFT SIDE
                        (widget.itemList is PostedOrder)
                            ? PaymentScreenLeftPostedOrder(widget.itemList)
                            : PaymentScreenLeftOrderList(widget.itemList),

                        //RIGHT SIDE
                        Expanded(
                            flex: 2,
                            child: Container(
                                // color: Colors.blue,
                                child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: PaymentType.values.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Consumer<GeneralProvider>(
                                                builder: (context, state, _) =>
                                                    GestureDetector(
                                                  child: AnimatedContainer(
                                                    duration: Duration(
                                                        milliseconds: 700),
                                                    curve: Curves.easeIn,
                                                    alignment: Alignment.center,
                                                    width: 180,
                                                    decoration: BoxDecoration(
                                                        color: index ==
                                                                state
                                                                    .paymentType
                                                                    .index
                                                            ? kSelectedColor
                                                            : Colors.grey[200],
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Icon(
                                                            PaymentHelper
                                                                .getPaymentTypeIcon(
                                                                    PaymentType
                                                                            .values[
                                                                        index]),
                                                            size: 35),
                                                        SizedBox(width: 5),
                                                        AutoSizeText(
                                                          PaymentHelper
                                                              .getPaymentType(
                                                                  PaymentType
                                                                          .values[
                                                                      index]),
                                                          style:
                                                              kPriceTextStyle,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    state.paymentType =
                                                        PaymentType
                                                            .values[index];
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )),
                                  Expanded(
                                    flex: 8,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.blue,
                                          width: 2,
                                        ),
                                        color: Color(0xFFf5f6f7),
                                      ),
                                      child: _paymentMethod(
                                          generalState.paymentType),
                                    ),
                                  ),
                                ],
                              ),
                            ))),
                      ],
                    ),
                  ),
                ),
                Consumer<GeneralProvider>(
                    builder: (_, value, __) => (value.isLoading)
                        ? _showLoading(context)
                        : Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _paymentMethod(PaymentType paymentType) {
    if (paymentType == PaymentType.CASH) {
      return _cashPaymentWidget();
    } else
      return _nonCashPaymentWidget();
  }

  Widget _nonCashPaymentWidget() {
    return Consumer2<PostedOrderProvider, OrderListProvider>(
        builder: (context, statePostedOrder, stateOrderList, _) {
      var state;
      List<OrderList> currentOrderList;
      if (widget.itemList is PostedOrder) {
        state = statePostedOrder;
        currentOrderList = statePostedOrder.postedOrder.orderList;
      } else {
        state = stateOrderList;
        currentOrderList = stateOrderList.orderlist;
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(
                    color: Colors.blue,
                    width: 3,
                  )),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total Bayar',
                      style: TextStyle(
                        fontSize: 27,
                        color: Colors.white,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        Formatter.currencyFormat(state.grandTotal),
                        style: TextStyle(
                          fontSize: 27,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buttonPayment(
              color: Colors.blue,
              text: Text(
                'BAYAR',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                GeneralProvider generalProvider =
                    Provider.of<GeneralProvider>(context, listen: false);
                if (currentOrderList.isNotEmpty)
                  _proceedPayment(state, generalProvider.paymentType);
                else {
                  CostumDialogBox.showDialogInformation(
                      title: 'Informasi',
                      context: context,
                      contentText:
                          'Pastikan pembayaran telah dilakukan & Pesanan tidak Kosong.',
                      icon: Icons.warning,
                      iconColor: Colors.yellow,
                      onTap: () => Navigator.pop(context));
                }
              }),
        ],
      );
    });
  }

  Widget _cashPaymentWidget() {
    return Consumer2<PostedOrderProvider, OrderListProvider>(
        builder: (context, statePostedOrder, stateOrderList, _) {
      var deviceScreenType = getDeviceType(MediaQuery.of(context).size);
      var state;
      if (widget.itemList is PostedOrder)
        state = statePostedOrder;
      else
        state = stateOrderList;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Container(
                  // color: Colors.blue,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: deviceScreenType == DeviceScreenType.tablet
                            ? 40
                            : 30,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(
                              color: Colors.blue,
                              width: 2,
                            )),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              AutoSizeText(
                                'Total Bayar',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              AutoSizeText(
                                Formatter.currencyFormat(state.grandTotal),
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: deviceScreenType == DeviceScreenType.tablet
                            ? 40
                            : 30,
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        )),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              AutoSizeText(
                                'Pembayaran',
                                style: TextStyle(fontSize: 20),
                              ),
                              AutoSizeText(
                                Formatter.currencyFormat(state.finalPayment),
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        height: deviceScreenType == DeviceScreenType.tablet
                            ? 40
                            : 30,
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        )),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              AutoSizeText(
                                'Kembali',
                                style: TextStyle(fontSize: 20),
                              ),
                              // Only return value when bigger dan grandTotal
                              AutoSizeText(
                                state.finalPayment != 0 &&
                                        state.finalPayment > state.grandTotal
                                    ? Formatter.currencyFormat(
                                        state.finalPayment - state.grandTotal)
                                    : 'Rp. 0',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                child: keyPadArea(context),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget keyPadArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
          // color: Color(0xFFf5f6f7),

          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Consumer2<PostedOrderProvider, OrderListProvider>(
              builder: (context, statePostedOrder, stateOrderList, _) {
            var state;
            if (widget.itemList is PostedOrder)
              state = statePostedOrder;
            else
              state = stateOrderList;

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      _keypadCard('1', () => _keyPadNumber('1', state)),
                      SizedBox(width: 10),
                      _keypadCard('2', () => _keyPadNumber('2', state)),
                      SizedBox(width: 10),
                      _keypadCard('3', () => _keyPadNumber('3', state)),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      _keypadCard('4', () => _keyPadNumber('4', state)),
                      SizedBox(width: 10),
                      _keypadCard('5', () => _keyPadNumber('5', state)),
                      SizedBox(width: 10),
                      _keypadCard('6', () => _keyPadNumber('6', state)),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      _keypadCard('7', () => _keyPadNumber('7', state)),
                      SizedBox(width: 10),
                      _keypadCard('8', () => _keyPadNumber('8', state)),
                      SizedBox(width: 10),
                      _keypadCard('9', () => _keyPadNumber('9', state)),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      _keypadCard('Hapus', () {
                        if (state.totalPayment.isNotEmpty) {
                          var result = state.totalPayment
                              .substring(0, state.totalPayment.length - 1);
                          state.totalPayment = result;
                          if (result.isNotEmpty) {
                            state.finalPayment = double.parse(result);
                          } else
                            state.finalPayment = 0.0;
                        }
                      }),
                      SizedBox(width: 10),
                      _keypadCard('0', () => _keyPadNumber('0', state)),
                      SizedBox(width: 10),
                      _keypadCard('C', () {
                        state.totalPayment = '';
                        state.finalPayment = 0.0;
                      }),
                      SizedBox(width: 10),
                    ],
                  ),
                )
              ],
            );
          }),
          //Right Side
          Consumer2<PostedOrderProvider, OrderListProvider>(
              builder: (context, statePostedOrder, stateOrderList, _) {
            var state;
            List<OrderList> currentOrderList;
            if (widget.itemList is PostedOrder) {
              state = statePostedOrder;
              currentOrderList = statePostedOrder.postedOrder.orderList;
            } else {
              state = stateOrderList;
              currentOrderList = stateOrderList.orderlist;
            }

            return Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: _buttonPayment(
                        text: Text(
                          'Uang Pas',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        color: Colors.grey[300],
                        onTap: () {
                          state.finalPayment = state.grandTotal;
                        }),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        _buttonPaymentSuggestion(
                          text: '50K',
                          context: context,
                          onTap: () => state.finalPayment = 50000.0,
                        ),
                        _buttonPaymentSuggestion(
                          text: '100K',
                          context: context,
                          onTap: () => state.finalPayment = 100000.0,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: _buttonPayment(
                        color: Colors.blue,
                        text: Text(
                          'BAYAR',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          if (state.finalPayment != 0 &&
                              state.finalPayment >= state.grandTotal &&
                              currentOrderList.isNotEmpty) {
                            _proceedPayment(state, PaymentType.CASH);
                          } else {
                            CostumDialogBox.showDialogInformation(
                                title: 'Informasi',
                                context: context,
                                contentText:
                                    'Pastikan pembayaran telah dilakukan & Pesanan tidak Kosong.',
                                icon: Icons.warning,
                                iconColor: Colors.yellow,
                                onTap: () => Navigator.pop(context));
                          }
                        }),
                  ),
                ],
              ),
            );
          })
        ],
      )),
    );
  }

  void _keyPadNumber(String inputValue, dynamic state) {
    var currentValue = state.totalPayment;
    state.totalPayment = currentValue + inputValue;
    state.finalPayment = double.parse(state.totalPayment);
  }

  Padding _buttonPayment({Text text, Color color, Function onTap}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          width: 300,
          height: 100,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: text,
        ),
      ),
    );
  }

  Widget _buttonPaymentSuggestion(
      {String text, Function onTap, BuildContext context}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: AutoSizeText(
              text,
              style: TextStyle(fontSize: 17),
            ),
          ),
        ),
      ),
    );
  }

  Widget _keypadCard(String title, Function onTap) {
    var deviceScreenType = getDeviceType(MediaQuery.of(context).size);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[400],
        ),
        width: deviceScreenType == DeviceScreenType.tablet ? 120 : 85,
        child: AutoSizeText(title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }

  void _proceedPayment(dynamic state, PaymentType paymentType) {
    CostumDialogBox.showCostumDialogBox(
      context: context,
      title: 'Konfirmasi',
      icon: Icons.receipt,
      iconColor: Colors.blue,
      contentString: 'Lanjutkan Proses ?',
      confirmButtonTitle: 'Proses',
      onConfirmPressed: () async {
        bool postedStatus;
        final generalProvider =
            Provider.of<GeneralProvider>(context, listen: false);
        generalProvider.paymentStatus = PaymentStatus.COMPLETED;

        //Closed Confirmation DialogBox
        Navigator.pop(context);
        //START LOADING
        generalProvider.isLoading = true;

        final transactionProvider =
            Provider.of<TransactionOrderProvider>(context, listen: false);
        final connectionStatus =
            Provider.of<ConnectivityResult>(context, listen: false);

        final currentUser = await locatorAuth.currentUserXXX;
        if (connectionStatus == ConnectivityResult.none) {
          //Add Transaction to Hive DB when Offline
          postedStatus =
              Provider.of<TransactionOrderProvider>(context, listen: false)
                  .addTransactionOrder(
            stateProvider: state,
            paymentStatus: generalProvider.paymentStatus,
            paymentType: paymentType,
          );
        } else {
          // add to Firestore DB when Online
          postedStatus = await transactionProvider.addTransactionToFirestore(
              stateProvider: state,
              paymentStatus: generalProvider.paymentStatus,
              paymentType: paymentType,
              shopName: currentUser.shopName);
        }

        //delete Posted Order
        if (widget.itemList is PostedOrder) {
          final postedOrderProvider =
              Provider.of<PostedOrderProvider>(context, listen: false);
          // Hive.box<PostedOrder>(POSPage.postedBoxName)
          //     .delete(state.postedOrder.id);
          print('Delete Posted Order: ${state.postedOrder.id}');
          postedOrderProvider.deletePostedOrder(state.postedOrder.id);
          postedOrderProvider.resetFinalPayment();
        }

        if (postedStatus == true) {
          String _orderID;

          //STOP LOADING
          generalProvider.isLoading = false;

          //Extract Order ID
          if (state is PostedOrderProvider)
            _orderID = state.postedOrder.id;
          else if (state is OrderListProvider) _orderID = state.orderID;

          //Navigate to Payment Success Screen
          Navigator.pushNamed(context, RouteGenerator.kRoutePaymentSuccessPage,
              arguments: _orderID);
        }
      },
    );
  }

  Widget _showLoading(BuildContext context) {
    return Positioned.fill(
      child: Container(
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
      ),
    );
  }
}
