import 'package:flutter/material.dart';
import 'placeholder_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';
// import 'package:image/image.dart' as i;
import 'package:tflite/tflite.dart';

class MyImagePicker extends StatefulWidget {
  final ImageSource src;
  MyImagePicker(this.src);

  @override
  MyImagePickerState createState() => new MyImagePickerState();
}

class MyImagePickerState extends State<MyImagePicker> {
  String _recognitions = " "; // don't delete this space or dart gets angry
  File imageURI;

  Future getImageFromCamera(ImageSource src) async {
    var image = await ImagePicker.pickImage(source: src);
    predictImage(image); 
  }
  Future predictImage(File image) async {
    if (image == null) 
      return;
    await recognizeImage(image);

    setState(() {
      imageURI = image;
    });
  }

  @override
  initState() {
    super.initState();
    ImageSource src = widget.src;
    getImageFromCamera(src);
    loadModel();
  }

  Future loadModel() async {
    Tflite.close();
    try {
      await Tflite.loadModel(
            model: "./assets/converted_model.tflite",
            labels: "./assets/labels.txt",
          );
      // print(res);
    } on PlatformException {
       print('couldnt load model');
    }
  }

  Future recognizeImage(File image) async {
    // RESIZE IMAGE CODE BELOW (dont forget to uncomment the image.dart import above):
    // i.Image original = i.decodeImage(image.readAsBytesSync());
    // i.Image sized = i.copyResize(original,width:224,height:224); // warning: this will distort rectangular images
    // var recognitions = await Tflite.runModelOnImage( // apparently recognizeImageBinary() is slow on ios
    //   path: sized.toString(),
    var recognitions = await Tflite.runModelOnImage( // apparently recognizeImageBinary() is slow on ios
      path: image.path,
      numResults: 3,
      threshold: 0.20,
      imageMean: 0, //was 127.5
      imageStd: 255,//was 127.5
    );

    String res = "";
    for (var i = 0; i < recognitions.length; i++)
      res+="\n"+recognitions[i]['confidence'].toStringAsFixed(5)+"   "+recognitions[i]['label'];
    if (res.isEmpty){
      res = "\nidk what woof is this floof ¯\\_(ツ)_/¯";
    }
    setState(() {
      _recognitions = res;
    });
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
          ? Text("No image selected.")
          : Image.file(imageURI, width: 400, height: 400, fit: BoxFit.cover),
        Text(_recognitions),
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
    MyImagePicker(ImageSource.camera),
    MyImagePicker(ImageSource.gallery)
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
           title: Text('Photo Gallery'),
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