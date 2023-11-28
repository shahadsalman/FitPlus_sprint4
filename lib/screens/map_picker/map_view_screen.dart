import 'dart:async';

import 'package:fitplus/services/location_service.dart';
import 'package:fitplus/value/constant.dart';
import 'package:fitplus/value/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  final double lat = Get.arguments["gymLat"];
  final double lng = Get.arguments["gymLng"];
  final String gymLocation = Get.arguments["locationGym"];
  final String? gymName = Get.arguments["gymName"];
  final double _defaultZoom = 15;

  bool _directionsLoading = false;

  List<LatLng> polylineCoordinates = [];
  final Completer<GoogleMapController> _controller = Completer();
  final Map<String, Marker> _markers = {};
  late final CameraPosition _iniNalCameraPosiNon;
  @override
  void initState() {
    super.initState();
    // Define a marker with a unique ID and desired opNons
    _iniNalCameraPosiNon = CameraPosition(
      target: LatLng(lat, lng), // IniNal map locaNon
      zoom: _defaultZoom,
    );
    final Marker gymMarker = Marker(
      markerId: const MarkerId('gym_locaNon'),
      position: LatLng(lat, lng), // Gym locaNon coordinates
      infoWindow: InfoWindow(title: gymName ?? 'Gym Location'),
      icon: BitmapDescriptor.defaultMarker, // You can customize the icon here
    );
    // Add the marker to the _markers map
    _markers['gym'] = gymMarker;
  }

  // FuncNon to move the marker to a new locaNon
  void moveMarker(LatLng newLocaNon) {
    if (_markers.containsKey('gym')) {
      setState(() {
        _markers['gym'] = Marker(
          markerId: const MarkerId('gym_locaNon'),
          position: newLocaNon,
          infoWindow: InfoWindow(title: gymName ?? 'Gym Location'),
          icon: BitmapDescriptor.defaultMarker,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xff48358e),
        onPressed: () {
          if (polylineCoordinates.isEmpty) {
            _getDirections();
          } else {
            polylineCoordinates.clear();
            _markers.remove("userLoc");
            _moveToCameraPosition(CameraPosition(target: LatLng(lat, lng), zoom: _defaultZoom));
            setState(() {});
          }
        },
        label: _directionsLoading
            ? const SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : polylineCoordinates.isEmpty
                ? const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Show Directions",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.directions)
                    ],
                  )
                : const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Cancel Directions",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.close)
                    ],
                  ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 210, 199, 226),
        title: const Text('Gym Location', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20),
      ),
      backgroundColor: const Color.fromARGB(255, 223, 221, 226),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            initialCameraPosition: _iniNalCameraPosiNon,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: Set<Marker>.from(_markers.values),
            polylines: {
              Polyline(
                polylineId: const PolylineId("route"),
                points: polylineCoordinates,
                // color: const Color(0xFF7B61FF),
                // color: const Color.fromARGB(255, 210, 199, 226),
                color: const Color(0xff48358e),
                // color: Colors.red,
                width: 5,
              ),
            },
            onTap: (LatLng locaNon) {
              // Move the marker to the tapped locaNon
              // moveMarker(locaNon);
            },
          ),
          Positioned(
            top: 20,
            child: InkWell(
              onTap: () {
                _moveToCameraPosition(CameraPosition(target: LatLng(lat, lng), zoom: _defaultZoom));
              },
              child: Container(
                width: Get.width * 0.80,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(color: kPrimaryColor, borderRadius: BorderRadius.circular(10)),
                child: Text(
                  gymLocation,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getDirections() async {
    setState(() {
      _directionsLoading = true;
    });
    final position = await LocationService.I.getLocationData();
    if (position != null) {
      final userIcon = await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(30, 30)), "assets/icon-user-loc-pin.png");
      _markers.addAll({"userLoc": Marker(markerId: const MarkerId("userLoc"), infoWindow: const InfoWindow(title: 'My Location'), position: LatLng(position.latitude, position.longitude), icon: userIcon)});
      // _markers.addAll({"userLoc": Marker(markerId: const MarkerId("userLoc"), infoWindow: const InfoWindow(title: 'My Location'), position: LatLng(position.latitude, position.longitude), icon: BitmapDescriptor.defaultMarker)});
      setState(() {});
      _moveToCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: _defaultZoom));
      getPolyPoints(userLat: position.latitude, userLng: position.longitude);
    }
    setState(() {
      _directionsLoading = false;
    });
  }

  Future<void> getPolyPoints({required double userLat, required double userLng}) async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      kGMapsKey,
      PointLatLng(userLat, userLng),
      PointLatLng(lat, lng),
    );
    if (result.points.isNotEmpty) {
      for (final point in result.points) {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
      setState(() {});
    }
  }

  Future<void> _moveToCameraPosition(CameraPosition position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }
}
