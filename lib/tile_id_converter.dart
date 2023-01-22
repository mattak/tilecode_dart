import 'dart:math';

import 'package:tuple/tuple.dart';

/// Convert between tile coordinates and tile IDs.
/// cf. https://wiki.openstreetmap.org/wiki/Slippy_map_tilenames#ECMAScript_(JavaScript/ActionScript,_etc.)
class TileIdConverter {
  /// Convert tile zoom, latitude, longitude to tile x, y.
  /// cf. https://developers.google.com/maps/documentation/javascript/examples/map-coordinates
  static Tuple2<int, int> location2tile(int zoom, double lat, double lng) {
    final scale = 1 << zoom;
    var siny = sin(lat * pi / 180);
    siny = min(max(siny, -0.9999), 0.9999);

    return Tuple2<int, int>(
      ((0.5 + lng / 360) * scale).floor(),
      ((0.5 - log((1 + siny) / (1 - siny)) / (4 * pi)) * scale).floor(),
    );
  }

  /// Convert tile zoom, x, y to latitude, longitude.
  /// cf. https://wiki.openstreetmap.org/wiki/Slippy_map_tilenames#ECMAScript_(JavaScript/ActionScript,_etc.)
  static Tuple2<double, double> tile2location(int zoom, double x, double y) {
    final scale = 1 << zoom;
    final lng = x / scale * 360 - 180;

    var n = pi - 2 * pi * y / scale;
    final lat = 180 / pi * atan(0.5 * (exp(n) - exp(-n)));

    return Tuple2(lat, lng);
  }
}
