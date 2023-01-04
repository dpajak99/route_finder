import 'package:path_finder/infra/dto/vehicle_edge_dto.dart';
import 'package:path_finder/infra/repository/edge_repository.dart';
import 'package:path_finder/infra/service/stop_service.dart';
import 'package:path_finder/utils/models/edge/vehicle_edge.dart';
import 'package:path_finder/utils/models/vertex/stop_vertex.dart';

class EdgeService {
  final StopService stopService = StopService();
  final EdgeRepository edgeRepository = EdgeRepository();

  Future<List<VehicleEdge>> getEdgesList(List<StopVertex> vertexList, DateTime dateTime) async {
    int minutes = 60 * dateTime.hour + dateTime.minute;
    List<VehicleEdgeDto> edgesEntityList = await edgeRepository.getAllVehicleEdges(minutes);
    List<VehicleEdge> vehicleEdgeModelList = List<VehicleEdge>.empty(growable: true);
    for (VehicleEdgeDto vehicleEdgeDto in edgesEntityList) {
      StopVertex fromStopVertex = vertexList.where((StopVertex e) => e.id == vehicleEdgeDto.from.toString()).first;
      StopVertex toStopVertex = vertexList.where((StopVertex e) => e.id == vehicleEdgeDto.to.toString()).first;
      vehicleEdgeModelList.add(VehicleEdge(
        sourceVertex: fromStopVertex,
        targetVertex: toStopVertex,
        departureTime: vehicleEdgeDto.timeInMin,
        trackId: vehicleEdgeDto.trackId,
        busName: vehicleEdgeDto.busName,
        timeFromNow: vehicleEdgeDto.timeFromNow,
        timeToNextStop: vehicleEdgeDto.timeToNextStop,
      ));
    }
    return vehicleEdgeModelList;
  }
}
