/// Autocomplete results item returned from Google will be deserialized
/// into this model.
class PlaceSuggestion {
  /// Creates a new instance of [PlaceSuggestion].
  PlaceSuggestion();

  /// The id of the place. This helps to fetch the lat,lng of the place.
  String id = "";

  /// The text (name of place) displayed in the autocomplete suggestions list.
  String text = "";

  /// Assistive index to begin highlight of matched part of the [text] with
  /// the original query.
  int offset = -1;

  /// Length of matched part of the [text].
  int length = -1;

  /// Creates an instance of [PlaceSuggestion] from a JSON object.
  PlaceSuggestion.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    text = map["text"];
    offset = map["offset"];
    length = map["length"];
  }

  /// Converts an instance of [PlaceSuggestion] to a JSON object.
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data["id"] = id;
    data["text"] = text;
    data["offset"] = offset;
    data["length"] = length;
    return data;
  }

  @override
  String toString() {
    return 'AutoCompleteItem{id: $id, text: $text, offset: $offset, length: $length}';
  }
}
