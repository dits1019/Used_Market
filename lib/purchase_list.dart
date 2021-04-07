import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:used_market_app_ex/list_item.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
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
          List<DocumentSnapshot> basket = List.empty(growable: true);
          for (var check in snapshot.data.documents) {
            if (check.data['ShoppingBasket'] == true) {
              basket.add(check);
            }
          }
          return _SalesList(basket);
        },
      ),
    );
  }
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
