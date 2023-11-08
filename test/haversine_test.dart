import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart' as map;
import 'package:path_finder/utils/algorithms/haversine.dart';
import 'package:path_finder/utils/models/distance.dart';

void main() {
  test('Z -> A', () {
    Distance distance = Distance(meters: 1400);
    
    map.LatLng actualOrigin = map.LatLng(50.010278, 20.986553);
    map.LatLng actualSource = Haversine.findLatLngInDistance(actualOrigin, distance, 266);
    map.LatLng expectedSource = map.LatLng(50.009398, 20.96701);
    
    expect(actualSource, expectedSource);
    
    expect(Haversine.calcDistance(actualOrigin, actualSource).inMeters, distance.inMeters);
  });

  test('Z -> B', () {
    Distance distance = Distance(meters: 1200);

    map.LatLng actualOrigin = map.LatLng(50.010278, 20.986553);
    map.LatLng actualSource = Haversine.findLatLngInDistance(actualOrigin, distance, 272);
    map.LatLng expectedSource = map.LatLng(50.010653, 20.96977);
    
    expect(actualSource, expectedSource);

    expect(Haversine.calcDistance(actualOrigin, actualSource).inMeters, distance.inMeters);
  });

  test('Z -> C', () {
    Distance distance = Distance(meters: 1100);

    map.LatLng actualOrigin = map.LatLng(50.010278, 20.986553);
    map.LatLng actualSource = Haversine.findLatLngInDistance(actualOrigin, distance, 255);
    map.LatLng expectedSource = map.LatLng(50.007717, 20.971685);

    expect(actualSource, expectedSource);

    expect(Haversine.calcDistance(actualOrigin, actualSource).inMeters, distance.inMeters);
  });

  test('Z -> D', () {
    Distance distance = Distance(meters: 600);

    map.LatLng actualOrigin = map.LatLng(50.010278, 20.986553);
    map.LatLng actualSource = Haversine.findLatLngInDistance(actualOrigin, distance, 225);
    map.LatLng expectedSource = map.LatLng(50.006462, 20.980616);

    expect(actualSource, expectedSource);

    expect(Haversine.calcDistance(actualOrigin, actualSource).inMeters, distance.inMeters);
  });

  test('Z -> E', () {
    Distance distance = Distance(meters: 400);

    map.LatLng actualOrigin = map.LatLng(50.010278, 20.986553);
    map.LatLng actualSource = Haversine.findLatLngInDistance(actualOrigin, distance, 240);
    map.LatLng expectedSource = map.LatLng(50.008479, 20.981706);

    expect(actualSource, expectedSource);

    expect(Haversine.calcDistance(actualOrigin, actualSource).inMeters, distance.inMeters);
  });

  test('Z -> F', () {
    Distance distance = Distance(meters: 1100);

    map.LatLng actualOrigin = map.LatLng(50.010278, 20.986553);
    map.LatLng actualSource = Haversine.findLatLngInDistance(actualOrigin, distance, 315);
    map.LatLng expectedSource = map.LatLng(50.017273, 20.975667);

    expect(actualSource, expectedSource);

    expect(Haversine.calcDistance(actualOrigin, actualSource).inMeters, distance.inMeters);
  });
}