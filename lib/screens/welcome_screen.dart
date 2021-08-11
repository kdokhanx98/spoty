import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:location/location.dart';
import 'package:spoty/screens/signup_screen.dart';

import 'map_screen.dart';

class WelcomeScreen extends StatefulWidget {

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  List<PageViewModel> listPagesViewModel = [
    PageViewModel(
      title: "Keep Your Family Safe",
      body: "Easily track real-time location of the ones that you love and keep them safe.",
      image: Image.asset(
        "assets/images/intro_img1.png", height: 200.0, width: 350,),
      decoration: const PageDecoration(
        imagePadding: EdgeInsets.only(top: 40),
        titlePadding: EdgeInsets.only(top: 100),
        descriptionPadding: EdgeInsets.only(top: 10),
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
    PageViewModel(
      title: "Get Real-Time Alerts",
      body: "Set your safe locations and get real-time alerts every time someone leaves or enter the safe zone.",
      image: Image.asset(
        "assets/images/intro_img2.png", height: 200.0, width: 350,),
      decoration: const PageDecoration(
        imagePadding: EdgeInsets.only(top: 40),
        titlePadding: EdgeInsets.only(top: 100),
        descriptionPadding: EdgeInsets.only(top: 10),
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
    PageViewModel(
      title: "Stay Connected",
      body: "Get your family members sharing their location with each other and stay connected and safe.",
      image: Image.asset(
        "assets/images/intro_img3.png", height: 200.0, width: 350,),
      decoration: const PageDecoration(
        imagePadding: EdgeInsets.only(top: 40),
        titlePadding: EdgeInsets.only(top: 100),
        descriptionPadding: EdgeInsets.only(top: 10),
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: listPagesViewModel,
      onDone: () {
        checkPrmission().then((value) {
          if(value) {
            Navigator.pushReplacementNamed(context, MapScreen.routeName);
          }
        });
      },
      onSkip: () {
        checkPrmission().then((value) {
          if(value) {
            Navigator.pushReplacementNamed(context, MapScreen.routeName);
          }
        });
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


  Future<bool> checkPrmission() async {
    bool serviceEnabled;
    LocationPermission permission;
    Location location = Location();


    serviceEnabled = await location.serviceEnabled();
    permission = await Geolocator.checkPermission();

    print("enabled $serviceEnabled");
    print("permission ${permission.toString()}");


    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }
    else if (permission == LocationPermission.denied) {
      if (Platform.isAndroid) {
        var androidInfo = await DeviceInfoPlugin().androidInfo;
        var sdkInt = androidInfo.version.sdkInt;
        if (sdkInt >= 30) {
          Geolocator.openAppSettings();
          Fluttertoast.showToast(msg: "Please enable location permission",
              toastLength: Toast.LENGTH_LONG);
        } else {
          print("inside else");
          permission = await Geolocator.requestPermission();
        }
      }
    }
    else if (permission == LocationPermission.deniedForever) {
      if (Platform.isAndroid) {
        var androidInfo = await DeviceInfoPlugin().androidInfo;
        var sdkInt = androidInfo.version.sdkInt;
        if (sdkInt >= 30) {
          Geolocator.openAppSettings();
          Fluttertoast.showToast(msg: "Please enable location permission",
              toastLength: Toast.LENGTH_LONG);
        } else {
          permission = await Geolocator.requestPermission();
        }
      }
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    else {
      return true;
    }
    return false;
  }
}
