import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  File _image;
  final picker = ImagePicker();

  final TextEditingController editName = TextEditingController();
  final TextEditingController editProduct = TextEditingController();
  final TextEditingController editContent = TextEditingController();

  @override
  void dispose() {
    editName.dispose();
    editProduct.dispose();
    editContent.dispose();
    super.dispose();
  }

  Future getImage() async {
    final image = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = File(image.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future _uploadFile(BuildContext context) async {
    //스토리지에 업로드할 파일 경로
    final firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('post')
        .child('${DateTime.now().millisecondsSinceEpoch}.png');

    // 파일 업로드
    final task = firebaseStorageRef.putFile(
        _image,
        //설정해주지 않으면 image로 인식 하지 않을 수도 있음
        StorageMetadata(contentType: 'image/png'));

    final storageTaskSnapshot = await task.onComplete;

    final downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

    await Firestore.instance.collection('post').add({
      'Nickname': editName.text,
      'ProductName': editProduct.text,
      'ProductsImg': downloadUrl,
      'ShoppingBasket': false,
      'content': editContent.text,
      'timeStamp': Timestamp.now()
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
            child: _image == null
                ? InkWell(
                    onTap: getImage,
                    child: Container(
                      color: const Color(0xffece2e1),
                      width: double.infinity,
                      height: 300,
                      child: Center(
                        child: Text('이미지 선택'),
                      ),
                    ),
                  )
                : InkWell(
                    onTap: getImage,
                    child: Image.file(
                      _image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 300,
                    ),
                  ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: editName,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: '작성자 이름(닉네임)'),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: editProduct,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: '물품 이름'),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            margin: EdgeInsets.all(12),
            height: 10 * 24.0,
            child: TextField(
              controller: editContent,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: "물품 설명",
                fillColor: const Color(0xffece2e1),
                filled: true,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if (_image == null ||
                  editName == null ||
                  editProduct == null ||
                  editContent == null) {
                FlutterDialog('입력하지 않은 부분이 있는지\n확인해주세요.');
              } else {
                _uploadFile(context);
                FlutterDialog('정상적으로 업로드되었습니다.');
              }
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
                    Icon(Icons.file_upload),
                    Text(
                      'Upload',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }

  void FlutterDialog(String content) {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                new Text("알림"),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    content,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
