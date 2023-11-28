import 'lat_lng_model.dart';

/// The result returned after completing location selection.
class PlaceInfo {
  PlaceInfo.empty();

  PlaceInfo({this.road = "", this.address = "", this.placeId = "", required this.latLng});

  /// The human readable name of the location. This is primarily the
  /// name of the road. But in cases where the place was selected from Nearby
  /// places list, we use the <b>name</b> provided on the list item.
  String road = ""; // or road

  /// Formatted address of the place.
  String address = ""; // or road

  /// Google Maps place ID.
  String placeId = "";

  /// Latitude/Longitude of the selected location.
  LatLng latLng = LatLng.empty();

  /// Creates an instance of [PlaceInfo] from a JSON object.
  PlaceInfo.fromMap(Map<String, dynamic> map) {
    road = map["road"];
    placeId = map["placeId"];
    address = map["address"];
    latLng = LatLng.fromMap(map["latLng"]);
  }

  /// Converts an instance of [PlaceInfo] to a JSON object.
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data["road"] = road;
    data["address"] = address;
    data["placeId"] = placeId;
    data["latLng"] = latLng.toMap();
    return data;
  }

  @override
  String toString() {
    return 'LocationResult{address: $address, road: $road, latLng: $latLng, placeId: $placeId}';
  }
}
