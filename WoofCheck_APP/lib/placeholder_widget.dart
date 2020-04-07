import 'package:flutter/material.dart';

class HomeWidget extends StatelessWidget {
 final Color color;

 HomeWidget(this.color);

 @override
 Widget build(BuildContext context) {
   return Scaffold(
      body: SingleChildScrollView(
      child: Center(
        child: Container(
          color: Colors.blue[50],
          child: Padding(
            padding: const EdgeInsets.all(120.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 450.0,
                  child: Image.asset(
                    "assets/dog.png",
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  'WoofCheck',
                  style: TextStyle(fontSize: 33, color: Colors.orange),
                ),
              ],
            ),
          ),
        ),
      ),
        )
    );
 }
}