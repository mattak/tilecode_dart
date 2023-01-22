import 'package:flutter_test/flutter_test.dart';
import 'package:tilecode/tile_location.dart';
import 'package:tilecode/tilecode.dart';

void main() {
  test('TileCode.getHex', () {
    expect(<int>[], TileCode(zoom: 0, x: 0, y: 0).getHex());
    expect(<int>[0], TileCode(zoom: 2, x: 0, y: 0).getHex());
    expect(<int>[0, 0], TileCode(zoom: 4, x: 0, y: 0).getHex());

    expect(<int>[15], TileCode(zoom: 2, x: (1 << 2) - 1, y: (1 << 2) - 1).getHex());
    expect(<int>[15, 15], TileCode(zoom: 4, x: (1 << 4) - 1, y: (1 << 4) - 1).getHex());
    expect(<int>[0, 7], TileCode(zoom: 4, x: 1, y: 3).getHex());

    expect(() => TileCode(zoom: 1, x: 0, y: 0).getHex(), throwsException);
    expect(() => TileCode(zoom: 3, x: 0, y: 0).getHex(), throwsException);
  });

  test('TileCode.getBinary', () {
    expect(<int>[], TileCode(zoom: 0, x: 0, y: 0).getBinary());
    expect(<int>[0, 0], TileCode(zoom: 1, x: 0, y: 0).getBinary());
    expect(<int>[1, 0], TileCode(zoom: 1, x: 1, y: 0).getBinary());
    expect(<int>[0, 1], TileCode(zoom: 1, x: 0, y: 1).getBinary());

    expect(<int>[0, 0, 0, 0, 0, 0, 0, 0], TileCode(zoom: 4, x: 0, y: 0).getBinary());
    expect(<int>[1, 1, 1, 1, 1, 1, 1, 1], TileCode(zoom: 4, x: (1 << 4) - 1, y: (1 << 4) - 1).getBinary());
    expect(<int>[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        TileCode(zoom: 8, x: (1 << 8) - 1, y: (1 << 8) - 1).getBinary());
    expect(<int>[1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1], TileCode(zoom: 8, x: 0xf0, y: 0x0f).getBinary());
  });

  test('TileCode.toHexString', () {
    expect("", TileCode(zoom: 0, x: 0, y: 0).toHexString(false));
    expect("0x", TileCode(zoom: 0, x: 0, y: 0).toHexString(true));

    expect("0x0", TileCode(zoom: 2, x: 0, y: 0).toHexString(true));
    expect("0xf", TileCode(zoom: 2, x: (1 << 2) - 1, y: (1 << 2) - 1).toHexString(true));
    expect("0xff", TileCode(zoom: 4, x: (1 << 4) - 1, y: (1 << 4) - 1).toHexString(true));
    expect("0xaa", TileCode(zoom: 4, x: 0xf, y: 0x0).toHexString(true));
  });

  test('TileCode.toBinaryString', () {
    expect("", TileCode(zoom: 0, x: 0, y: 0).toBinaryString(false));
    expect("0b", TileCode(zoom: 0, x: 0, y: 0).toBinaryString(true));
    expect("0b00", TileCode(zoom: 1, x: 0, y: 0).toBinaryString(true));
    expect("0b10", TileCode(zoom: 1, x: 1, y: 0).toBinaryString(true));
    expect("0b01", TileCode(zoom: 1, x: 0, y: 1).toBinaryString(true));

    expect("0b00000000", TileCode(zoom: 4, x: 0, y: 0).toBinaryString(true));
    expect("0b11111111", TileCode(zoom: 4, x: (1 << 4) - 1, y: (1 << 4) - 1).toBinaryString(true));
    expect("0b1111111111111111", TileCode(zoom: 8, x: (1 << 8) - 1, y: (1 << 8) - 1).toBinaryString(true));
    expect("0b1010101001010101", TileCode(zoom: 8, x: 0xf0, y: 0x0f).toBinaryString(true));
  });

  test('TileCode.getLocationStart', () {
    expect(TileLocation(lat: 85.0511287798066, lng: -180), TileCode(zoom: 0, x: 0, y: 0).getLocationStart());

    expect(TileLocation(lat: 85.0511287798066, lng: -180), TileCode(zoom: 1, x: 0, y: 0).getLocationStart());
    expect(TileLocation(lat: 85.0511287798066, lng: 0), TileCode(zoom: 1, x: 1, y: 0).getLocationStart());
    expect(TileLocation(lat: 0, lng: -180), TileCode(zoom: 1, x: 0, y: 1).getLocationStart());
  });

  test('TileCode.getLocationCenter', () {
    expect(TileLocation(lat: 0, lng: 0), TileCode(zoom: 0, x: 0, y: 0).getLocationCenter());

    expect(TileLocation(lat: 66.51326044311186, lng: -90), TileCode(zoom: 1, x: 0, y: 0).getLocationCenter());
    expect(TileLocation(lat: 66.51326044311186, lng: 90), TileCode(zoom: 1, x: 1, y: 0).getLocationCenter());
    expect(TileLocation(lat: -66.51326044311186, lng: -90), TileCode(zoom: 1, x: 0, y: 1).getLocationCenter());
  });

  test('TileCode.plus', () {
    expect(TileCode(zoom: 0, x: 0, y: 0), TileCode(zoom: 0, x: 0, y: 0).plus(1, 2));
    expect(TileCode(zoom: 1, x: 1, y: 0), TileCode(zoom: 1, x: 0, y: 0).plus(1, 2));
    expect(TileCode(zoom: 1, x: 0, y: 1), TileCode(zoom: 1, x: 0, y: 0).plus(2, 1));
    expect(TileCode(zoom: 1, x: 1, y: 0), TileCode(zoom: 1, x: 0, y: 0).plus(-1, -2));
  });

  test('TileCode.fromLocation', () {
    expect(TileCode.fromLocation(0, 0, 0), TileCode(zoom: 0, x: 0, y: 0));
    expect(TileCode.fromLocation(1, 85.0511287798065, -180), TileCode(zoom: 1, x: 0, y: 0));
    expect(TileCode.fromLocation(1, 0, 0), TileCode(zoom: 1, x: 1, y: 1));
    expect(TileCode.fromLocation(1, -85.0511287798065, 179), TileCode(zoom: 1, x: 1, y: 1));
  });

  test('TileCode.fromHex', () {
    expect(TileCode.fromHex([]), TileCode(zoom: 0, x: 0, y: 0));
    expect(TileCode.fromHex([0]), TileCode(zoom: 2, x: 0, y: 0));
    expect(TileCode.fromHex([10]), TileCode(zoom: 2, x: 3, y: 0));
    expect(TileCode.fromHex([6]), TileCode(zoom: 2, x: 1, y: 2));
    expect(TileCode.fromHex([0, 0]), TileCode(zoom: 4, x: 0, y: 0));
    expect(TileCode.fromHex([10, 6]), TileCode(zoom: 4, x: 13, y: 2));
  });

  test('TileCode.fromBinary', () {
    expect(TileCode.fromBinary([]), TileCode(zoom: 0, x: 0, y: 0));
    // z:1
    expect(TileCode.fromBinary([0, 0]), TileCode(zoom: 1, x: 0, y: 0));
    expect(TileCode.fromBinary([1, 0]), TileCode(zoom: 1, x: 1, y: 0));
    expect(TileCode.fromBinary([0, 1]), TileCode(zoom: 1, x: 0, y: 1));
    // z:2
    expect(TileCode.fromBinary([0, 0, 0, 0]), TileCode(zoom: 2, x: 0, y: 0));
    expect(TileCode.fromBinary([1, 0, 0, 1]), TileCode(zoom: 2, x: 2, y: 1));
    expect(TileCode.fromBinary([0, 1, 1, 0]), TileCode(zoom: 2, x: 1, y: 2));
    // z:3
    expect(TileCode.fromBinary([0, 0, 0, 0, 0, 0]), TileCode(zoom: 3, x: 0, y: 0));
    expect(TileCode.fromBinary([1, 0, 0, 1, 1, 1]), TileCode(zoom: 3, x: 5, y: 3));
    expect(TileCode.fromBinary([0, 1, 1, 0, 0, 0]), TileCode(zoom: 3, x: 2, y: 4));
  });

  test('TileCode.fromHexString', () {
    expect(TileCode.fromHexString('0x'), TileCode(zoom: 0, x: 0, y: 0));
    // z:2
    expect(TileCode.fromHexString('0x0'), TileCode(zoom: 2, x: 0, y: 0));
    // z:4
    expect(TileCode.fromHexString('0xa5'), TileCode(zoom: 4, x: 12, y: 3));
    expect(TileCode.fromHexString('0x66'), TileCode(zoom: 4, x: 5, y: 10));
    // z:8
    expect(TileCode.fromHexString('0x0000'), TileCode(zoom: 8, x: 0, y: 0));
    expect(TileCode.fromHexString('0xa566'), TileCode(zoom: 8, x: 197, y: 58));
    // exception
    expect(() => TileCode.fromHexString('hijk'), throwsA(isA<FormatException>()));
  });

  test('TileCode.fromBinaryString', () {
    expect(TileCode.fromBinaryString('0b'), TileCode(zoom: 0, x: 0, y: 0));
    // z:1
    expect(TileCode.fromBinaryString('0b00'), TileCode(zoom: 1, x: 0, y: 0));
    expect(TileCode.fromBinaryString('0b10'), TileCode(zoom: 1, x: 1, y: 0));
    expect(TileCode.fromBinaryString('0b01'), TileCode(zoom: 1, x: 0, y: 1));
    // z:2
    expect(TileCode.fromBinaryString('0b0000'), TileCode(zoom: 2, x: 0, y: 0));
    expect(TileCode.fromBinaryString('0b1001'), TileCode(zoom: 2, x: 2, y: 1));
    expect(TileCode.fromBinaryString('0b0110'), TileCode(zoom: 2, x: 1, y: 2));
    // z:3
    expect(TileCode.fromBinaryString('0b000000'), TileCode(zoom: 3, x: 0, y: 0));
    expect(TileCode.fromBinaryString('0b100111'), TileCode(zoom: 3, x: 5, y: 3));
    expect(TileCode.fromBinaryString('0b011000'), TileCode(zoom: 3, x: 2, y: 4));
    // exception
    expect(() => TileCode.fromBinaryString('2'), throwsA(isA<FormatException>()));
    expect(() => TileCode.fromBinaryString('0'), throwsA(isA<FormatException>()));
    expect(() => TileCode.fromBinaryString('a'), throwsA(isA<FormatException>()));
  });
}
