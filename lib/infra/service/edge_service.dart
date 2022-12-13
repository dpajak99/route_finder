import 'package:path_finder/infra/dto/vehicle_edge_dto.dart';
import 'package:path_finder/infra/repository/edge_repository.dart';
import 'package:path_finder/infra/service/stop_service.dart';
import 'package:path_finder/utils/models/edge/vehicle_edge.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class EdgeService {
  final StopService stopService = StopService();
  final EdgeRepository edgeRepository = EdgeRepository();

  Future<List<VehicleEdge>> getEdgesList(List<StopVertex> vertexList) async {
    List<VehicleEdgeDto> edgesEntityList = await edgeRepository.getAllVehicleEdges();
    List<VehicleEdge> vehicleEdgeModelList = List<VehicleEdge>.empty(growable: true);
    for (VehicleEdgeDto vehicleEdgeDto in edgesEntityList) {
      StopVertex fromStopVertex = vertexList.where((StopVertex e) => e.id == vehicleEdgeDto.from.toString()).first;
      StopVertex toStopVertex = vertexList.where((StopVertex e) => e.id == vehicleEdgeDto.to.toString()).first;
      vehicleEdgeModelList.add(VehicleEdge(
        fromVertex: fromStopVertex,
        toVertex: toStopVertex,
        trackId: vehicleEdgeDto.trackId,
        timeFromNow: vehicleEdgeDto.timeFromNow,
        timeToNextStop: vehicleEdgeDto.timeToNextStop,
      ));
    }
    vehicleEdgeModelList.sort((VehicleEdge a, VehicleEdge b) => a.timeFromNow.compareTo(b.timeFromNow));
    return vehicleEdgeModelList;
  }
}
