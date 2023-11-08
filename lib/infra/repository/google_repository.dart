import 'package:path_finder/infra/dto/google_api/response/get_directions_response.dart';

abstract class GoogleRepository {
  Future<List<GetDirectionsResponse>> getAll();
}
