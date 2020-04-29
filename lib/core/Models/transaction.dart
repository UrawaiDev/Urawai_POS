import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 3)
class TransactionOrder {
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

  TransactionOrder({
    this.id,
    this.cashierName,
    this.referenceOrder,
    this.date,
    this.grandTotal,
    this.paymentType,
    this.paymentStatus,
    this.itemList,
  });
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
