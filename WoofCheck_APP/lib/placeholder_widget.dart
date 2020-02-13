import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceholderWidget extends StatelessWidget {
  final Color color;
  final databaseReference = Firestore.instance;
  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        onPressed: () {
          createRecord('JOhn Cena');
        },
        color: Colors.blue,
        splashColor: Colors.red,
      ),
      color: color,
    );
  }

  void createRecord(String yeet) async {
    await databaseReference.collection("books").document("1").setData({
      'title': yeet,
      'description': 'Programming Guide for Dart'
    });

    DocumentReference ref = await databaseReference.collection("books").add({
      'title': 'Flutter in Action',
      'description': 'Complete Programming Guide to learn Flutter'
    });
    print(ref.documentID);
  }
}
