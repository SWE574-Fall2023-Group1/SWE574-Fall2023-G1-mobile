class Prediction {
  String description;
  List<MatchedSubstring> matchedSubstrings;
  String placeId;
  String reference;
  StructuredFormatting structuredFormatting;
  List<Term> terms;
  List<String> types;

  Prediction({
    required this.description,
    required this.matchedSubstrings,
    required this.placeId,
    required this.reference,
    required this.structuredFormatting,
    required this.terms,
    required this.types,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) {
    return Prediction(
      description: json['description'],
      matchedSubstrings: (json['matched_substrings'] as List)
          .map((e) => MatchedSubstring.fromJson(e))
          .toList(),
      placeId: json['place_id'],
      reference: json['reference'],
      structuredFormatting: StructuredFormatting.fromJson(
        json['structured_formatting'],
      ),
      terms: (json['terms'] as List).map((e) => Term.fromJson(e)).toList(),
      types: List<String>.from(json['types']),
    );
  }
}

class MatchedSubstring {
  int length;
  int offset;

  MatchedSubstring({required this.length, required this.offset});

  factory MatchedSubstring.fromJson(Map<String, dynamic> json) {
    return MatchedSubstring(
      length: json['length'],
      offset: json['offset'],
    );
  }
}

class StructuredFormatting {
  String mainText;
  List<MatchedSubstring> mainTextMatchedSubstrings;
  String secondaryText;

  StructuredFormatting({
    required this.mainText,
    required this.mainTextMatchedSubstrings,
    required this.secondaryText,
  });

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
    return StructuredFormatting(
      mainText: json['main_text'],
      mainTextMatchedSubstrings: (json['main_text_matched_substrings'] as List)
          .map((e) => MatchedSubstring.fromJson(e))
          .toList(),
      secondaryText: json['secondary_text'],
    );
  }
}

class Term {
  int offset;
  String value;

  Term({required this.offset, required this.value});

  factory Term.fromJson(Map<String, dynamic> json) {
    return Term(
      offset: json['offset'],
      value: json['value'],
    );
  }
}

class PlaceResponse {
  List<Prediction> predictions;
  String status;

  PlaceResponse({required this.predictions, required this.status});

  factory PlaceResponse.fromJson(Map<String, dynamic> json) {
    return PlaceResponse(
      predictions: (json['predictions'] as List)
          .map((e) => Prediction.fromJson(e))
          .toList(),
      status: json['status'],
    );
  }
}
