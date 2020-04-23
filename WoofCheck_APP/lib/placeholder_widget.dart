import 'package:flutter/material.dart';

class HomeWidget extends StatelessWidget {
 final Color color;

 HomeWidget(this.color);

 @override
 Widget build(BuildContext context) {
   return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SingleChildScrollView(
      child: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(120.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  child: Image.asset(
                    "assets/dog.png",
                    fit: BoxFit.contain,
                  ),
                ),
                FittedBox(
                  fit: BoxFit.contain,
                  child: Text("WoofCheck", style: TextStyle(fontSize: 33, color: Colors.orange)),
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