// @dart=2.9
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:spoty/providers/purchase_provider.dart';
import 'package:spoty/screens/initial_profile.dart';
import 'package:spoty/screens/map_screen.dart';
import 'package:spoty/screens/share_code_screen.dart';
import 'package:spoty/screens/signup_screen.dart';
import 'package:spoty/screens/subscription_screen.dart';
import 'package:spoty/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    if (defaultTargetPlatform == TargetPlatform.android) {
      InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
    }
    runApp(ChangeNotifierProvider(
        create: (context) => PurchaseProvider(),
        child: MyApp()));


  }

  class MyApp extends StatefulWidget {
    @override
    State<MyApp> createState() => _MyAppState();
  }



  class _MyAppState extends State<MyApp> {


    @override
    void dispose() {
      var provider = Provider.of<PurchaseProvider>(context, listen: false);
      provider.purchaseUpdated.listen((event) {}).cancel();
      super.dispose();
    }

    @override
    void initState() {
      var provider = Provider.of<PurchaseProvider>(context, listen: false);
      provider.initialize();
      super.initState();

    }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(
          seconds: 3,
          navigateAfterSeconds: /*AuthService().handleAuth(),*/
             FutureBuilder(
           builder: (context, snapshot) =>
           snapshot.connectionState == ConnectionState.waiting
               ? Container()
              : snapshot.data,
           future: checkFirstScreen(),
           ),
          loadingText: const Text(
            "All Copyright Sopty\n2020 Researved",
            textAlign: TextAlign.center,
          ),
          image: Image.asset(
            "assets/images/ic_logo.png",
            alignment: Alignment.bottomCenter,
          ),
          backgroundColor: Colors.white,
          styleTextUnderTheLoader: const TextStyle(),
          photoSize: 100.0,
          loaderColor: Colors.teal),
      routes: {
        SignUp.routeName: (context) => SignUp(),
        InitialProfile.routeName: (context) => InitialProfile(),
        MapScreen.routeName: (context) => MapScreen(),
        SubScreen.routeName: (context) => SubScreen(),
        ShareCode.routeName: (context) => ShareCode(),
      },
    );
  }

  Future checkFirstScreen() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);


    if (_seen) {
      return MapScreen();
    } else {
      prefs.setBool('seen', true);
      return WelcomeScreen();
    }
  }
}
