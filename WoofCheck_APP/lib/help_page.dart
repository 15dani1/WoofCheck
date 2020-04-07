import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'placeholder_widget.dart';


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
        title: "CAMERA",
        description: "Click 'Gallery' to select an image from your gallery or 'Camera' to take a new image.",
        pathImage: "images/photo_eraser.png",
        backgroundColor: Color(0xfff5a623),
      ),
    );
    slides.add(
      new Slide(
        title: "ZOOM",
        description: "Use the zoom and rotate tools to edit your image. Ensure your dog is centered in the image.",
        pathImage: "assets/cropping.jpg",
        backgroundColor: Color(0xff203152),
      ),
    );
    slides.add(
      new Slide(
        title: "RESULTS",
        description:
        "View your results! If you would like a better reading, click 'Retake Image' and submit another picture of your dog.",
        pathImage: "images/photo_ruler.png",
        backgroundColor: Color(0xff9932CC),
      ),
    );
    slides.add(
      new Slide(
        title: "NEW IMAGE",
        description: "If you would like to try the app on a new dog, select 'New Image'.",
        pathImage: "images/photo_pencil.png",
        backgroundColor: Color(0xff008000),
      ),
    );
  }

  void onDonePress() {
    HomeWidget(Colors.blue);
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
    );
  }
}

/*
1. Click 'Photo Gallery' to select an image from your gallery or 'Camera' to take a new image.
2. Use the zoom and rotate tools to edit your image. Ensure your dog is centered in the image.
3. View your results! If you would like a better reading, click "Retake Image" and submit another picture of your dog.
4. If you would like to try the app on a new dog, select "New Image".
*/
