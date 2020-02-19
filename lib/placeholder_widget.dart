import 'package:flutter/material.dart';

class PlaceholderWidget extends StatelessWidget {
 final Color color;

 PlaceholderWidget(this.color);

 @override
 Widget build(BuildContext context) {
   return Container(
      color: color,
      child: Container(
        alignment: AlignmentDirectional(0.0, 0.0),
        child:Text("Woof Woof"))
   );
 }
}