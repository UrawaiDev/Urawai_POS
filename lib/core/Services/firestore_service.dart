import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urawai_pos/core/Models/orderList.dart';
import 'package:urawai_pos/core/Models/transaction.dart';

class FirestoreServices {
  Firestore _firestore = Firestore.instance;

  // get All Documents
  Stream<QuerySnapshot> getAllDocuments(String shopName) {
    var result = _firestore
        .collection(shopName)
        .orderBy('orderDate', descending: true)
        .snapshots();

    return result;
  }

  Stream<QuerySnapshot> getDocumentLength(String shopName) {
    return _firestore.collection(shopName).snapshots();
  }

  // get Document by selected Date
  Stream<QuerySnapshot> getDocumentByDate(
      String shopName, List<DateTime> date) {
    Stream<QuerySnapshot> result;
    if (date.length == 1) {
      result = _firestore
          .collection(shopName)
          .where('orderDate',
              isEqualTo:
                  date[0]) // TODO: Will compare the Date only wihout Time
          .snapshots();
    } else if (date.length == 2) {
      result = _firestore
          .collection(shopName)
          .where('orderDate', isGreaterThanOrEqualTo: date[0])
          .where('orderDate', isLessThanOrEqualTo: date[1])
          .snapshots();
    }

    return result;
  }

  // get Document by Document ID
  Stream<DocumentSnapshot> getDocumentByID(
    String shopName,
    String id,
  ) {
    Stream<DocumentSnapshot> result =
        _firestore.collection(shopName).document(id).snapshots();

    return result;
  }

  //delete transaction by ID
  Future<void> deleteTransaction(String shopName, String id) async {
    await _firestore.collection(shopName).document(id).delete();
  }
}
