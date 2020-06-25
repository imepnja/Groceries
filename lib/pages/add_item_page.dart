import 'package:Groceries/databse.dart';
import 'package:Groceries/models/item.dart';
import 'package:Groceries/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AddItemPage extends StatefulWidget {
  final GlobalKey<AnimatedListState> listKey;

  const AddItemPage({Key key, this.listKey}) : super(key: key);

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  GlobalKey<FormState> _formKey = GlobalKey();
  String title = '';
  String description = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Add Item', style: TextStyle()),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: Container(
            height: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Container(color: Colors.cyanAccent, height: 100,),
                  // Container(color: Colors.yellow),
                  TextFormField(
                    autofocus: true,
                    validator: (val) => val.trim() == '' ? 'Add a Title' : null,
                    onChanged: (val) => setState(() => title = val),
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
                    onChanged: (val) => setState(() => description = val),
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
                      child: Text('Add Item',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      onPressed: () {
                        if(_formKey.currentState.validate()) {
                          Nav.pop(context);
                          // if(widget.listKey.currentState != null) {
                          // widget.listKey.currentState.insertItem(0);
                          // }
                          DatabaseService().addItem(title: title, description: description ?? '');
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}