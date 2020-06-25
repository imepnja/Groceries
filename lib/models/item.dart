import 'package:Groceries/databse.dart';
import 'package:Groceries/navigator.dart';
import 'package:Groceries/pages/edit_item_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Item extends StatefulWidget {
  final String title;
  final String description;
  final bool enabled;
  final String id;
  final Timestamp editDate;
  int currentPos;

   Item(
      {Key key,
      this.title = '',
      this.description = '',
      this.enabled = true,
      this.id,
      this.currentPos, this.editDate})
      : super(key: key);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  @override
  Widget build(BuildContext context) {
    String title = widget.title;
    String description = widget.description;
    bool enabled = widget.enabled;
    return 
    // InkWell(
    //   onTap: () => setState(() => DatabaseService().changeEnabled(widget)),
    //   onLongPress: () => Nav.push(
    //       context,
    //       EditItemPage(
    //         item: widget,
    //       )),
    //   child: Opacity(
    //     opacity: 1,
    //     child: 
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          margin: EdgeInsets.all(10),
          constraints: BoxConstraints(minHeight: 30),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                    blurRadius: 10, spreadRadius: 5, color: Colors.black12)
              ],
              color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
              description != ''
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(description,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15)),
                    )
                  : SizedBox(),
            ],
          ),
      //   ),
      // ),
    );
  }
}
