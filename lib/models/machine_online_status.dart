import 'package:flutter/cupertino.dart';
import 'package:dart_date/dart_date.dart';

/// Data model represents the online status of a machine or when it has been offline
@immutable
class MachineOnlineStatus {
  final OnlineStatus status;
  final DateTime offlineSince;

  MachineOnlineStatus(this.status, this.offlineSince);

  String offlineFormattedString() {
    if (offlineSince.differenceInDays(DateTime.now()).abs() > 1) {
      return offlineSince.differenceInDays(DateTime.now()).abs().toString() +
          "d";
    } else if (offlineSince.differenceInHours(DateTime.now()).abs() > 1) {
      return offlineSince.differenceInHours(DateTime.now()).abs().toString() +
          "h";
    } else if (offlineSince.differenceInMinutes(DateTime.now()).abs() > 1) {
      return offlineSince.differenceInMinutes(DateTime.now()).abs().toString() +
          "m";
    } else {
      return offlineSince.differenceInSeconds(DateTime.now()).abs().toString() +
          "s";
    }
  }
}

enum OnlineStatus { online, offline, connecting }
