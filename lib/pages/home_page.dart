import 'package:Groceries/navigator.dart';
import 'package:Groceries/pages/add_item_page.dart';
import 'package:Groceries/databse.dart';
import 'package:Groceries/models/item.dart';
import 'package:Groceries/pages/edit_item_page.dart';
import 'package:animated_stream_list/animated_stream_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<AnimatedListState> listKey = new GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groceries', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            color: Colors.white,
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
            onSelected: (value) {
              if(value == 1) {
                DatabaseService().deleteCheckedItems();
              } else if(value == 2) {
                DatabaseService().deleteAllItems();
              } 
            },
            // onSelected: ,
          ),
        ],
      ),
      // body: AnimatedStreamList<Item>(
//
      // streamList: DatabaseService().groceryListStream,
      // itemBuilder: (Item item, index, context, animation) {
      // print(animation);
      // print('hey');
      // return FadeTransition(
      // opacity: animation,
      // child: item,
      // );
      // },
      // itemRemovedBuilder: (Item item, index, context, animation) {
      // return FadeTransition(
      // opacity: animation,
      // child: item,
      // );
      // },
      // ),

      body: StreamBuilder<List<Item>>(
          stream: DatabaseService().groceryListStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
            // if (snapshot.data.length != 0) {
              List<Item> list = snapshot.data;
              int enabledCount =
                  list.where((element) => element.enabled).length;
              print(enabledCount);
              return ListView.builder(
                key: listKey,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  list[index].currentPos = index;
                  print(list[index].currentPos);
                  return Opacity(
                    opacity: list[index].enabled ? 1 : 0.5,
                                        child: InkWell(
                        onTap: () => setState(() {
                              DatabaseService()
                                  .changeEnabled(list[index], enabledCount);
                            }),
                        onLongPress: () => Nav.push(
                            context,
                            EditItemPage(
                              item: list[index],
                              listKey: listKey,
                            )),
                        child: list[index]),
                  );
                },
              );
            // } else {
            //   return Center(
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Text('No items yet', style: TextStyle()),
            //         Text('Try adding one', style: TextStyle()),
            //       ],
            //     ),
            //   );
            // }

            // return ListView.builder(
            //   itemCount: list.length,
            //   itemBuilder: (context, index) {
            //     return list[index].enabled ? list[index] : list[index];
            //   },
            // );
            } else {
              print('no Data...');
              return SpinKitSpinningCircle(
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
