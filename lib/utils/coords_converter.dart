class CoordsConverter {
  // Latitude: 50.012100
  // Longitude: 20.985842
  // DMS Long: 20° 59' 9.0312'' E
  // DMS Lat: 50° 0' 43.5600'' N
  
  static List<num> convert(double coord) {
    int degrees = coord.truncate();
    double minutesNotTruncated = (coord - degrees) * 60;
    int minutes = minutesNotTruncated.truncate();
    double seconds = (minutesNotTruncated - minutes) * 60;
    return <num>[degrees, minutes, double.parse(seconds.toStringAsFixed(4))];
  }

  static double convertBack(List<int> dmsCoord) {
    return dmsCoord[0] + dmsCoord[1] / 60 + dmsCoord[2] / 3600;
  }
}