import 'package:flutter/material.dart';
import 'package:urawai_pos/core/Models/transaction.dart';

class PaymentHelper {
  static String getPaymentType(PaymentType paymentType) {
    switch (paymentType) {
      case PaymentType.CASH:
        return 'Tunai';
        break;
      case PaymentType.CREDIT_CARD:
        return 'Kartu Kredit';
        break;
      case PaymentType.DEBIT_CARD:
        return 'Kartu Debit';
        break;
      case PaymentType.EMONEY:
        return 'eMoney';
        break;
      default:
        return '-';
    }
  }

  static IconData getPaymentTypeIcon(PaymentType paymentType) {
    switch (paymentType) {
      case PaymentType.CASH:
        return Icons.money_off;
        break;
      case PaymentType.CREDIT_CARD:
        return Icons.mood;
        break;
      case PaymentType.DEBIT_CARD:
        return Icons.card_giftcard;
        break;
      case PaymentType.EMONEY:
        return Icons.casino;
        break;
      default:
        return Icons.note;
    }
  }

  static String getPaymentStatus(PaymentStatus paymentStatus) {
    switch (paymentStatus) {
      case PaymentStatus.COMPLETED:
        return 'Lunas';
        break;
      case PaymentStatus.PENDING:
        return 'Belum Lunas';
        break;
      case PaymentStatus.VOID:
        return 'Batal';
        break;
      default:
        return '-';
    }
  }
}
