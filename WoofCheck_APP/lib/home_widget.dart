import 'package:flutter/material.dart';
import 'placeholder_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class MyImagePicker extends StatefulWidget {
  @override
  MyImagePickerState createState() => MyImagePickerState();
}

class MyImagePickerState extends State {

  File imageURI;

  Future getImageFromCamera() async {

    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      imageURI = image;
    });
  }
  
  @override
  initState() {
    super.initState();
    getImageFromCamera();
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

class MyGalleryPicker extends StatefulWidget {
  @override
  MyGalleryPickerState createState() => MyGalleryPickerState();
}

class MyGalleryPickerState extends State {

  File imageURI;

  Future getImageFromGallery() async {

    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageURI = image;
    });
  }

  @override
  initState() {
    super.initState();
    getImageFromGallery();
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
    PlaceholderWidget(Colors.white),
    MyImagePicker(),
    MyGalleryPicker()
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