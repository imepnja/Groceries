import 'package:Groceries/databse.dart';
import 'package:Groceries/models/item.dart';
import 'package:Groceries/navigator.dart';
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
  bool edited = false;
  String title = '';
  String description = '';

  @override
  Widget build(BuildContext context) {
    if (!edited) {
      title = widget.item.title;
      description = widget.item.description;
    }
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
                  initialValue: title,
                  autofocus: true,
                  validator: (val) => val.trim() == '' ? 'Add a Title' : null,
                  onChanged: (val) => setState(() {
                    edited = true;
                    title = val;
                  }),
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
                  initialValue: description,
                  onChanged: (val) => setState(() {
                    edited = true;
                    description = val;
                  }),
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
                    onPressed: () {
            DatabaseService().editItem(
            title: title,
            description: description,
            id: widget.item.id);
            Nav.pop(context);
                    },
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
