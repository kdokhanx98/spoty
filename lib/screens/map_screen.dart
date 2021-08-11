import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location/location.dart' as location;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spoty/providers/purchase_provider.dart';
import 'package:spoty/screens/share_code_screen.dart';
import 'package:spoty/screens/signup_screen.dart';
import 'package:spoty/screens/subscription_screen.dart';
import 'package:http/http.dart' as http;
import 'package:spoty/model/user.dart';

import 'initial_profile.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/MapScreen';


  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with SingleTickerProviderStateMixin{
  Set<Marker> markers = {};
  late BitmapDescriptor fatherMarker;
  late BitmapDescriptor childMarker;
  String fatherName = "Main User";

  late List<QueryDocumentSnapshot<Object?>> childrenList = [];

  late AnimationController _animationController;
  final Duration _duration = const Duration(milliseconds: 500);
  final Tween<Offset> _tween = Tween(begin: const Offset(0, 1), end: const Offset(0, 0));



  final LatLng _currentPosition = const LatLng(37.431434, -12.53234);

  final Completer<GoogleMapController> _controller = Completer();

  bool permissionGranted = false;
  bool isLoading = false;




  @override
  void initState() {
    checkStored().then((value) {
      if(!value){
        storeDefaultData();
      }
    });

    checkPermission().then((value) {
      setState(() {
        permissionGranted = value;
      });
    });
    setMarkers();
    _animationController = AnimationController(vsync: this, duration: _duration);
    super.initState();

  }

  @override
  void didChangeDependencies() {
    print("inside did change");
    getUserData().then((value) async {
      print("image url:  ${value.imageUrl}");
      if(value.imageUrl != "no image"){
        http.Response response = await http.get(
          Uri.parse(value.imageUrl),
        );
        final image = response.bodyBytes;
        final Codec markerImageCodec = await instantiateImageCodec(
          image,
          targetWidth: 150,
        );
        final FrameInfo frameInfo = await markerImageCodec.getNextFrame();
        final ByteData? byteData = await frameInfo.image.toByteData(
          format: ImageByteFormat.png,
        );
        final Uint8List resizedMarkerImageBytes = byteData!.buffer.asUint8List();
        fatherMarker = BitmapDescriptor.fromBytes(resizedMarkerImageBytes);

        _goToCurrentPos().then((latlng) {
          setState(() {
            markers.add(
              Marker(
                onTap: () {
                  Navigator.pushNamed(context, InitialProfile.routeName);
                },
                markerId: const MarkerId('id-0'),
                position: latlng,
                icon: fatherMarker,
              ),
            );
          });
        });

      }
    });
    super.didChangeDependencies();
  }

  void setMarkers() async {
    fatherMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/images/father.png");
    childMarker = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "assets/images/child_image.png");

  }



  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PurchaseProvider>(context);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: permissionGranted? Stack(
          children: [
            GoogleMap(
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              markers: markers,
              myLocationEnabled: true,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 12,
              ),
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                getUserData().then((value)  async {
                  if(value.imageUrl != "no image"){
                    http.Response response = await http.get(
                      Uri.parse(value.imageUrl),
                    );
                    final image = response.bodyBytes;
                    final Codec markerImageCodec = await instantiateImageCodec(
                      image,
                      targetWidth: 150,
                    );
                    final FrameInfo frameInfo = await markerImageCodec.getNextFrame();
                    final ByteData? byteData = await frameInfo.image.toByteData(
                      format: ImageByteFormat.png,
                    );
                    final Uint8List resizedMarkerImageBytes = byteData!.buffer.asUint8List();
                    fatherMarker = BitmapDescriptor.fromBytes(resizedMarkerImageBytes);

                  }
                  if(value.fullName != "not exist"){
                    fatherName = value.fullName;
                  }
                _goToCurrentPos().then((latlng) {

                  getChildren(value.fatherCode).then((list) {
                    setState(() {
                      childrenList = list;
                    });
                    var counter = 1;
                    list.map((e) async {
                      LatLng position = LatLng(e["lat"], e["long"]);
                      setState(() {
                        markers.add(
                          Marker(
                            markerId: MarkerId('id-$counter'),
                            position: position,
                            icon: childMarker,
                            infoWindow:
                            InfoWindow(title: e["childName"],),

                          ),
                        );
                        counter +=1;
                      });
                    }).toList();

                    setState(() {
                    markers.add(
                      Marker(
                        onTap: (){Navigator.pushNamed(context, InitialProfile.routeName);},
                        markerId: const MarkerId('id-0'),
                        position: latlng,
                        icon: fatherMarker,
                      ),
                    );
                  });


                });
                });


                });
              },
            ),
            Align(
              alignment: FractionalOffset.bottomLeft,
              child: Padding(
                padding:
                const EdgeInsets.only(bottom: 16.0, left: 16, right: 44),
                child: isLoading ? Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    color: HexColor("#006D72"),
                  ),
                  width: width * 0.6,
                  alignment: Alignment.center,
                  height: 40,
                  child: const CircularProgressIndicator(),
                ) : GestureDetector(
                  onTap: () {
                    if(provider.isPurchased){
                      checkLogged().then((value) {
                        if(value){
                          Navigator.pushNamed(context, ShareCode.routeName);
                        }else{
                          Navigator.pushNamed(context, SignUp.routeName);
                        }
                      });

                    }else{

                    checkStored().then((value) {
                      if(value){
                        Navigator.pushNamed(context, SubScreen.routeName);
                      }else{
                        storeDefaultData().then((value) {
                          Navigator.pushNamed(context, SubScreen.routeName);
                        });
                      }
                    });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: HexColor("#006D72"),
                    ),
                    width: width * 0.6,
                    alignment: Alignment.center,
                    height: 40,
                    child: const Text(
                      'Start Tracking',
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),
              ),
            ),
            Stack(
              children: <Widget>[
                SizedBox.expand(
                  child: SlideTransition(
                    position: _tween.animate(_animationController),
                    child: DraggableScrollableSheet(
                      builder: (BuildContext context, ScrollController scrollController) {
                        return Container(
                          decoration:  BoxDecoration(
                            borderRadius:  const BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),

                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: childrenList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding:  EdgeInsets.only(left: width * 0.05, right: width * 0.05, bottom: height * 0.01, top: width * 0.05),
                                  child: Container(
                                    decoration:  BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                                      color: HexColor("#F7F7F7"),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0, 3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      leading: Image.asset("assets/images/child.png",

                                      ),
                                        subtitle: Text('Now at ${childrenList[index]["lat"]}, ${childrenList[index]["long"]}'),
                                        title: Text('${childrenList[index]["childName"]}', style: const TextStyle(fontSize: 18),),
                                      onTap: (){
                                        goToPos(childrenList[index]["lat"], childrenList[index]["long"]);
                                      },
                                    ),
                                  ),
                                );
                              },

                            ),
                          );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ) : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Center(child: Text("Enable permissions to use the application features", style: TextStyle(fontSize: 16),),),
            Center(child: Text("Click the button down below", style: TextStyle(fontSize: 14),),),
          ],
        ),
      ),
      floatingActionButton:
      Stack(
        children: [


          childrenList.isNotEmpty ? Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding:  EdgeInsets.only(bottom: height * 0.09),
              child: FloatingActionButton(
                heroTag: "childrenList",
                backgroundColor: HexColor("#006D72"),
                onPressed: (){
                  getUserData().then((value) {
                    getChildren(value.fatherCode).then((list) {
                      if(list.isNotEmpty){
                        if (_animationController.isDismissed) {
                          _animationController.forward();
                        } else if (_animationController.isCompleted) {
                          _animationController.reverse();
                        }
                      }else{
                        Fluttertoast.showToast(msg: "No children tracked yet");
                      }
                    });

                  });

                },
                child: AnimatedIcon(icon: AnimatedIcons.menu_close, progress: _animationController),
                elevation: 5,

              ),
            ),
          ): Container(),

          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              heroTag: "myLocation",
              backgroundColor: Colors.white,
              onPressed: _goToCurrentPos,
              child:  Icon(Icons.my_location_rounded, color: HexColor("#006D72"),),
            ),
          ),

        ],
      )

    );
  }

  Future<bool> checkLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool('loggedIn') ?? false;

  }



  Future goToPos(double lat, double long) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      location.Location.instance.requestService();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {

      if(Platform.isAndroid){
        var androidInfo = await DeviceInfoPlugin().androidInfo;
        var sdkInt = androidInfo.version.sdkInt;
        if(sdkInt >= 30){
          Geolocator.openAppSettings();
          Fluttertoast.showToast(msg: "Please enable location permission", toastLength: Toast.LENGTH_LONG);
        }else{
          permission = await Geolocator.requestPermission();
        }
      }

      if (permission == LocationPermission.denied) {
        if(Platform.isAndroid){
          var androidInfo = await DeviceInfoPlugin().androidInfo;
          var sdkInt = androidInfo.version.sdkInt;
          if(sdkInt >= 30){
            Geolocator.openAppSettings();
            Fluttertoast.showToast(msg: "Please enable location permission", toastLength: Toast.LENGTH_LONG);
          }else{
            permission = await Geolocator.requestPermission();
          }
        }
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if(Platform.isAndroid){
        var androidInfo = await DeviceInfoPlugin().androidInfo;
        var sdkInt = androidInfo.version.sdkInt;
        if(sdkInt >= 30){
          Geolocator.openAppSettings();
          Fluttertoast.showToast(msg: "Please enable location permission", toastLength: Toast.LENGTH_LONG);
        }else{
          permission = await Geolocator.requestPermission();
        }
      }
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    final GoogleMapController controller = await _controller.future;
    LatLng childPos = LatLng(lat, long);
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: childPos,
      zoom: 19.151926040649414,
    )));


  }

  Future<LatLng> _goToCurrentPos() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      location.Location.instance.requestService();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {

      if(Platform.isAndroid){
        var androidInfo = await DeviceInfoPlugin().androidInfo;
        var sdkInt = androidInfo.version.sdkInt;
        if(sdkInt >= 30){
          Geolocator.openAppSettings();
          Fluttertoast.showToast(msg: "Please enable location permission", toastLength: Toast.LENGTH_LONG);
        }else{
          permission = await Geolocator.requestPermission();
        }
      }

      if (permission == LocationPermission.denied) {
        if(Platform.isAndroid){
          var androidInfo = await DeviceInfoPlugin().androidInfo;
          var sdkInt = androidInfo.version.sdkInt;
          if(sdkInt >= 30){
            Geolocator.openAppSettings();
            Fluttertoast.showToast(msg: "Please enable location permission", toastLength: Toast.LENGTH_LONG);
          }else{
            permission = await Geolocator.requestPermission();
          }
        }
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if(Platform.isAndroid){
        var androidInfo = await DeviceInfoPlugin().androidInfo;
        var sdkInt = androidInfo.version.sdkInt;
        if(sdkInt >= 30){
          Geolocator.openAppSettings();
          Fluttertoast.showToast(msg: "Please enable location permission", toastLength: Toast.LENGTH_LONG);
        }else{
          permission = await Geolocator.requestPermission();
        }
      }
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    setState(() {
      permissionGranted = true;
    });

    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      LatLng currentPosition = LatLng(position.latitude, position.longitude);
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: currentPosition,
        zoom: 19.151926040649414,
      )));
      return currentPosition;

  }

  Future<bool> checkStored() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool stored = (prefs.getBool('isDataStored') ?? false);

    if (stored) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkSubscription() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool subscribed = (prefs.getBool('subscribed') ?? false);

    if(subscribed){
      return true;
    }else{
      return false;
    }
  }

  Future<List<QueryDocumentSnapshot<Object?>>> getChildren(String fatherCode) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('children').get();
    var list = querySnapshot.docs.where((e) {
        if(e["fatherCode"] == fatherCode){
          return true;
        }
        return false;

    }).toList();

    return list;

  }


  Future<User> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String imageUrl = (prefs.getString("imageUrl") ?? "no image");
    String fullName = prefs.getString("fullName") ?? "not exist";
    String fatherCode = prefs.getString("userId") ?? "no id";

    User user = User(fullName, imageUrl, fatherCode);

    return user;
  }

  Future storeDefaultData() async {
    setState(() {
      isLoading = !isLoading;
    });
    // store to firebase
    CollectionReference users = FirebaseFirestore.instance.collection('users');


    users.add(
        {
          'firstName': "Main",
          'lastName': "User",
          'imageUrl': "no image",
        }).then((value) {
      print("user added default: ${value.id}");
      storeDefaultDataLocal(value.id).then((value) => print("stored deafult locally"));
      users.doc(value.id).update({'fatherCode': value.id});
      setState(() {
        isLoading = !isLoading;
      });
    })
        .catchError((error) => print("Failed to add user: $error"));



  }

  Future storeDefaultDataLocal(String userId) async {
    // store to local
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDataStored", true);
    prefs.setString("userId", userId);
    prefs.setString("imageUrl", "no image");
    prefs.setString("fullName", "Main User");
  }




  Future<bool> checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();

    if (!serviceEnabled) {
      location.Location.instance.requestService();
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
