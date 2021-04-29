import 'package:flutter/cupertino.dart';
import 'package:groundvisual_flutter/component/machine_status/machine_offline_indication.dart';
import 'package:groundvisual_flutter/component/machine_status/machine_online_indication.dart';
import 'package:groundvisual_flutter/models/machine_online_status.dart';

import 'machine_label.dart';

/// Machine icon with online status. The status reacts to the stream that reflects
/// the machine status in real time.
class MachineAvatar extends StatelessWidget {
  final String machineName;

  final Stream<MachineOnlineStatus> onlineStatusStream;

  const MachineAvatar(
      {Key? key, required this.machineName, required this.onlineStatusStream})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      _genMachineLabelWithStatus(context, machineName, onlineStatusStream);

  Stack _genMachineLabelWithStatus(BuildContext context, String machineName,
          Stream<MachineOnlineStatus> onlineStatusStream) =>
      Stack(
        children: [
          Container(child: SizedBox.fromSize(size: Size(58, 58))),
          MachineLabel(
              name: machineName,
              labelSize: Size(56, 56),
              shadowTopLeftOffset: Size(1, 1)),
          StreamBuilder(
              stream: onlineStatusStream,
              builder: (BuildContext context,
                  AsyncSnapshot<MachineOnlineStatus> snapshot) {
                if (snapshot.hasData) {
                  return _genIndication(
                      snapshot.data ??
                          MachineOnlineStatus(OnlineStatus.unknown, null),
                      context);
                } else if (snapshot.hasError) {
                  return _genIndication(
                      MachineOnlineStatus(OnlineStatus.unknown, null), context);
                } else {
                  return Container();
                }
              })
        ],
      );

  Widget _genIndication(MachineOnlineStatus status, BuildContext context) {
    switch (status.status) {
      case OnlineStatus.offline:
        return MachineOfflineIndication(
            offset: Size(0, 0), warning: status.offlineFormattedString());
      case OnlineStatus.unknown:
        return MachineOfflineIndication(offset: Size(0, 0), warning: "?!");
      case OnlineStatus.online:
        return MachineOnlineIndication(
            rightBottomOffset: Size(0, 0), shimming: false);
      default:
        return MachineOnlineIndication(
            rightBottomOffset: Size(0, 0), shimming: true);
    }
  }
}
