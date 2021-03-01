import 'package:Groceries/models/item.dart';
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'constants.dart';
import 'models/tag.dart';

class DatabaseService {
  Firestore _database = Firestore.instance;

  Stream<List<Item>> get groceryListStream {
    // Stream groceriesStream = _;

    // Stream tagsStream = ;
    var group = StreamGroup();
    // group.add(
    return _database
        .collection('groceries')
        .orderBy('editDate')
        // .orderBy('enabled', descending: true)
        .snapshots()
        .map(_itemListFromSnapshot);
    // group.add(tagStream());
    // group.close();
    // var stream = group.stream.asBroadcastStream();
    // print(stream.first);
  }

  List<Item> _itemListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      List tagNames = doc.data['tags'];
      List<Tag> tags = [];
      if (tagNames.length > 0) {
        tags = tagNames
            .map((name) => Tag(name: name, color: MyColors.randomColor))
            .toList();
        getTags().then((value) => tags = value.map((t) {
              if (tagNames.contains(t.name)) return t;
            }).toList());
      }
      return Item(
        id: doc.documentID,
        title: doc.data['title'],
        description: doc.data['description'],
        enabled: doc.data['enabled'],
        currentPos: doc.data['currentPos'],
        editDate: doc.data['editDate'],
        tags: tags,
      );
    }).toList();
  }

  Future addItem({String title, String description, List<Tag> tags}) async {
    try {
      return await _database.collection('groceries').add({
        'title': title,
        'description': description ?? '',
        'enabled': true,
        'currentPos': 0,
        'editDate': DateTime.now(),
        'tags': tags.map((e) => e.name).toList(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future editItem({Item item}) async {
    try {
      return await _database.collection('groceries').document(item.id).setData({
        'editDate': DateTime.now(),
        'title': item.title,
        'description': item.description ?? '',
        'enabled': true,
        'tags': item.tags.map((e) => e.name).toList(),
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

  void changeEnabled(Item item) {
    _database
        .collection('groceries')
        .document(item.id)
        .setData({'enabled': !item.enabled}, merge: true);
  }

  void deleteAllItems() {
    _database.collection('groceries').getDocuments().then((snapshot) =>
        snapshot.documents.forEach((element) => element.reference.delete()));
  }

  void deleteCheckedItems() {
    _database
        .collection('groceries')
        .where('enabled', isEqualTo: false)
        .getDocuments()
        .then((snapshot) => snapshot.documents
            .forEach((element) => element.reference.delete()));
  }

  /// Tags

  Future addTag(Tag tag) {
    try {
      return _database
          .collection('tags')
          .document(tag.name)
          .setData({'color': tag.color.value.toString()});
    } catch (e) {
      return e;
    }
  }

  Stream<List<Tag>> tagStream() {
    try {
      return _database.collection('tags').snapshots().map((qs) =>
          qs.documents.map((e) => Tag.fromDocumentSnapshot(e)).toList());
    } catch (e) {}
  }

  Future<List<Tag>> getTags() async {
    try {
      var qs = await _database.collection('tags').getDocuments();
      var list = qs.documents.map((e) => Tag.fromDocumentSnapshot(e)).toList();
      return list;
    } catch (e) {}
  }
}
