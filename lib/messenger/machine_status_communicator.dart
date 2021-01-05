import 'package:groundvisual_flutter/models/machine_online_status.dart';
import 'package:injectable/injectable.dart';

/// Query the online status of the machine. It tries to establish
/// a realtime beacon from the device. Otherwise it will query the database
/// the last time the device is online.
abstract class MachineStatusCommunicator {
  Stream<MachineOnlineStatus> getMachineOnlineStatus(String machine);
}

@Injectable(as: MachineStatusCommunicator)
class MachineStatusCommunicatorImpl extends MachineStatusCommunicator {
  @override
  Stream<MachineOnlineStatus> getMachineOnlineStatus(String machine) async* {
    yield MachineOnlineStatus(OnlineStatus.connecting, null);
    await Future.delayed(Duration(seconds: 4));
    switch (machine) {
      case "332":
        yield MachineOnlineStatus(
            OnlineStatus.offline, DateTime.now().subtract(Duration(hours: 2)));
        break;
      default:
        yield MachineOnlineStatus(OnlineStatus.online, null);
    }
  }
}
