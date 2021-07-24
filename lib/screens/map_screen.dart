import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spoty/screens/subscription_screen.dart';

class MapScreen extends StatefulWidget {
  static const routeName = '/MapScreen';

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Set<Marker> markers = {};
  late BitmapDescriptor mapMarker;

  late LatLng _currentPosition = const LatLng(37.431434, -12.53234);

  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    setCustomMarker();
  }

  void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), "assets/images/father.png");
  }


  @override
  Widget build(BuildContext context) {

    return  Scaffold(

      body: Stack(
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
                _goToCurrentPos().then((value) {
                  setState(() {
                    markers.add(
                        Marker(
                          markerId: const MarkerId('id-1'),
                          position: value,
                          icon: mapMarker,
                          infoWindow: const InfoWindow(
                            title: "Father's Name",
                            snippet: "My Location",
                          ),
                        ),
                    );
                  });
                });
            },
          ),

          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0, left: 44, right: 44),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, SubscriptionScreen.routeName);
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.blueAccent,
                      ),

                      width: double.infinity,
                      alignment: Alignment.center,
                      height: 40,
                      child:  const Text(
                        'Start Tracking',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                  ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 44.0),
        child: FloatingActionButton(
          onPressed: _goToCurrentPos,
          child: const Icon(Icons.my_location_rounded),
        ),
      ),
    );
  }


  Future<LatLng> _goToCurrentPos() async {
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
}
