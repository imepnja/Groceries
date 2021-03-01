import 'dart:ffi';

import 'package:Groceries/databse.dart';
import 'package:Groceries/models/item.dart';
import 'package:Groceries/models/tag.dart';
import 'package:Groceries/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../databse.dart';
import '../databse.dart';

class AddItemPage extends StatefulWidget {
  final GlobalKey<AnimatedListState> listKey;

  const AddItemPage({Key key, this.listKey}) : super(key: key);

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  GlobalKey<FormState> _formKey = GlobalKey();
  List<Tag> tagsList;

  List<Tag> selectedTags = [];
  String title = '';
  String description = '';

  DatabaseService databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
  }

  void addItem() {
    if (_formKey.currentState.validate()) {
      Nav.pop(context);
      // if(widget.listKey.currentState != null) {
      // widget.listKey.currentState.insertItem(0);
      // }
      databaseService.addItem(
          title: title, description: description ?? '', tags: selectedTags);
    }
  }

  void selectTag(Tag t) {
    setState(() => selectedTags.add(t));
  }

  void deselectTag(Tag t) {
    setState(() => selectedTags.removeWhere((e) => e.name == t.name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('Add Item', style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: Container(
            // height: double.infinity,
            // width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Container(color: Colors.cyanAccent, height: 100,),
                // Container(color: Colors.yellow),
                TextFormField(
                  autofocus: true,
                  validator: (val) => val.trim() == '' ? 'Add a Title' : null,
                  onChanged: (val) => setState(() => title = val),
                  onFieldSubmitted: (val) => addItem(),
                  decoration: InputDecoration(
                    hintText: 'Title',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            BorderSide(color: Colors.white, width: 2.0)),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  onChanged: (val) => setState(() => description = val),
                  decoration: InputDecoration(
                    hintText: 'Description (optional)',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            BorderSide(color: Colors.white, width: 2.0)),
                  ),
                ),
                SizedBox(height: 20),
                TagsList(
                    deselect: (t) => deselectTag(t),
                    select: (t) => selectTag(t),
                    selectedTags: selectedTags),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 5,
                            color: Colors.black12.withOpacity(0.04))
                      ],
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(25)),
                  width: double.infinity,
                  child: FlatButton(
                    child: Text('Add Item',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    onPressed: () => addItem(),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
