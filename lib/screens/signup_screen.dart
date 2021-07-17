import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:spoty/screens/getcode_screen.dart';


class SignUp extends StatelessWidget {
  static const routeName = '/SignUp';
  String mobileNo = "+970595166453";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: HexColor("#006D72"), //change your color here
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               const Text("Enter Phone Number", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 26),),

              const Padding(
                padding: EdgeInsets.only(top: 24),
                child: Text("Phone Number", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
              ),

              const SizedBox(height: 10,),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 10,),
                       child: Image.asset("assets/images/flag.png", width: 32, height: 32,),
                     ),
                      const SizedBox(width: 5,),
                      Expanded(
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius:  const BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
                            color: Colors.grey.shade200,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Ex: +1 416 555 0134",
                                labelStyle: TextStyle(fontSize: 24),
                                hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                              ),
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("By registering you agree to the\nTerms and Conditions of Spoty"),

                    RawMaterialButton(
                      onPressed: () {
                        Navigator.pushNamed(context, GetCode.routeName);
                      },
                      elevation: 2.0,
                      fillColor: HexColor("#006D72"),
                      child: const Icon(
                        Icons.forward,
                        size: 35.0,
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(15.0),
                      shape: const CircleBorder(),
                    )
                  ],
                ),
              )


            ],
          ),
        ),
      ),
    );
  }
}
