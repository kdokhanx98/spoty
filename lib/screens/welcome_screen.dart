import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:spoty/screens/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {

  List<PageViewModel> listPagesViewModel = [
    PageViewModel(
    title: "Lorem Ipsum is simply",
    body: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
    image: Center(
      child: Image.asset("assets/images/intro_img1.png", height: 175.0),
    ),
  ),
    PageViewModel(
    title: "Real Time Alerts",
    body: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
    image: Center(
      child: Image.asset("assets/images/intro_img2.png", height: 175.0),
    ),
  ),
    PageViewModel(
    title: "Connect and be Together",
    body: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
    image: Center(
      child: Image.asset("assets/images/intro_img3.png", height: 175.0),
    ),
  ),
  ];
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: listPagesViewModel,
      onDone: () {
        // When done button is press
        Navigator.pushNamed(context, SignUp.routeName);
      },
      onSkip: () {
        Navigator.pushNamed(context, SignUp.routeName);
      },
      showSkipButton: true,
      skip: const Icon(Icons.skip_next),
      next: const Icon(Icons.forward),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Colors.teal,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0)
          )
      ),
    );
  }
}
