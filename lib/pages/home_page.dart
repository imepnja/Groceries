import 'package:Groceries/models/tag.dart';
import 'package:Groceries/navigator.dart';
import 'package:Groceries/pages/add_item_page.dart';
import 'package:Groceries/databse.dart';
import 'package:Groceries/models/item.dart';
import 'package:Groceries/pages/edit_item_page.dart';
import 'package:animated_stream_list/animated_stream_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../models/item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<AnimatedListState> listKey = new GlobalKey<AnimatedListState>();

  DatabaseService databaseService = DatabaseService();

  List<Item> updateColors(List<Item> items, List<Tag> allTags) {
    return items = items.map((i) {
      i.tags = i.tags
          .map((tag) => allTags
              .firstWhere((element) => element.name == tag.name, orElse: null))
          .toList();
      return i;
    }).toList();
  }

  void edit(Item item) {
    Nav.push(
        context,
        EditItemPage(
          item: item,
          listKey: listKey,
        ));
  }

  // void dismiss(DismissDirection d, Item item) {
  //   if (d == DismissDirection.startToEnd) {
  //     databaseService.removeItem(item.id);
  //   } else if (d == DismissDirection.endToStart) {
  //     edit(item);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groceries',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 24)),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            icon: Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
            onSelected: (value) {
              if (value == 1) {
                DatabaseService().deleteCheckedItems();
              } else if (value == 2) {
                DatabaseService().deleteAllItems();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Clear checked items', style: TextStyle()),
                value: 1,
              ),
              PopupMenuItem(
                child: Text('Clear all items', style: TextStyle()),
                value: 2,
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<List<Item>>(
          stream: databaseService.groceryListStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length != 0) {
                List<Item> list = snapshot.data;
                return FutureBuilder<List<Tag>>(
                    future: databaseService.getTags(),
                    builder: (context, future) {
                      if (future.hasData) {
                        updateColors(list, future.data);
                        return ListView.builder(
                          key: listKey,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            Item item = list[index];
                            return InkWell(
                              onLongPress: () => edit(item),
                              child: Dismissible(
                                key: Key(item.id),
                                onDismissed: (d) =>
                                    databaseService.removeItem(item.id),
                                child: ItemCard(item),
                              ),
                            );
                          },
                        );
                      }
                      return SpinKitCircle(
                        color: Colors.black,
                      );
                    });
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No items yet',
                          style: TextStyle(fontSize: 18, color: Colors.grey)),
                      SizedBox(height: 5),
                      Text('Try adding one',
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                );
              }
            } else {
              print('no Data...');
              return SpinKitCircle(
                color: Colors.black,
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddItemPage(
                        listKey: listKey,
                      )));
          print('he');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
