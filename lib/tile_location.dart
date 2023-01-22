class TileLocation {
  double lat;
  double lng;

//<editor-fold desc="Data Methods">

  TileLocation({
    required this.lat,
    required this.lng,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TileLocation && runtimeType == other.runtimeType && lat == other.lat && lng == other.lng);

  @override
  int get hashCode => lat.hashCode ^ lng.hashCode;

  @override
  String toString() {
    return 'TileLocation{' + ' lat: $lat,' + ' lng: $lng,' + '}';
  }

  TileLocation copyWith({
    double? lat,
    double? lng,
  }) {
    return TileLocation(
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lat': this.lat,
      'lng': this.lng,
    };
  }

  factory TileLocation.fromMap(Map<String, dynamic> map) {
    return TileLocation(
      lat: map['lat'] as double,
      lng: map['lng'] as double,
    );
  }

//</editor-fold>
}