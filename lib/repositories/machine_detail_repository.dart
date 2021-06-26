import 'package:groundvisual_flutter/models/machine_detail.dart';
import 'package:injectable/injectable.dart';

abstract class MachineDetailRepository {
  Future<MachineDetail> getMachineDetail(String muid);
}

@LazySingleton(as: MachineDetailRepository)
class MachineDetailRepositoryImpl extends MachineDetailRepository {
  @override
  Future<MachineDetail> getMachineDetail(String muid) {
    switch (muid) {
      case "3EF7447C-6FD9-4180-919B-3ACF09915CDB":
        return Future.value(
            MachineDetail("3EF7447C-6FD9-4180-919B-3ACF09915CDB", "CAT321", 2019, "Caterpillar", "3201"));
      case "186204B5-E8E7-49AA-BEC7-FFF6A2D6DAA2":
        return Future.value(
            MachineDetail("186204B5-E8E7-49AA-BEC7-FFF6A2D6DAA2", "CAT332", 2010, "Caterpillar", "3202"));
      case "82CC0FDD-1E38-48C4-9109-BE34358796CD":
        return Future.value(
            MachineDetail("82CC0FDD-1E38-48C4-9109-BE34358796CD", "CAT332", 2020, "Caterpillar", "3203"));
      default:
        throw Exception("$muid does not exist!}");
    }
  }
}
