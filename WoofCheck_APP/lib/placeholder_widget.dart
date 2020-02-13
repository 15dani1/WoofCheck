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
          createRecord('Gal Levy');
        },
        color: Colors.blue,
        splashColor: Colors.red,
								child: new Text('Click me!'),
      ),
      color: color,
    );
  }

  void createRecord(String title) async {
    await databaseReference.collection("books").document("1").setData({
      'title': title,
      'description': 'Gal Levy for President 2020'
    });

    DocumentReference ref = await databaseReference.collection("books").add({
      'title': 'Flutter in Action',
      'description': 'Complete Programming Guide to learn Flutter'
    });
    print(ref.documentID);
  }
}
