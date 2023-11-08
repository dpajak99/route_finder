import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_finder/utils/google_coords_utils.dart';

void main() {
  test('calculate', () {
    expect(
      GoogleCoordsUtils.decodePolyline('q|dpHg_rxBaBq@@SyWeLq@e@wCiA}JiEkJgEeEaB'),
      <LatLng>[
        LatLng(50.00153, 19.92196),
        LatLng(50.00202, 19.92221),
        LatLng(50.00201, 19.92231),
        LatLng(50.00598, 19.92442),
        LatLng(50.00623, 19.92461),
        LatLng(50.00699, 19.92498),
        LatLng(50.0089, 19.92599),
        LatLng(50.01072, 19.92699),
        LatLng(50.01171, 19.92748)
      ],
    );
  });

  test('', () {
    expect(
      GoogleCoordsUtils.encodePolyline(
        <LatLng>[
          LatLng(50.00153, 19.92196),
          LatLng(50.00202, 19.92221),
          LatLng(50.00201, 19.92231),
          LatLng(50.00598, 19.92442),
          LatLng(50.00623, 19.92461),
          LatLng(50.00699, 19.92498),
          LatLng(50.0089, 19.92599),
          LatLng(50.01072, 19.92699),
          LatLng(50.01171, 19.92748)
        ],
      ),
      'q|dpHg_rxBaBq@@SyWeLq@e@wCiA}JiEkJgEeEaB',
    );
  });
}
