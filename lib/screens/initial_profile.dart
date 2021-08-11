import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialProfile extends StatefulWidget {
  static const routeName = '/InitialProfile';


  @override
  State<InitialProfile> createState() => _InitialProfileState();
}

class _InitialProfileState extends State<InitialProfile> {
  late File imageFile = File("assets/images/profile.png");
  bool hasFile = false;
  GlobalKey<FormState> formKey = GlobalKey();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                  pickImage();
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
                image: hasFile ? DecorationImage(
                    image: FileImage(imageFile),
                    fit: BoxFit.cover,
                ) : const DecorationImage(
                    image: AssetImage("assets/images/profile.png"),
                    fit: BoxFit.contain,
                ),
              ),
            ),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        controller: firstNameController,
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
                        controller: lastNameController,
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
                ],
              ),
            ),



                SizedBox(height: size.height * 0.15,),
                Padding(
                  padding: const EdgeInsets.only(bottom: 35.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: isLoading ? const Center(
                      child: CircularProgressIndicator(),
                    ) : RawMaterialButton(
                      onPressed: () {
                        getUserId().then((userId) {
                          storeUserData(userId).then((value) {
                            if(value) {
                              Future.delayed(const Duration(seconds: 3), () {
                                Navigator.pop(context);
                              });

                            }
                          });
                        });
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

  final picker = ImagePicker();

  Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("userId") ?? "no id";
  }

  Future<bool> storeUserData(String userId) async {


   // final isValid = formKey.currentState!.validate();

      if(hasFile){

        setState(() {
          isLoading = !isLoading;
        });

        String downloadUrl;
         await FirebaseStorage.instance.ref("images/"+imageFile.path).putFile(imageFile).then((p0) {
             p0.ref.getDownloadURL().then((value) {
               downloadUrl = value;

               print("download url : $value");

               if(formKey.currentState != null) {
                 formKey.currentState!.save();
               }
               CollectionReference users = FirebaseFirestore.instance.collection('users');

               if(firstNameController.text.isEmpty && lastNameController.text.isEmpty){
                 users.doc(userId).update({
                   'firstName': "Main",
                   'lastName': "User",
                   'imageUrl': downloadUrl,
                 }).then((value) {
                   storeFatherData(downloadUrl, "Main", "User");
                 });
               }

               else if(firstNameController.text.isEmpty){

                 users.doc(userId).update({
                   'firstName': "Main",
                   'lastName': lastNameController.text,
                   'imageUrl': downloadUrl,
                 }).then((value) {
                   storeFatherData(downloadUrl, "Main", lastNameController.text);
                 });
               }else if(lastNameController.text.isEmpty){
                 users.doc(userId).update({
                   'firstName': firstNameController.text,
                   'lastName': "User",
                   'imageUrl': downloadUrl,
                 }).then((value) {
                   storeFatherData(downloadUrl, firstNameController.text, "User");
                 });
               }
               else {
                 users.doc(userId).update({
                   'firstName': firstNameController.text,
                   'lastName': lastNameController.text,
                   'imageUrl': downloadUrl,
                 }).then((value) {
                   storeFatherData(downloadUrl, firstNameController.text,
                       lastNameController.text);
                 });

               }

             });

         });

      return true;

      }else{

        getFatherImage().then((imageUrl) {

        setState(() {
          isLoading = !isLoading;
        });

        if(formKey.currentState != null) {
          formKey.currentState!.save();
        }
        CollectionReference users = FirebaseFirestore.instance.collection('users');

        if(firstNameController.text.isEmpty && lastNameController.text.isEmpty){
          users.doc(userId).update({
            'firstName': "Main",
            'lastName': "User",
            'imageUrl': imageUrl,
          }).then((value) {
            storeFatherData(imageUrl, "Main", "User");
          });
        }

        else if(firstNameController.text.isEmpty){

          users.doc(userId).update({
            'firstName': "Main",
            'lastName': lastNameController.text,
            'imageUrl': imageUrl,
          }).then((value) {
            storeFatherData(imageUrl, "Main", lastNameController.text);
          });

        }else if(lastNameController.text.isEmpty){
          users.doc(userId).update({
            'firstName': firstNameController.text,
            'lastName': "User",
            'imageUrl': imageUrl,
          }).then((value) {
            storeFatherData(imageUrl, firstNameController.text, "User");
          });
        }
        else {
          users.doc(userId).update({
            'firstName': firstNameController.text,
            'lastName': lastNameController.text,
            'imageUrl': imageUrl,
          }).then((value) {
            storeFatherData(imageUrl, firstNameController.text,
                lastNameController.text);
          });

        }
        });

      }

      return true;
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(mounted) {
      setState(() {
        hasFile = true;
        imageFile = File(pickedFile!.path);
      });
    }else{
      setState(() {
        hasFile = false;
      });
    }

    print("pickedFile: $pickedFile");
    print("imageFile: $imageFile");

  }
  
  Future storeFatherData(String imageUrl, String firstName, String lastName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("imageUrl", imageUrl);
    prefs.setString("fullName", "$firstName $lastName");
    
  }

  Future<String> getFatherImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("imageUrl") ?? "no image";

  }


}
