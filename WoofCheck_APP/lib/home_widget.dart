import 'package:animal_see/help_page.dart';
import 'package:flutter/material.dart';
import 'placeholder_widget.dart';
import 'help_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';
// import 'package:image/image.dart' as i;
import 'package:image_cropper/image_cropper.dart';
import 'package:tflite/tflite.dart';
import 'package:sortedmap/sortedmap.dart';

var map = new SortedMap(Ordering.byValue());

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
    predictImage(image, false); 

  }
  Future<File> cropped(File image) async {
      return ImageCropper.cropImage(
      sourcePath: image.path,
      maxWidth: 224,
      maxHeight: 224,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0)
    );
  }
  Future predictImage(File image, bool useMap) async {
    if (image == null) 
      return;
    //returns cropped image after classifying with cropped
    image = await cropped(image);
    await recognizeImage(image, useMap); 

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
            model: "assets/breed_classifier.tflite",
            labels: "assets/labels.txt",
          );
    } on PlatformException {
      print('couldnt load model');
    }
  }

  Future recognizeImage(File image, bool useMap) async {
    var recognitions = await Tflite.runModelOnImage( // apparently recognizeImageBinary() is slow on ios
      path: image.path,
      numResults: 120,
      threshold: 0.0,
      imageMean: 0, //was 127.5
      imageStd: 255,//was 127.5R
    );

    // update map
    for (int i = 0; i < recognitions.length; i++){
      if (useMap){
        // print('HERE '+recognitions[i]['confidence'].toString()+' '+ map[recognitions[i]['label']].toString());
        // print("A: "+ map[recognitions[i]['label']].toString());
        // print("B: "+ recognitions[i]['confidence'].toString());
        map.addAll({
          recognitions[i]['label'] : (map[recognitions[i]['label']] + recognitions[i]['confidence'])/2
        });
        // print("AFTER AVG: "+map[recognitions[i]['label']].toString());
      }else{
        // print("BEFORE AVG: "+map[recognitions[i]['label']].toString());
        map.addAll({
          recognitions[i]['label'] : recognitions[i]['confidence']
        });
        // print("AFTER AVG: "+map[recognitions[i]['label']].toString());
      }
    }

    // build res
    String res = "";
    List bestResult = map.keys.toList().reversed.toList();

    for (int i = 0; i < 3; i++){
      if (map[bestResult[i]] < 0.47){
        break;
      }
      res+="\n"+bestResult[i]+"   "+(map[bestResult[i]]*100).toStringAsFixed(2)+"%";
      if (map[bestResult[i]] > 0.80){
        break;
      }
    }

    if (res.isEmpty){
      res = "\nThis does not appear to be a dog!";
    }
    // print(res);//delete later
    // print(bestResult);
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
        Column(
        children : <Widget>[
        Image.file(imageURI, width: 300, height: 300, fit: BoxFit.cover),
          Text(
            _recognitions,
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(
              width : 120.0,
              height : 40.0,
              child : new RaisedButton(
              child: Text("Retake Image"),
              onPressed: () async {    
              var image = await ImagePicker.pickImage(source: widget.src);
              predictImage(image, true); 
              },
              color: Colors.blue,
              textColor: Colors.white,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              splashColor: Colors.grey,
              )
          ),
          Padding(
            padding : const EdgeInsets.all(10.0),
          ),
          SizedBox(
            width : 120.0,
            height : 40.0,
            child : new RaisedButton(
            child: Text("New Image"),
            onPressed: () async {    
            var image = await ImagePicker.pickImage(source: widget.src);
            predictImage(image, false); 
            },
            color: Colors.orange,
            textColor: Colors.white,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            splashColor: Colors.grey,
          ),
          )
        ],
      )];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _output()
        )
      )
    )
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
    HomeWidget(Colors.blue),
    MyImagePicker(ImageSource.camera),
    MyImagePicker(ImageSource.gallery),  //MyImagePickerState(Colors.black)
    MyFAQPage("FAQ"),
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
       currentIndex: _currIndex,
       type: BottomNavigationBarType.fixed, // this will be set when a new tab is tapped
       items: [
         new BottomNavigationBarItem(
           icon: new Icon(Icons.home),
           title: new Text('Home'),
           backgroundColor: Colors.blue,
         ),
         new BottomNavigationBarItem(
           icon: new Icon(Icons.camera),
           title: new Text('Camera'),
           backgroundColor: Colors.blue,
         ),
         new BottomNavigationBarItem(
           icon: new Icon(Icons.photo_album),
           title: new Text('Gallery'),
           backgroundColor: Colors.blue,
         ),
         new BottomNavigationBarItem(
           icon: new Icon(Icons.help),
           title: new Text('FAQ'),
           backgroundColor: Colors.blue,
         ),
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
