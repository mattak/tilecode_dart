<!--
Reference:
- [writing package pages](https://dart.dev/guides/libraries/writing-package-pages).
- [creating packages](https://dart.dev/guides/libraries/create-library-packages)
- [developing packages and plugins](https://flutter.dev/developing-packages).
-->

tileccode_dart is [tilecode](https://github.com/mattak/tilecode) implementation by dart.
tilecode is one of the format to represent lat/lng area of earth map.
The code is equivalent to map tile's zoom/x/y format.

## Features

* Encode zoom/x/y to hex/binary tilecode.
* Encode zoom,latitude,longitude to hex/binary tilecode.
* Decode hex/binary tilecode to zoom/x/y.
* Decode hex/binary tilecode to center latitude,longitude of the tile.
* Decode hex/binary tilecode to start latitude,longitude of the tile.

## Getting started

Installation

```
flutter pub get tilecode
```

## Usage

```dart
import 'package:tilecode/tilecode.dart';

// encode hex,binary tilecode to string
print(TileCode(zoom: 10, x: 3, y: 10).toHexString(true)); // 0x0004e
print(TileCode(zoom: 10, x: 3, y: 10).toBinaryString(true)) // 0b00000000000001001110

// decode hex,binary tilecode from string
final tilecodeByHex = TileCode.fromHexString("0x0004e");
final tilecodeByBinary = TileCode.fromHexString("0b");

// get start/center location of the tile
final tileStart = TileCode(zoom: 10, 3, 10).getLocationStart(); // 84.73838712095339,-178.9453125
final tileCenter = TileCode(zoom: 10, 3, 10).getLocationCenter(); // 84.7222427259026,-178.76953125
```

## Additional information

LICENSE: MIT