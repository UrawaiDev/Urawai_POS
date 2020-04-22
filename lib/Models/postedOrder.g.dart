// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postedOrder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaidStatusAdapter extends TypeAdapter<PaidStatus> {
  @override
  final typeId = 1;

  @override
  PaidStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PaidStatus.Paid;
      case 1:
        return PaidStatus.UnPaid;
      case 2:
        return PaidStatus.Pending;
      case 3:
        return PaidStatus.PO;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, PaidStatus obj) {
    switch (obj) {
      case PaidStatus.Paid:
        writer.writeByte(0);
        break;
      case PaidStatus.UnPaid:
        writer.writeByte(1);
        break;
      case PaidStatus.Pending:
        writer.writeByte(2);
        break;
      case PaidStatus.PO:
        writer.writeByte(3);
        break;
    }
  }
}

class PostedOrderAdapter extends TypeAdapter<PostedOrder> {
  @override
  final typeId = 0;

  @override
  PostedOrder read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostedOrder(
      id: fields[0] as String,
      orderDate: fields[1] as String,
      subtotal: fields[2] as double,
      discount: fields[3] as double,
      grandTotal: fields[4] as double,
      orderList: (fields[5] as List)?.cast<OrderList>(),
      paidStatus: fields[6] as PaidStatus,
      cashierName: fields[7] as String,
      refernceOrder: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PostedOrder obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.orderDate)
      ..writeByte(2)
      ..write(obj.subtotal)
      ..writeByte(3)
      ..write(obj.discount)
      ..writeByte(4)
      ..write(obj.grandTotal)
      ..writeByte(5)
      ..write(obj.orderList)
      ..writeByte(6)
      ..write(obj.paidStatus)
      ..writeByte(7)
      ..write(obj.cashierName)
      ..writeByte(8)
      ..write(obj.refernceOrder);
  }
}
