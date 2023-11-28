import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../services/location_service.dart';
import '../components/place_suggestion_tile.dart';
import '../models/place_suggestion.dart';

class SearchPlaceTextField extends StatefulWidget {
  const SearchPlaceTextField({Key? key, required this.onSuggestionTapped, this.color = Colors.white, this.countries = const []}) : super(key: key);
  final Function(PlaceSuggestion) onSuggestionTapped;
  final Color color;
  final List<String> countries;

  @override
  State<SearchPlaceTextField> createState() => _SearchPlaceTextFieldState();
}

class _SearchPlaceTextFieldState extends State<SearchPlaceTextField> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: TypeAheadField<PlaceSuggestion>(
        suggestionsBoxDecoration: SuggestionsBoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), elevation: 0),
        textFieldConfiguration: TextFieldConfiguration(
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16, height: 1.5),
          controller: _textController,
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.color,
            contentPadding: const EdgeInsets.only(top: 16, bottom: 14, left: 15),
            prefixIcon: Container(
              constraints: const BoxConstraints(maxHeight: 29, maxWidth: 29),
              child: const Icon(Icons.search, size: 29, color: Colors.black),
            ),
            hintText: 'Search place',
            hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400, fontSize: 16, height: 1.5),
            isDense: true,
            focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(20)),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(20)),
          ),
        ),
        suggestionsCallback: (pattern) async {
          if (pattern.length >= 3) {
            return await LocationService.I.getLocationAutoCompleteHints(_textController.text, countries: widget.countries);
          }
          return <PlaceSuggestion>[];
        },
        itemBuilder: (context, PlaceSuggestion suggestion) {
          return PlaceSuggestionTile(autoCompleteItem: suggestion);
        },
        noItemsFoundBuilder: (context) => _textController.text.length < 3
            ? const SizedBox()
            : const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Text(
                  "No place found",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
        onSuggestionSelected: widget.onSuggestionTapped,
      ),
    );
  }
}
