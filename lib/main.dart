// @dart=2.9
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:spoty/screens/getcode_screen.dart';
import 'package:spoty/screens/initial_profile.dart';
import 'package:spoty/screens/map_screen.dart';
import 'package:spoty/screens/signup_screen.dart';
import 'package:spoty/screens/subscription_screen.dart';
import 'package:spoty/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spoty/services/authservice.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (defaultTargetPlatform == TargetPlatform.android) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(
          seconds: 3,
          navigateAfterSeconds: AuthService().handleAuth(),

          //    FutureBuilder(
          //  builder: (context, snapshot) =>
          //  snapshot.connectionState == ConnectionState.waiting
          //      ? Container()
          //     : snapshot.data,
          //  future: checkFirstScreen(),
          //  ),
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
        GetCode.routeName: (context) => GetCode(),
        InitialProfile.routeName: (context) => InitialProfile(),
        MapScreen.routeName: (context) => MapScreen(),
        SubscriptionScreen.routeName: (context) => SubscriptionScreen(),
      },
    );
  }

  Future checkFirstScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      print("seen");
      return MapScreen();
    } else {
      // Set the flag to true at the end of onboarding screen if everything is successfull and so I am commenting it out
      print("not seens");
      prefs.setBool('seen', true);
      return WelcomeScreen();
    }
  }
}
