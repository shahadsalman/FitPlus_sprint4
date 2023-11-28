/// A class representing a latitude and longitude.
class LatLng {
  /// Creates an empty constructor.
  LatLng.empty();

  /// Creates a `LatLng` with the given [latitude] and [longitude].
  LatLng({this.latitude, this.longitude});

  /// The longitude value in degrees.
  double? longitude;

  /// The latitude value in degrees.
  double? latitude;

  /// Returns true if both [latitude] and [longitude] are null.
  bool get isEmpty => longitude == null || latitude == null;

  /// Creates an instance of [LatLng] from a JSON object.
  LatLng.fromMap(Map<String, dynamic> map) {
    latitude = map["latitude"];
    longitude = map["longitude"];
  }

  /// Converts an instance of [LatLng] to a JSON object.
  Map<String, dynamic> toMap() => {
        "latitude": latitude,
        "longitude": longitude,
      };

  @override
  String toString() {
    return 'LatLng{latitude: $latitude, longitude: $longitude}';
  }
}
