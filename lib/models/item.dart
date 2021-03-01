import 'package:Groceries/databse.dart';
import 'package:Groceries/models/tag.dart';
import 'package:Groceries/navigator.dart';
import 'package:Groceries/pages/edit_item_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Item {
  final String id;
  String title;
  String description;
  bool enabled;
  Timestamp editDate;
  List<Tag> tags;
  int currentPos;

  Item({
    this.title = '',
    this.description = '',
    this.enabled = true,
    this.id,
    this.currentPos,
    this.editDate,
    this.tags = const [],
  });
}

class ItemCard extends StatefulWidget {
  ItemCard(this.item, {Key key}) : super(key: key);
  final Item item;
  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Item item = widget.item;
    return InkWell(
      onTap: () => setState(() => DatabaseService().changeEnabled(item)),
      onLongPress: () => Nav.push(
          context,
          EditItemPage(
            item: item,
          )),
      child: Opacity(
        opacity: item.enabled ? 1 : 0.5,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          constraints: BoxConstraints(minHeight: 30),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    blurRadius: 10,
                    spreadRadius: 5,
                    color: Colors.black.withOpacity(0.05))
              ],
              color: Colors.white),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                // flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text(item.title,
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18)),
                    item.description != ''
                        ? Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(item.description,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 15)),
                          )
                        : SizedBox(height: 4),
                  ],
                ),
              ),
              Expanded(
                // flex: 1,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 0,
                  alignment: WrapAlignment.end,
                  children: item.tags
                      .map((t) => TagCard(
                            t,
                            selected: true,
                          ))
                      .toList()
                      .cast<Widget>(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
