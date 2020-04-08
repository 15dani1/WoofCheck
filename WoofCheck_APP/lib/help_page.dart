import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';


class MyFAQPage extends StatefulWidget {
  MyFAQPage(this.title);

  final String title;

  @override
  IntroScreenState createState() => new IntroScreenState();
}

class IntroScreenState extends State<MyFAQPage> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "Select",
        description: "Click 'Gallery' to select an image from your gallery or 'Camera' to take a new image.",
        pathImage: "assets/home.jpeg",
        heightImage: 350.0,
        backgroundColor: Colors.orange,
      ),
    );
    slides.add(
      new Slide(
        title: "Edit",
        description: "Use the zoom and rotate tools to edit your image. Ensure your dog is centered in the image.",
        pathImage: "assets/cropping.jpg",
        heightImage: 350.0,
        backgroundColor: Colors.blue,
      ),
    );
    slides.add(
      new Slide(
        title: "Result",
        description:
        "View your results! If you would like a better reading, click 'Retake Image' and submit another picture of your dog.",
        pathImage: "assets/result.jpg",
        heightImage: 350.0,
        backgroundColor: Colors.orange,
      ),
    );
    slides.add(
      new Slide(
        title: "Again",
        description: "If you would like to try the app on a new dog, select 'New Image'.",
        pathImage: "assets/retake.jpg",
        heightImage: 350.0,
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      renderDoneBtn: Text(""), // since isShowDoneBtn: false doesn't work, just hide it with empty text
      isShowPrevBtn: true,
      isShowSkipBtn: false,
    );
  }
}

/*
1. Click 'Photo Gallery' to select an image from your gallery or 'Camera' to take a new image.
2. Use the zoom and rotate tools to edit your image. Ensure your dog is centered in the image.
3. View your results! If you would like a better reading, click "Retake Image" and submit another picture of your dog.
4. If you would like to try the app on a new dog, select "New Image".
*/
