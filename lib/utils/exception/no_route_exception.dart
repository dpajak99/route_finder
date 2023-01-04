class NoRouteException implements Exception {
  final String? message;

  NoRouteException([this.message]);
  
  @override
  String toString() {
    return message ?? '';
  }
}