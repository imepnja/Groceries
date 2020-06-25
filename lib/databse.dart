import 'package:Groceries/models/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  Firestore _database = Firestore.instance;

  Stream<List<Item>> get groceryListStream {
    return _database
        .collection('groceries')
        .orderBy('editDate')
        .orderBy('enabled')
        .snapshots()
        .map(_itemListFromSnapshot);
    ;
  }

  List<Item> _itemListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Item(
        id: doc.documentID,
        title: doc.data['title'],
        description: doc.data['description'],
        enabled: doc.data['enabled'],
        currentPos: doc.data['currentPos'],
        editDate: doc.data['editDate'],
      );
    }).toList();
  }

  Future addItem({String title, String description}) async {
    try {
      return await _database.collection('groceries').add({
        'title': title,
        'description': description ?? '',
        'enabled': true,
        'currentPos': 0,
        'editDate': DateTime.now(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future editItem({String id, String title, String description}) async {
    try {
      return await _database.collection('groceries').document(id).setData({
        'editDate': DateTime.now(),
        'title': title,
        'description': description ?? '',
        'enabled': true,
      }, merge: true);
    } catch (e) {
      print(e);
    }
  }

  Future removeItem(String id) async {
    try {
      return await _database.collection('groceries').document(id).delete();
    } catch (e) {
      print(e);
    }
  }

  void changeEnabled(Item item, int newPos) {
    _database
        .collection('groceries')
        .document(item.id)
        .setData({'enabled': !item.enabled, 'currentPos': newPos}, merge: true);
  }

  void deleteAllItems() {
    _database.collection('groceries').getDocuments().then((snapshot) =>
        snapshot.documents.forEach((element) => element.reference.delete()));
  }

  void deleteCheckedItems() {
    _database.collection('groceries').where('enabled', isEqualTo: false).getDocuments().then((snapshot) =>
        snapshot.documents.forEach((element) => element.reference.delete()));
  }
}
