class PlaceDetailsResponse {
  List<dynamic> htmlAttributions;
  PlaceDetailsResult result;
  String status;

  PlaceDetailsResponse({
    required this.htmlAttributions,
    required this.result,
    required this.status,
  });

  factory PlaceDetailsResponse.fromJson(Map<String, dynamic> json) {
    return PlaceDetailsResponse(
      htmlAttributions: List<dynamic>.from(json['html_attributions']),
      result: PlaceDetailsResult.fromJson(json['result']),
      status: json['status'],
    );
  }
}

class PlaceDetailsResult {
  Geometry geometry;

  PlaceDetailsResult({required this.geometry});

  factory PlaceDetailsResult.fromJson(Map<String, dynamic> json) {
    return PlaceDetailsResult(
      geometry: Geometry.fromJson(json['geometry']),
    );
  }
}

class Geometry {
  Location location;
  Viewport viewport;

  Geometry({required this.location, required this.viewport});

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      location: Location.fromJson(json['location']),
      viewport: Viewport.fromJson(json['viewport']),
    );
  }
}

class Location {
  double lat;
  double lng;

  Location({required this.lat, required this.lng});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
    );
  }
}

class Viewport {
  Northeast northeast;
  Southwest southwest;

  Viewport({required this.northeast, required this.southwest});

  factory Viewport.fromJson(Map<String, dynamic> json) {
    return Viewport(
      northeast: Northeast.fromJson(json['northeast']),
      southwest: Southwest.fromJson(json['southwest']),
    );
  }
}

class Northeast {
  double lat;
  double lng;

  Northeast({required this.lat, required this.lng});

  factory Northeast.fromJson(Map<String, dynamic> json) {
    return Northeast(
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
    );
  }
}

class Southwest {
  double lat;
  double lng;

  Southwest({required this.lat, required this.lng});

  factory Southwest.fromJson(Map<String, dynamic> json) {
    return Southwest(
      lat: json['lat'].toDouble(),
      lng: json['lng'].toDouble(),
    );
  }
}
