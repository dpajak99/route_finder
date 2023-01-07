import 'dart:convert';

import 'package:path_finder/infra/dto/google_api/response/get_directions_response.dart';
import 'package:path_finder/infra/repository/google_repository.dart';
import 'package:path_finder/utils/file_utils.dart';

class AssetsGoogleRepository extends GoogleRepository {
  List<GetDirectionsResponse>? cachedDirectionsResponse;
  
  @override
  Future<List<GetDirectionsResponse>> getAll() async {
    if( cachedDirectionsResponse != null ) {
      return cachedDirectionsResponse!;
    }
    String assetsEdges = await FileUtils.readAssetFile('google_directions_2.json');
    List<Map<String, dynamic>> directionsMap = (jsonDecode(assetsEdges) as List<dynamic>).map((dynamic e) => e as Map<String, dynamic>).toList();
    List<GetDirectionsResponse> directionsResponse = directionsMap.map(GetDirectionsResponse.fromAssetsJson).toList();
    cachedDirectionsResponse = directionsResponse;
    return directionsResponse;
  }
}