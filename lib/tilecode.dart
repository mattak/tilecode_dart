import 'package:tilecode/tile_id_converter.dart';
import 'package:tilecode/tile_location.dart';

class TileCode {
  int zoom;
  int x;
  int y;

  List<int> getHex() {
    if (zoom % 2 != 0) throw Exception("Invalid zoom level. zoom must be divided by 2");
    final level = zoom ~/ 2;
    final array = <int>[];

    for (var i = 0; i < level; i++) {
      var v = 0;
      for (var k = 0; k < 2; k++) {
        final z = (zoom - 1) - (i * 2) - k;
        final ref = 1 << z;
        if (x & ref != 0) v |= 1 << (2 * (1 - k) + 1);
        if (y & ref != 0) v |= 1 << (2 * (1 - k));
      }
      array.add(v);
    }

    return array;
  }

  List<int> getBinary() {
    final array = <int>[];
    for (var i = 0; i < zoom; i++) {
      final ax = x >> (zoom - i - 1) & 0x01;
      final ay = y >> (zoom - i - 1) & 0x01;
      array.add(ax);
      array.add(ay);
    }
    return array;
  }

  String toHexString(bool withPrefix) {
    var result = withPrefix ? "0x" : "";
    final buffer = getHex();
    result += buffer.map((e) => e.toRadixString(16)).join();
    return result;
  }

  String toBinaryString(bool withPrefix) {
    var result = withPrefix ? "0b" : "";
    final buffer = getBinary();
    result += buffer.map((e) => e == 1 ? '1' : '0').join();
    return result;
  }

  String toTileIdString() {
    return '$zoom/$x/$y';
  }

  TileLocation getLocationStart() {
    final v = TileIdConverter.tile2location(zoom, x.toDouble(), y.toDouble());
    return TileLocation(lat: v.item1, lng: v.item2);
  }

  TileLocation getLocationCenter() {
    final v = TileIdConverter.tile2location(zoom, x + 0.5, y + 0.5);
    return TileLocation(lat: v.item1, lng: v.item2);
  }

  TileCode plus(int ax, int ay) {
    final limit = 1 << zoom;
    final nx = (x + ax) % limit;
    final ny = (y + ay) % limit;
    return TileCode(zoom: zoom, x: nx, y: ny);
  }

  bool isAvailableHexCode() {
    return zoom % 2 == 0;
  }

  static TileCode fromLocation(int zoom, double latitude, double longitude) {
    final v = TileIdConverter.location2tile(zoom, latitude, longitude);
    return TileCode(zoom: zoom, x: v.item1, y: v.item2);
  }

  static TileCode fromHex(List<int> numbers) {
    final z = numbers.length * 2;
    var sx = 0;
    var sy = 0;
    for (var i = 0; i < numbers.length; i++) {
      var x = 0;
      var y = 0;
      x += (numbers[i] & 8) >> 2; // 0b1000
      x += (numbers[i] & 2) >> 1; // 0b0010
      y += (numbers[i] & 4) >> 1; // 0b0100
      y += (numbers[i] & 1) >> 0; // 0b0001
      sx += x << (2 * (numbers.length - i - 1));
      sy += y << (2 * (numbers.length - i - 1));
    }
    return TileCode(zoom: z, x: sx, y: sy);
  }

  static TileCode fromBinary(List<int> numbers) {
    if (numbers.length % 2 != 0) throw Exception("numbers must be even size");
    final z = numbers.length ~/ 2;
    var x = 0;
    var y = 0;
    for (var i = 0; i < z; i++) {
      final cx = numbers[2 * i];
      final cy = numbers[2 * i + 1];
      if (cx == 1) {
        x += 1 << (z - i - 1);
      }
      if (cy == 1) {
        y += 1 << (z - i - 1);
      }
    }
    return TileCode(zoom: z, x: x, y: y);
  }

  static TileCode fromHexString(String text) {
    if (!RegExp("^(0x)?[0-9a-fA-F]*\$").hasMatch(text)) throw FormatException("Invalid tilecode hex string. $text");
    text = text.replaceFirst("0x", '');
    if (text.isEmpty) return TileCode(zoom: 0, x: 0, y: 0);
    final numbers = text.split('').map((b) => int.parse(b, radix: 16)).toList();
    return TileCode.fromHex(numbers);
  }

  static TileCode fromBinaryString(String text) {
    if (!RegExp("^(0b)?([01][01])*\$").hasMatch(text)) throw FormatException("Invalid tilecode binary string. $text");
    text = text.replaceFirst('0b', '');
    if (text.isEmpty) return TileCode(zoom: 0, x: 0, y: 0);
    final numbers = text.split('').map((b) => int.parse(b, radix: 2)).toList();
    return TileCode.fromBinary(numbers);
  }

//<editor-fold desc="Data Methods">

  TileCode({
    required this.zoom,
    required this.x,
    required this.y,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          (other is TileCode && runtimeType == other.runtimeType && zoom == other.zoom && x == other.x && y == other.y);

  @override
  int get hashCode => zoom.hashCode ^ x.hashCode ^ y.hashCode;

  @override
  String toString() {
    return 'TileCode{' + ' zoom: $zoom,' + ' x: $x,' + ' y: $y,' + '}';
  }

  TileCode copyWith({
    int? zoom,
    int? x,
    int? y,
  }) {
    return TileCode(
      zoom: zoom ?? this.zoom,
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'zoom': this.zoom,
      'x': this.x,
      'y': this.y,
    };
  }

  factory TileCode.fromMap(Map<String, dynamic> map) {
    return TileCode(
      zoom: map['zoom'] as int,
      x: map['x'] as int,
      y: map['y'] as int,
    );
  }

//</editor-fold>
}
