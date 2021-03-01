import 'package:Groceries/databse.dart';
import 'package:Groceries/models/item.dart';
import 'package:Groceries/models/tag.dart';
import 'package:Groceries/navigator.dart';
import 'package:Groceries/pages/add_item_page.dart';
import 'package:flutter/material.dart';

class EditItemPage extends StatefulWidget {
  final Item item;
  final GlobalKey<AnimatedListState> listKey;

  const EditItemPage({Key key, this.item, this.listKey}) : super(key: key);
  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  GlobalKey<FormState> _formKey = GlobalKey();

  Item item;

  DatabaseService databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    item = widget.item;
  }

  void selectTag(Tag t) {
    setState(() => item.tags.add(t));
  }

  void deselectTag(Tag t) {
    setState(() => item.tags.removeWhere((e) => e.name == t.name));
  }

  void submitEditItem() {
    DatabaseService().editItem(item: item);
    Nav.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Item', style: TextStyle()),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: Container(
            height: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Container(color: Colors.cyanAccent, height: 100,),
                // Container(color: Colors.yellow),
                TextFormField(
                  initialValue: item.title,
                  autofocus: true,
                  validator: (val) => val.trim() == '' ? 'Add a Title' : null,
                  onChanged: (val) => setState(() => item.title = val),
                  decoration: InputDecoration(
                    hintText: 'Title',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide:
                            BorderSide(color: Colors.white, width: 2.0)),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  initialValue: item.description,
                  onChanged: (val) => setState(() => item.description = val),
                  decoration: InputDecoration(
                    hintText: 'Description (optional)',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide:
                            BorderSide(color: Colors.white, width: 2.0)),
                  ),
                ),
                SizedBox(height: 20),
                TagsList(
                  selectedTags: item.tags,
                  select: (t) => selectTag(t),
                  deselect: (t) => deselectTag(t),
                ),

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
                    child: Text('Save',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    onPressed: () => submitEditItem(),
                  ),
                ),

                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 5,
                            color: Colors.black12.withOpacity(0.04))
                      ],
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(25)),
                  width: double.infinity,
                  child: FlatButton(
                    child: Text('Delete Item',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    onPressed: () {
                      // if(widget.listKey.currentState != null){
                      // widget.listKey.currentState.removeItem(widget.item.currentPos, (context, animation) => SizedBox());
                      // }

                      DatabaseService().removeItem(widget.item.id);
                      Nav.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
