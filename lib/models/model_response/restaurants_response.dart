class FindNearbyRestaurantResponse {
  String? type;
  Center? center;
  num? radius;
  int? count;
  List<Places>? places;

  FindNearbyRestaurantResponse(
      {this.type, this.center, this.radius, this.count, this.places});

  FindNearbyRestaurantResponse.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    center =
    json['center'] != null ? Center.fromJson(json['center']) : null;
    radius = json['radius'] ?? json['radius_m'];
    count = json['count'];
    if (json['places'] != null) {
      places = <Places>[];
      json['places'].forEach((v) {
        places!.add(Places.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    if (center != null) {
      data['center'] = center!.toJson();
    }
    data['radius'] = radius;
    data['count'] = count;
    if (places != null) {
      data['places'] = places!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Center {
  double? lat;
  double? lon;

  Center({this.lat, this.lon});

  Center.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lon = json['lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lon'] = lon;
    return data;
  }
}

class Places {
  String? name;
  double? lat;
  double? lon;
  String? category;
  double? distanceM;

  Places({this.name, this.lat, this.lon, this.category, this.distanceM});

  Places.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    lat = json['lat']?.toDouble();
    lon = json['lon']?.toDouble();
    category = json['category'];
    distanceM = json['distance_m']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['lat'] = lat;
    data['lon'] = lon;
    data['category'] = category;
    data['distance_m'] = distanceM;
    return data;
  }
}