import 'dart:convert';
import 'dart:math' as math;

import 'package:latlong2/latlong.dart';

class GoogleCoordsUtils {
  static String encodePoint(num current, {num previous = 0, int accuracyExponent = 5}) {
    if (accuracyExponent < 1) {
      throw ArgumentError.value(accuracyExponent, 'accuracyExponent', 'Location accuracy exponent cannot be less than 1');
    }

    if (accuracyExponent > 9) {
      throw ArgumentError.value(accuracyExponent, 'accuracyExponent', 'Location accuracy exponent cannot be greater than 9');
    }

    final num accuracyMultiplier = math.pow(10, accuracyExponent);

    int curr = (current * accuracyMultiplier + 0.5).floor();
    int prev = (previous * accuracyMultiplier + 0.5).floor();
    int value = curr - prev;

    /// Left-shift the `value` for one bit.
    value <<= 1;
    if (curr - prev < 0) {
      /// Inverting `value` if it is negative.
      value = ~value;
    }

    StringBuffer point = StringBuffer();

    /// Iterating while value is grater or equal of `32-bits` size
    while (value >= 0x20) {
      /// `AND` each `value` with `0x1f` to get 5-bit chunks.
      /// Then `OR` each `value` with `0x20` as per algorithm.
      /// Then add `63` to each `value` as per algorithm.
      point.write(String.fromCharCodes(<int>[(0x20 | (value & 0x1f)) + 63]));

      /// Rigth-shift the `value` for 5 bits
      value >>= 5;
    }

    point.write(ascii.decode(<int>[value + 63]));

    return point.toString();
  }

  /// Encodes `List<List<num>>` of [coordinates] into a `String` via
  /// [Encoded Polyline Algorithm Format](https://developers.google.com/maps/documentation/utilities/polylinealgorithm?hl=en)
  ///
  /// For mode detailed info about encoding refer to [encodePoint].
  static String encodePolyline(List<LatLng> coordinates, {int accuracyExponent = 5}) {
    if (accuracyExponent < 1) {
      throw ArgumentError.value(accuracyExponent, 'accuracyExponent', 'Location accuracy exponent cannot be less than 1');
    }

    if (accuracyExponent > 9) {
      throw ArgumentError.value(accuracyExponent, 'accuracyExponent', 'Location accuracy exponent cannot be greater than 9');
    }

    if (coordinates.isEmpty) {
      return '';
    }

    StringBuffer polyline = StringBuffer(encodePoint(coordinates[0].latitude, accuracyExponent: accuracyExponent) + encodePoint(coordinates[0].longitude, accuracyExponent: accuracyExponent));

    for (int i = 1; i < coordinates.length; i++) {
      polyline.write(encodePoint(coordinates[i].latitude, previous: coordinates[i - 1].latitude, accuracyExponent: accuracyExponent));
      polyline.write(encodePoint(coordinates[i].longitude, previous: coordinates[i - 1].longitude, accuracyExponent: accuracyExponent));
    }

    return polyline.toString();
  }

  /// Decodes [polyline] `String` via inverted
  /// [Encoded Polyline Algorithm](https://developers.google.com/maps/documentation/utilities/polylinealgorithm?hl=en)
  static List<LatLng> decodePolyline(String polyline, {int accuracyExponent = 5}) {
    final num accuracyMultiplier = math.pow(10, accuracyExponent);
    final List<LatLng> coordinates = <LatLng>[];

    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < polyline.length) {
      int char;
      int shift = 0;
      int result = 0;

      /// Method for getting **only** `1` coorditane `latitude` or `longitude` at a time
      int getCoordinate() {
        /// Iterating while value is grater or equal of `32-bits` size
        do {
          /// Substract `63` from `codeUnit`.
          char = polyline.codeUnitAt(index++) - 63;

          /// `AND` each `char` with `0x1f` to get 5-bit chunks.
          /// Then `OR` each `char` with `result`.
          /// Then left-shift for `shift` bits
          result |= (char & 0x1f) << shift;
          shift += 5;
        } while (char >= 0x20);

        /// Inversion of both:
        ///
        ///  * Left-shift the `value` for one bit
        ///  * Inversion `value` if it is negative
        final int value = result >> 1;
        final int coordinateChange = (result & 1) != 0 ? (~BigInt.from(value)).toInt() : value;

        /// It is needed to clear `shift` and `result` for next coordinate.
        shift = result = 0;

        return coordinateChange;
      }

      lat += getCoordinate();
      lng += getCoordinate();

      coordinates.add(LatLng(lat / accuracyMultiplier, lng / accuracyMultiplier));
    }

    return coordinates;
  }
}
