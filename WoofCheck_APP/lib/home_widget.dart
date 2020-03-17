import 'package:flutter/material.dart';
import 'placeholder_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';
// import 'package:image/image.dart' as i;
import 'package:image_cropper/image_cropper.dart';
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
    File image = await ImagePicker.pickImage(source: src);
    predictImage(image); 

  }
  Future<File> cropped(File image) async {
      return ImageCropper.cropImage(
      sourcePath: image.path,
      maxWidth: 224,
      maxHeight: 224,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0)
    );
  }
  Future predictImage(File image) async {
    if (image == null) 
      return;
    //returns cropped image after classifying with cropped
    image = await cropped(image);
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
            model: "assets/converted_model.tflite",
            labels: "assets/labels.txt",
          );
    } on PlatformException {
      print('couldnt load model');
    }
  }

  Future recognizeImage(File image) async {
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
    print(res);//delete later
    setState(() {
      _recognitions = res+"\n";
    });
  }

  @override
  void didUpdateWidget(MyImagePicker oldWidget) {
    if (widget.src != oldWidget.src){
      getImageFromCamera(widget.src);
    }
    super.didUpdateWidget(oldWidget);
 }

  List<Widget> _output(){
    if (imageURI == null){
      return <Widget>[Text("No image selected.")];
    } else {
      return <Widget>[
        Image.file(imageURI, width: 224, height: 224, fit: BoxFit.cover),
        Text(_recognitions),
        RaisedButton(
          child: Text("Again?"),
          onPressed: () async {    
            var image = await ImagePicker.pickImage(source: widget.src);
            predictImage(image); 
            },
          color: Colors.blue,
          textColor: Colors.white,
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          splashColor: Colors.grey,
        )
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _output()
    ))
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
