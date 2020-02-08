import 'package:flutter/material.dart';
import 'placeholder_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class MyImagePicker extends StatefulWidget {
  final String src;
  MyImagePicker(this.src);

  @override
  MyImagePickerState createState() => new MyImagePickerState();
}

class MyImagePickerState extends State<MyImagePicker> {

  File imageURI;

  Future getImageFromCamera(String src) async {
    var image;
    if (src == "camera"){
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else if (src == "gallery"){
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }

    setState(() {
      imageURI = image;
    });
  }
  
  @override
  initState() {
    super.initState();
    var src = widget.src;
    getImageFromCamera(src);
  }

  @override
  void didUpdateWidget(MyImagePicker oldWidget) {
    if (widget.src != oldWidget.src){
      getImageFromCamera(widget.src);
    }
    super.didUpdateWidget(oldWidget);
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[ 
        imageURI == null
          ? Text('No image selected.')
          : Image.file(imageURI, width: 300, height: 200, fit: BoxFit.cover),
    ]))
    );
  }
}

class Home extends StatefulWidget {
 @override
 State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currIndex = 0;
  final List<Widget> _children = [
    PlaceholderWidget(Colors.blue[100]),
    MyImagePicker("camera"),
    MyImagePicker("gallery")
  ];
 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text('WoofCheck'),
       centerTitle: true,
     ),
     body: _children[_currIndex],
     bottomNavigationBar: BottomNavigationBar(
       onTap: onButtonClick,
       currentIndex: _currIndex, // this will be set when a new tab is tapped
       items: [
         new BottomNavigationBarItem(
           icon: new Icon(Icons.home),
           title: new Text('Home'),
         ),
         new BottomNavigationBarItem(
           icon: new Icon(Icons.camera),
           title: new Text('Camera'),
         ),
         new BottomNavigationBarItem(
           icon: Icon(Icons.photo_album),
           title: Text('Photo Gallery')
         )
       ],
     ),
   );
 }
  void onButtonClick(int index){
    setState(() {
      _currIndex = index;
    });
  }
}