import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
      body: GoogleMap(
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
      floatingActionButton: FloatingActionButton(
        onPressed: _goToCurrentPos,
        child: const Icon(Icons.my_location_rounded),
      ),
    );
  }

  Future<void> getCurrentPos() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
       _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }


  Future<LatLng> _goToCurrentPos() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    LatLng currentPostion = LatLng(position.latitude, position.longitude);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: currentPostion,
      zoom: 19.151926040649414,
    )));

    return currentPostion;
  }
}
