import 'package:Groceries/constants.dart';
import 'package:Groceries/databse.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Tag {
  Color color;
  final String name;

  Tag({this.color, this.name});

  Tag get empty => Tag(color: Colors.blueGrey, name: '');

  factory Tag.fromDocumentSnapshot(DocumentSnapshot ds) {
    return Tag(name: ds.documentID, color: Color(int.parse(ds.data['color'])));
  }
}

class TagCard extends StatefulWidget {
  TagCard(this.tag, {Key key, this.selected = false}) : super(key: key);

  final Tag tag;
  bool selected;

  @override
  _TagCardState createState() => _TagCardState();
}

class _TagCardState extends State<TagCard> {
  BoxConstraints constraints =
      BoxConstraints(maxHeight: 25, minHeight: 20, minWidth: 50);

  @override
  Widget build(BuildContext context) {
    Tag tag = widget.tag;

    return Chip(
      padding: EdgeInsets.all(2),
      visualDensity: VisualDensity.compact,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: tag.color)),
      label: Text(
        tag.name,
        style: TextStyle(fontSize: 12),
      ),
      backgroundColor: !widget.selected ? Colors.transparent : tag.color,
    );
  }
}

class AddTagCard extends StatefulWidget {
  AddTagCard({Key key}) : super(key: key);

  @override
  _AddTagCardState createState() => _AddTagCardState();
}

class _AddTagCardState extends State<AddTagCard> {
  bool addNew = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => addNew = true),
      child: Chip(
        // padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),

        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: MyColors.primary)),
        backgroundColor: Colors.transparent,
        // labelPadding: EdgeInsets.all(5),
        label: addNew
            ? ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 100, maxHeight: 20),
                child: TextFormField(
                  onFieldSubmitted: (newValue) {
                    setState(() {
                      addNew = false;
                      if (newValue != '')
                        DatabaseService().addTag(
                            Tag(name: newValue, color: MyColors.randomColor));
                    });
                  },
                  autofocus: true,
                  maxLines: 1,
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              )
            : Icon(
                Icons.add,
                size: 20,
                color: MyColors.primary,
              ),
      ),
    );
  }
}

class TagsList extends StatelessWidget {
  const TagsList(
      {Key key, this.selectedTags, this.deselect(Tag t), this.select(Tag t)})
      : super(key: key);

  final List<Tag> selectedTags;
  final Function deselect;
  final Function select;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: StreamBuilder<List<Tag>>(
        stream: DatabaseService().tagStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var list = snapshot.data;

            return ListView.builder(
              itemCount: list.length + 1,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index == list.length) return AddTagCard();
                var tag = list[index];

                var selected = selectedTags
                    .where((element) => element.name == tag.name)
                    .isNotEmpty;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () => selected ? deselect(tag) : select(tag),
                    child: TagCard(
                      tag,
                      selected: selected,
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
                child:
                    Text('Loading...', style: TextStyle(color: Colors.grey)));
          }
        },
      ),
    );
  }
}
