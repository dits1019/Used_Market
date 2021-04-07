import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:used_market_app_ex/list_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('post')
            .orderBy('timeStamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return _loadingPage();
          }
          return _SalesList(snapshot.data.documents);
        },
      ),
    );
  }

  Widget _loadingPage() {
    return Center(
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '올라온 물건이 없습니다.',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 20,
          ),
          CircularProgressIndicator()
        ],
      )),
    );
  }

  Widget _SalesList(List<DocumentSnapshot> documents) {
    // final myPosts = documents.where((doc) => doc['Nickname']).take(10).toList();

    return ListView(children: documents.map((doc) => ListItem(doc)).toList());
  }
}
