import 'package:flutter_test/flutter_test.dart';
import 'package:tilecode/tile_id_converter.dart';
import 'package:tuple/tuple.dart';

void main() {
  // https://jsfiddle.net/gh/get/library/pure/googlemaps/js-samples/tree/master/dist/samples/map-coordinates/jsfiddle
  test('location2tile', () {
    // z:0
    expect(const Tuple2(0, 0), TileIdConverter.location2tile(0, 0, 0));
    expect(const Tuple2(0, 0), TileIdConverter.location2tile(0, 85, 0));
    expect(const Tuple2(0, 0), TileIdConverter.location2tile(0, -85, 0));
    expect(const Tuple2(0, 0), TileIdConverter.location2tile(0, 0, -180));
    expect(const Tuple2(0, 0), TileIdConverter.location2tile(0, 0, 179));

    // z:1
    expect(const Tuple2(0, 0), TileIdConverter.location2tile(1, 85, -180));
    expect(const Tuple2(0, 1), TileIdConverter.location2tile(1, 0, -180));
    expect(const Tuple2(0, 1), TileIdConverter.location2tile(1, -85, -180));
    expect(const Tuple2(1, 0), TileIdConverter.location2tile(1, 85, 0));
    expect(const Tuple2(1, 0), TileIdConverter.location2tile(1, 85, 179));
  });

  test('tile2location', () {
    // z:0
    expect(const Tuple2(85.0511287798066, -180.0), TileIdConverter.tile2location(0, 0, 0));
    expect(const Tuple2(0, 0), TileIdConverter.tile2location(0, 0.5, 0.5));

    // z:1
    expect(const Tuple2(85.0511287798066, -180.0), TileIdConverter.tile2location(1, 0, 0));
    expect(const Tuple2(0, 0), TileIdConverter.tile2location(1, 1, 1));
    expect(const Tuple2(85.0511287798066, 0), TileIdConverter.tile2location(1, 1, 0));
    expect(const Tuple2(0, -180), TileIdConverter.tile2location(1, 0, 1));
  });
}