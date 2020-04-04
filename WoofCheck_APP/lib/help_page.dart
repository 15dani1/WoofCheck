import 'package:flutter/material.dart';
import 'package:snaplist/snaplist.dart';

class HelpPageWidget extends StatelessWidget {
 final Color color;

 HelpPageWidget(this.color);

 @override
 Widget build(BuildContext context) {
   return Scaffold(
      body: SingleChildScrollView(
      child: Center(
        child: Container(
          color: Colors.white12,
          padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'FAQ Page',
                  style: TextStyle(fontSize: 33, color: Colors.orange),
                ),
              ],
            ),
          ),
        ),
      ),
    );
 }
}

// @override
//  Widget build(BuildContext context) {
   
//     return SnapList(
//       sizeProvider: (index, data) => Size(100.0, 100.0),
//       separatorProvider: (index, data) => Size(10.0, 10.0),
//       builder: (context, index, data) => SizedBox(),
//       count: 3
//     );
//   }
// }