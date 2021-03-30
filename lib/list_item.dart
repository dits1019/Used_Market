import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:used_market_app_ex/detail_page.dart';

class ListItem extends StatefulWidget {
  @override
  _ListItemState createState() => _ListItemState();

  final DocumentSnapshot document;

  ListItem(this.document);
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.document.documentID,
      child: Material(
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (content) => DetailPage(widget.document)));
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: ListTile(
              leading: Image.network(
                widget.document['ProductsImg'],
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
              title: Text(
                widget.document['ProductName'],
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '작성자 : ${widget.document['Nickname']}',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
