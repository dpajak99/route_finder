class TimeUtils {
  static String minutesToString(num minutes) {
    int hours = minutes ~/ 60;
    int minutesLeft = minutes.toInt() % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutesLeft.toString().padLeft(2, '0')}';
  }

  static String secondsToString(num seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds ~/ 60) % 60;
    int secondsLeft = seconds.toInt() % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secondsLeft.toString().padLeft(2, '0')}';
  }
  
  static String millisecondsToString(num milliseconds) {
    int hours = milliseconds ~/ 3600000;
    int minutes = (milliseconds ~/ 60000) % 60;
    int seconds = (milliseconds ~/ 1000) % 60;
    int millisecondsLeft = milliseconds.toInt() % 1000;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${millisecondsLeft.toString().padLeft(3, '0')}';
  }
}