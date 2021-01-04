import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

/// data model the represents the working and idling time in a certain duration.
@immutable
class UnitWorkingTime extends Equatable {
  final int durationInSeconds;
  final int workingInSeconds;
  final int idlingInSeconds;

  UnitWorkingTime(
      this.durationInSeconds, this.workingInSeconds, this.idlingInSeconds);

  double workingInHours() => workingInSeconds / 3600.0;

  String workingInFormattedHours() =>
      workingInHours().toStringAsFixed(1) + " hrs";

  double idlingInHours() => idlingInSeconds / 3600.0;

  String idlingInFormattedHours() =>
      idlingInHours().toStringAsFixed(1) + " hrs";

  double durationInHours() => durationInSeconds / 3600.0;

  String durationInFormattedHours() =>
      durationInHours().toStringAsFixed(1) + " hrs";

  @override
  List<Object> get props =>
      [durationInSeconds, workingInSeconds, idlingInSeconds];
}
