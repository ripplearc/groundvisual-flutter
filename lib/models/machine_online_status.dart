import 'package:dart_date/dart_date.dart';
import 'package:flutter/widgets.dart';
import 'package:groundvisual_flutter/extensions/scoped.dart';

/// Data model represents the online status of a machine or when it has been offline
@immutable
class MachineOnlineStatus {
  final OnlineStatus status;
  final DateTime? offlineSince;

  MachineOnlineStatus(this.status, this.offlineSince);

  String offlineFormattedString() {
    return offlineSince?.let((since) {
          if (since.differenceInDays(DateTime.now()).abs() > 1) {
            return since.differenceInDays(DateTime.now()).abs().toString() +
                "d";
          } else if (since.differenceInHours(DateTime.now()).abs() > 1) {
            return since.differenceInHours(DateTime.now()).abs().toString() +
                "h";
          } else if (since.differenceInMinutes(DateTime.now()).abs() > 1) {
            return since.differenceInMinutes(DateTime.now()).abs().toString() +
                "m";
          } else {
            return since.differenceInSeconds(DateTime.now()).abs().toString() +
                "s";
          }
        }) ??
        "";
  }
}

enum OnlineStatus { online, offline, connecting, unknown }
