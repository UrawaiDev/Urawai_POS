// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentTypeAdapter extends TypeAdapter<PaymentType> {
  @override
  final typeId = 4;

  @override
  PaymentType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PaymentType.CASH;
      case 1:
        return PaymentType.DEBIT_CARD;
      case 2:
        return PaymentType.CREDIT_CARD;
      case 3:
        return PaymentType.EMONEY;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, PaymentType obj) {
    switch (obj) {
      case PaymentType.CASH:
        writer.writeByte(0);
        break;
      case PaymentType.DEBIT_CARD:
        writer.writeByte(1);
        break;
      case PaymentType.CREDIT_CARD:
        writer.writeByte(2);
        break;
      case PaymentType.EMONEY:
        writer.writeByte(3);
        break;
    }
  }
}

class PaymentStatusAdapter extends TypeAdapter<PaymentStatus> {
  @override
  final typeId = 5;

  @override
  PaymentStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PaymentStatus.COMPLETED;
      case 1:
        return PaymentStatus.VOID;
      case 2:
        return PaymentStatus.PENDING;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, PaymentStatus obj) {
    switch (obj) {
      case PaymentStatus.COMPLETED:
        writer.writeByte(0);
        break;
      case PaymentStatus.VOID:
        writer.writeByte(1);
        break;
      case PaymentStatus.PENDING:
        writer.writeByte(2);
        break;
    }
  }
}

class TransactionOrderAdapter extends TypeAdapter<TransactionOrder> {
  @override
  final typeId = 3;

  @override
  TransactionOrder read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionOrder(
      id: fields[0] as String,
      cashierName: fields[1] as String,
      referenceOrder: fields[2] as String,
      date: fields[3] as DateTime,
      grandTotal: fields[4] as double,
      paymentType: fields[5] as PaymentType,
      paymentStatus: fields[6] as PaymentStatus,
      itemList: (fields[7] as List)?.cast<dynamic>(),
      discount: fields[9] as double,
      subtotal: fields[8] as double,
      change: fields[11] as double,
      tender: fields[10] as double,
      vat: fields[12] as double,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionOrder obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.cashierName)
      ..writeByte(2)
      ..write(obj.referenceOrder)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.grandTotal)
      ..writeByte(5)
      ..write(obj.paymentType)
      ..writeByte(6)
      ..write(obj.paymentStatus)
      ..writeByte(7)
      ..write(obj.itemList)
      ..writeByte(8)
      ..write(obj.subtotal)
      ..writeByte(9)
      ..write(obj.discount)
      ..writeByte(10)
      ..write(obj.tender)
      ..writeByte(11)
      ..write(obj.change)
      ..writeByte(12)
      ..write(obj.vat);
  }
}
