import 'package:flutter/cupertino.dart';

/// data model the represents the working and idling time in a certain duration.
@immutable
class UnitWorkingTime {
  final int durationInMinutes;
  final int workingInMinutes;
  final int idlingInMinutes;

  UnitWorkingTime(
      this.durationInMinutes, this.workingInMinutes, this.idlingInMinutes);

  double workingInHours() => workingInMinutes / 60.0;

  String workingInFormattedHours() =>
      workingInHours().toStringAsFixed(1) + " hrs";

  double idlingInHours() => idlingInMinutes / 60.0;

  String idlingInFormattedHours() => idlingInHours().toStringAsFixed(1) + " hrs";

  double durationInHours() => durationInMinutes / 60.0;

  String durationInFormattedHours() =>
      durationInHours().toStringAsFixed(1) + " hrs";
}
