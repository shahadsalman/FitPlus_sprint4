import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../screens/map_picker/models/lat_lng_model.dart';
import '../screens/map_picker/models/place_info.dart';
import '../screens/map_picker/models/place_suggestion.dart';
import '../screens/map_picker/utils/uuid.dart';
import '../value/keys.dart';

class LocationService extends GetxController {
  static LocationService get I => Get.find<LocationService>();

  LocationPermission? permission;
  Position? locationData;
  bool serviceEnabled = false;
  bool locationEnabled = false;
  bool get hasLocation => locationData != null;
  bool get hasPermission => permission == LocationPermission.always || permission == LocationPermission.whileInUse;

  Future<bool> checkPermission() async {
    permission = await Geolocator.checkPermission();
    if (!hasPermission) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        final bool? desc = await Get.dialog(
          AlertDialog(
            title: const Text("Location Permission Denied"),
            content: const Text("Fitplus provides location based services. Please allow Fitplus to access your location for a better experience."),
            actions: [
              InkWell(
                onTap: () => Get.back(result: true),
                child: const Text(
                  "Ask again",
                  style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w500, fontSize: 14, height: 1.5),
                ),
              ),
            ],
          ),
        );
        if (desc == true) {
          permission = await Geolocator.requestPermission();
        }
      } else if (permission == LocationPermission.deniedForever) {
        await Get.dialog(
          AlertDialog(
            title: const Text("Location Permission Denied"),
            content: const Text("You have denied the permission. Please enable it from the 'Settings' section of your phone."),
            actions: [
              InkWell(
                onTap: () => Get.back(),
                child: const Text(
                  "Close",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14, height: 1.5),
                ),
              ),
              InkWell(
                onTap: () async {
                  Geolocator.openLocationSettings();
                },
                child: const Text(
                  "Go to settings",
                  style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w600, fontSize: 14, height: 1.5),
                ),
              ),
            ],
          ),
        );
        permission = await Geolocator.checkPermission();
      }
    }
    return hasPermission;
  }

  Future<bool> requestService() async {
    bool isGranted = await checkPermission();
    if (!isGranted) {
      return false;
    }
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Get.dialog(
        AlertDialog(
          title: const Text("Turn on Location"),
          content: const Text("Please turn on location"),
          actions: [
            InkWell(
              onTap: () => Get.back(),
              child: const Text(
                "Close",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14, height: 1.5),
              ),
            ),
            InkWell(
              onTap: () async {
                Geolocator.openLocationSettings();
              },
              child: const Text(
                "Go to settings",
                style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w600, fontSize: 14, height: 1.5),
              ),
            ),
          ],
        ),
      );
    }
    return serviceEnabled;
  }

  Future<Position?> getLocationData() async {
    final isEnabled = await requestService();
    if (!isEnabled) {
      return null;
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<List<PlaceSuggestion>> getLocationAutoCompleteHints(String place, {List<String> countries = const []}) async {
    place = place.replaceAll(" ", "+");
    final String sessionToken = Uuid().generateV4();
    final String regionParam = countries.isNotEmpty ? "&components=country:${countries.sublist(0, min(countries.length, 5)).join('|country:')}" : "";
    final String endpoint = "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=$kGMapsKey&input={$place}$regionParam&sessiontoken=$sessionToken";

    final response = await http.get(Uri.parse(endpoint));
    List<PlaceSuggestion> suggestions = [];
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> predictions = data['predictions'];

      for (dynamic t in predictions) {
        PlaceSuggestion aci = PlaceSuggestion();

        aci.id = t['place_id'];
        aci.text = t['description'];
        aci.offset = t['matched_substrings'][0]['offset'];
        aci.length = t['matched_substrings'][0]['length'];

        suggestions.add(aci);
      }
    }
    return suggestions;
  }

  Future<LatLng?> getLatLngFromPlaceId(String placeId) async {
    String endpoint = "https://maps.googleapis.com/maps/api/place/details/json?key=$kGMapsKey&placeid=$placeId";

    final response = await http.get(Uri.parse(endpoint));
    if (response.statusCode == 200) {
      Map<String, dynamic> location = jsonDecode(response.body)['result']['geometry']['location'];
      final latLng = LatLng(latitude: location['lat'], longitude: location['lng']);
      return latLng;
    }
    return null;
  }

  Future<PlaceInfo?> getPlaceInfoFromLatLng(LatLng latLng) async {
    PlaceInfo? placeInfo;
    var response = await http.get(Uri.parse("https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$kGMapsKey"));
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      String road;
      String address;
      String placeId = responseJson['results'][0]['place_id'];
      if (responseJson['status'] == 'REQUEST_DENIED') {
        road = 'REQUEST DENIED = please see log for more details';
        address = 'REQUEST DENIED = please see log for more details';
        if (kDebugMode) {
          print(responseJson['error_message']);
        }
      } else {
        address = responseJson['results'][0]['formatted_address'];
        road = responseJson['results'][0]['address_components'][0]['short_name'];
      }
      placeInfo = PlaceInfo(latLng: latLng, road: road, placeId: placeId, address: address);
    }
    return placeInfo;
  }
}
