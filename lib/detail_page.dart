import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();

  final DocumentSnapshot document;

  DetailPage(this.document);
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '상세보기',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Hero(
              tag: widget.document.documentID,
              child: Container(
                width: double.infinity,
                height: 260,
                child: Image.network(widget.document['ProductsImg']),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 14, bottom: 5),
              child: Text(
                '${widget.document['ProductName']}',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14, bottom: 14),
              child: Text(
                '작성자 : ${widget.document['Nickname']}',
                style: TextStyle(fontSize: 20, color: Colors.grey[800]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 14, bottom: 30),
              child: Text(
                '물품 설명\n${widget.document['content']}',
                style: TextStyle(fontSize: 20),
              ),
            ),
            widget.document['ShoppingBasket'] == true
                ? Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _canel();
                          Future.delayed(Duration(seconds: 1),
                              () => {Navigator.pop(context)});
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0xffd3e0dc),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0))),
                        width: 150,
                        height: 60,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.cancel_presentation),
                              Text(
                                'Cancel',
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _buy();
                          Future.delayed(Duration(seconds: 1),
                              () => {Navigator.pop(context)});
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: const Color(0xffaee1e1),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0))),
                        width: 150,
                        height: 60,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(Icons.shopping_cart),
                              Text(
                                'Buy',
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  void _buy() {
    final updateData = {'ShoppingBasket': true};

    Firestore.instance
        .collection('post')
        .document(widget.document.documentID)
        .updateData(updateData);

    FlutterDialog('구매 완료');
  }

  void _canel() {
    final updateData = {'ShoppingBasket': false};

    Firestore.instance
        .collection('post')
        .document(widget.document.documentID)
        .updateData(updateData);

    FlutterDialog('구매 취소 완료');
  }

  void FlutterDialog(String title) {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: true,
        builder: (BuildContext context) {
          //2초 후 자동 종료
          Future.delayed(Duration(seconds: 1), () {
            Navigator.pop(context);
          });

          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                new Text(title),
              ],
            ),
          );
        });
  }
}
