import 'package:flutter/material.dart';

import '../models/place_suggestion.dart';

/// A tile widget that displays a suggestion for a place search result.
class PlaceSuggestionTile extends StatelessWidget {
  const PlaceSuggestionTile({Key? key, required this.autoCompleteItem}) : super(key: key);

  final PlaceSuggestion autoCompleteItem;

  @override
  Widget build(BuildContext context) {
    // return Padding(
    //   padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
    //   child: Text(autoCompleteItem.text, overflow: TextOverflow.ellipsis),
    // );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12),
            child: RichText(
              text: TextSpan(children: getStyledTexts()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: Divider(height: 0.5, thickness: 0.5, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  /// Returns a list of TextSpan objects that represent styled text for displaying an autocomplete item.
  List<TextSpan> getStyledTexts() {
    final List<TextSpan> result = [];

    String startText = autoCompleteItem.text.substring(0, autoCompleteItem.offset);
    if (startText.isNotEmpty) {
      result.add(
        TextSpan(
          text: startText,
          style: const TextStyle(color: Colors.black, fontSize: 14),
        ),
      );
    }

    String boldText = autoCompleteItem.text.substring(autoCompleteItem.offset, autoCompleteItem.offset + autoCompleteItem.length);

    result.add(
      TextSpan(
        text: boldText,
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),
      ),
    );

    String remainingText = autoCompleteItem.text.substring(autoCompleteItem.offset + autoCompleteItem.length);
    result.add(
      TextSpan(
        text: remainingText,
        style: const TextStyle(color: Colors.black, fontSize: 14),
      ),
    );

    return result;
  }
}
