import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steps/steps.dart';

class ShareCode extends StatefulWidget {
  static const routeName = '/ShareCode';
  @override
  _ShareCodeState createState() => _ShareCodeState();
}





class _ShareCodeState extends State<ShareCode> {
  String fatherCode = "";

  Future getFatherCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userCode = prefs.getString("userId") ?? "no code";

    if(userCode != "no code"){
      setState(() {
        fatherCode = userCode;
      });
    }
  }

  @override
  void initState() {
    getFatherCode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Track your child"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: Steps(
          direction: Axis.vertical,
          size: 20.0,
          path: {'color': HexColor("#009688"), 'width': 3.0},
          steps: [
            {
              'color': Colors.white,
              'background': HexColor("#006D72"),
              'label': '1',
              'content': Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  const Text(
                    "On your child's device",
                    style: TextStyle(fontSize: 22.0),
                  ),
                  RichText(
                    text:  const TextSpan(
                      style:  TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: 'Open Google Play and get the ', style: TextStyle(fontSize: 17)),
                        TextSpan(text: 'Spoty For Children ', style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                        TextSpan(text: 'app', style: TextStyle(fontSize: 17)),

                      ],
                    ),
                  ),

                  /*     const SizedBox(height: 20,),
                    const Placeholder(fallbackWidth: 150, fallbackHeight: 100,)*/
                ],
              ),
            },
            {
              'color': Colors.white,
              'background': HexColor("#006D72"),
              'label': '2',
              'content': Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "When prompted, enter this Father Link access code and child name to connect your devices:",
                    style: TextStyle(fontSize: 17.0),
                  ),
                  const SizedBox(height: 20,),
                  Text(fatherCode,
                    style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  )
                ],
              )
            },
          ],
        ),
      ),
    );
  }
}
