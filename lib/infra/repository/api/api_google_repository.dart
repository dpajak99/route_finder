import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:path_finder/infra/dto/google_api/request/get_directions_request.dart';
import 'package:path_finder/infra/dto/google_api/response/get_directions_response.dart';
import 'package:path_finder/infra/repository/google_repository.dart';
import 'package:path_finder/infra/service/graph_service.dart';
import 'package:path_finder/utils/api_manager.dart';
import 'package:path_finder/utils/file_utils.dart';
import 'package:path_finder/utils/models/edge/transit_edge.dart';
import 'package:path_finder/utils/models/edge/walk_edge.dart';
import 'package:path_finder/utils/models/graph/multi_graph.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class ApiGoogleRepository extends GoogleRepository {
  final ApiManager apiManager = ApiManager();
  final GraphService graphService = GraphService();
  
  @override
  Future<List<GetDirectionsResponse>> getAll() async {
    final MultiGraph<StopVertex, TransitEdge> graph = await graphService.getFullTransitsGraph(0);
    final List<TransitEdge> transitEdges = graph.edges;
    final List<WalkEdge> walkEdges = transitEdges.whereType<WalkEdge>().map((TransitEdge e) => e as WalkEdge).toList();
    
    List<Map<String, dynamic>> result = <Map<String, dynamic>>[];
    int i = 0;
    for (WalkEdge walkEdge in walkEdges) {
      i++;
      if (i % 100 == 0) {
        await _saveEdgesToLocalFile(result);
      }
      try {
        GetDirectionsResponse getDirectionsResponse = await getDirections(
          GetDirectionsRequest(
            origin: walkEdge.sourceVertex,
            destination: walkEdge.targetVertex,
          ),
        );
        result.add(getDirectionsResponse.toJson(walkEdge));
      } catch (e) {
        print('Error for walkEdge: ${walkEdge.sourceVertex.id} -> ${walkEdge.targetVertex.id} ($e)');
      }
    }
    await _saveEdgesToLocalFile(result);
    List<GetDirectionsResponse> getDirectionsResponses = result.map(GetDirectionsResponse.fromAssetsJson).toList();
    return getDirectionsResponses;
  }

  Future<GetDirectionsResponse> getDirections(GetDirectionsRequest getDirectionsRequest) async {
    final Response<dynamic> response = await apiManager.post<dynamic>(
      networkUri: Uri.parse('https://routes.googleapis.com'),
      path: '/directions/v2:computeRoutes',
      headers: <String, dynamic>{
        'X-Goog-Api-Key': 'YOUR API KEY',
        'X-Goog-FieldMask': 'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline',
      },
      body: getDirectionsRequest.toJson(),
    );

    return GetDirectionsResponse.fromApiJson(
      response.data as Map<String, dynamic>,
      getDirectionsRequest.origin.id,
      getDirectionsRequest.destination.id,
    );
  }

  Future<void> _saveEdgesToLocalFile(List<Map<String, dynamic>> result) async {
    await FileUtils.writeLocalFile('google_directions_2.json', jsonEncode(result));
  }
}
