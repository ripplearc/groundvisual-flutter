import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/component/machine_status/machine_avatar.dart';
import 'package:groundvisual_flutter/models/machine_online_status.dart';

/// Display the machines that take photos and how much photos available for download.
class TimelinePhotoDownloader extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
        children: [
          MachineAvatar(
              machineName: "321",
              onlineStatusStream: Stream<MachineOnlineStatus>.value(
                  MachineOnlineStatus(OnlineStatus.unknown, null))),
          TextButton.icon(
              icon: Icon(Icons.download_outlined,
                  color: Theme.of(context).colorScheme.primary),
              label: Text("[322 photos]"),
              onPressed: () {})
        ],
      );
}
