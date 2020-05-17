import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:urawai_pos/core/Models/products.dart';

class FirestoreServices {
  Firestore _firestore = Firestore.instance;

  // get All Documents
  Stream<QuerySnapshot> getAllDocuments(String shopName) {
    var result = _firestore.collection(shopName).snapshots();

    return result;
  }

  Future<List<Product>> getProducts(String shopName) async {
    List<Product> products = [];

    QuerySnapshot result = await _firestore
        .collection(shopName + '_products')
        .orderBy('productName', descending: false)
        .getDocuments();

    for (var data in result.documents)
      products.add(Product(
          category: data['category'],
          discount: data['discount'].toDouble(),
          image: data['photo_url'],
          isRecommended: data['isPopuler'],
          name: data['productName'],
          price: data['price']));

    return products;
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
