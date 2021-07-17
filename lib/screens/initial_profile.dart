import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:spoty/screens/map_screen.dart';

class InitialProfile extends StatelessWidget {
  static const routeName = '/InitialProfile';

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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Personalize Your Profile", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 26),),
                const SizedBox(height: 6,),
                const Text("A little bit about yourself", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),),
                const SizedBox(height: 10,),
            // image with edit button
            Container(
              child: GestureDetector(
                onTap: (){
                  print("clicked");
                },
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        color: Colors.white,
                        borderRadius:BorderRadius.circular(100)
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
              height: 96,
              width: 96,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: const DecorationImage(
                    image: AssetImage(
                        'assets/images/intro_img1.png'
                    ),
                    fit: BoxFit.cover
                ),
              ),
            ),
                // form
                //First Name Field
                const SizedBox(height: 32,),
                const Text("First Name", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),),
                const SizedBox(height: 8,),
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius:  const BorderRadius.all(Radius.circular(5)),
                    color: Colors.grey.shade200,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Ex: Jonathan",
                        labelStyle: TextStyle(fontSize: 18),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(height: 14,),
                //Last Name Field
                const Text("Last Name", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),),
                const SizedBox(height: 8,),
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius:  const BorderRadius.all(Radius.circular(5)),
                    color: Colors.grey.shade200,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Ex: Campbell",
                        labelStyle: TextStyle(fontSize: 18),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                //Profile Code Field
                const SizedBox(height: 14,),
                const Text("Profile Code", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),),
                const SizedBox(height: 8,),
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius:  const BorderRadius.all(Radius.circular(5)),
                    color: Colors.grey.shade200,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Ex: KJH89823",
                        labelStyle: TextStyle(fontSize: 18),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),




                const SizedBox(height: 120,),
                Padding(
                  padding: const EdgeInsets.only(bottom: 35.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: RawMaterialButton(
                      onPressed: () {
                        Navigator.pushNamed(context, MapScreen.routeName);
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
                    ),
                  ),
                )
              ],
            ),
          ),
        ),

      ),
    );
  }
}
