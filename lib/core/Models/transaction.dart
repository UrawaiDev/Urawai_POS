import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import '../Models/orderList.dart';

part 'transaction.g.dart';

@HiveType(typeId: 3)
class TransactionOrder {
  static const String boxName = 'TransactionOrder';
  @HiveField(0)
  String id;
  @HiveField(1)
  String cashierName;
  @HiveField(2)
  String referenceOrder;
  @HiveField(3)
  DateTime date;
  @HiveField(4)
  double grandTotal;
  @HiveField(5)
  PaymentType paymentType;
  @HiveField(6)
  PaymentStatus paymentStatus;
  @HiveField(7)
  List<dynamic> itemList;
  @HiveField(8)
  double subtotal;
  @HiveField(9)
  double discount;
  @HiveField(10)
  double tender;
  @HiveField(11)
  double change;
  @HiveField(12)
  double vat;

  TransactionOrder({
    this.id,
    this.cashierName,
    this.referenceOrder,
    this.date,
    this.grandTotal,
    this.paymentType,
    this.paymentStatus,
    this.itemList,
    this.discount,
    this.subtotal,
    this.change,
    this.tender,
    this.vat,
  });

  TransactionOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cashierName = json['cashierName'];
    referenceOrder = json['referenceOrder'];
    date = (json['orderDate'] as Timestamp).toDate();
    grandTotal = json['grandTotal'];

    switch (json['paymentType']) {
      case 'PaymentType.CASH':
        paymentType = PaymentType.CASH;
        break;
      case 'PaymentType.CREDIT_CARD':
        paymentType = PaymentType.CREDIT_CARD;
        break;
      case 'PaymentType.DEBIT_CARD':
        paymentType = PaymentType.DEBIT_CARD;
        break;
      case 'PaymentType.EMONEY':
        paymentType = PaymentType.EMONEY;
        break;
      default:
        paymentType = PaymentType.CASH;
    }

    switch (json['paymentStatus']) {
      case 'PaymentStatus.COMPLETED':
        paymentStatus = PaymentStatus.COMPLETED;
        break;
      case 'PaymentStatus.PENDING':
        paymentStatus = PaymentStatus.PENDING;
        break;
      case 'PaymentStatus.VOID':
        paymentStatus = PaymentStatus.VOID;
        break;
      default:
        paymentStatus = PaymentStatus.COMPLETED;
    }

    if (json['orderlist'] != null) {
      itemList = new List<OrderList>();
      json['orderlist'].forEach((v) {
        itemList.add(new OrderList.fromJson(v));
      });
    }

    discount = json['discount'].toDouble();
    subtotal = json['subtotal'].toDouble();
    change = json['change'].toDouble();
    tender = json['tender'].toDouble();
    vat = json['vat'].toDouble();
  }
}

@HiveType(typeId: 4)
enum PaymentType {
  @HiveField(0)
  CASH,
  @HiveField(1)
  DEBIT_CARD,
  @HiveField(2)
  CREDIT_CARD,
  @HiveField(3)
  EMONEY,
}

@HiveType(typeId: 5)
enum PaymentStatus {
  @HiveField(0)
  COMPLETED,
  @HiveField(1)
  VOID,
  @HiveField(2)
  PENDING,
}
