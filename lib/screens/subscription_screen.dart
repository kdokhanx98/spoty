import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SubscriptionScreen extends StatelessWidget {
  static const routeName = '/SubscriptionScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#EF4A51"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: Column(

            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        color: Colors.white,
                      ),

                      child: IconButton(
                        iconSize: 20,
                        color: Colors.redAccent,
                        onPressed: () {
                        Navigator.pop(context);
                      }, icon: const Icon(Icons.close),),
                    ),
                  ],
                ),
              ),

              const Center(
                child: Text("Unlock Everything",
                  style:
                  TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
                child: Text(
                  "Track your child, see his latest location and much more!",
                  textAlign: TextAlign.center, style:
                TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),),
              ),

              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                width: 150,
                height: 180,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 90,
                    decoration:  BoxDecoration(
                      color: HexColor("#EBEBEB"),
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25)),
                    ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child:
                        Text("1\nYEAR", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.grey),)
                        ),
                      ),
                    ),
                    const Spacer(),
                     Container(
                      height: 90,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
                      ),
                      child:  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                             const Text("\$99.99", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                             const Padding(
                               padding: EdgeInsets.only(top: 4.0),
                               child:  Text("per year", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey),),
                             ),

                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 64),
                child: Text(
                  "Includes 3-days free trial, Cancel anytime.",
                  textAlign: TextAlign.center, style:
                TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),),
              ),

               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                 child: GestureDetector(
                   onTap: (){
                     print("continue clicked");
                   },
                   child: Container(
                     height: 60,
                     width: double.infinity,
                     decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                       color: Colors.white,
                     ),
                    child: const Center(
                      child:  Text(
                        "Continue",
                        style: TextStyle(color: Colors.red, fontSize: 24, fontWeight: FontWeight.w500),
                      ),
                    ),
              ),
                 ),
               ),

              const Spacer(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 32),
                child: Text(
                  "By continuing, you agree to our\nTerms of Service and Privacy Policy",
                  textAlign: TextAlign.center, style:
                TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
