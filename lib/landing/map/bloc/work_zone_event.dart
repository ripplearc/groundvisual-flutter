part of 'work_zone_bloc.dart';

@immutable
abstract class WorkZoneEvent extends Equatable {}

/// Select a time interval to query the work zone.
class SearchWorkZoneAtTime extends WorkZoneEvent {
  final String site;
  final DateTime startTime;
  final DateTime endTime;
  final Map<MachineDetail, bool>? filteredMachines;

  SearchWorkZoneAtTime(this.site, this.startTime, this.endTime,
      {this.filteredMachines});

  @override
  List<Object> get props => [site, startTime, endTime];
}

/// Select a date to query the work zone.
class SearchWorkZoneOnDate extends WorkZoneEvent {
  final String site;
  final DateTime date;

  SearchWorkZoneOnDate(this.site, this.date);

  @override
  List<Object> get props => [site, date];
}

/// Select a period to query the work zone.
class SearchWorkZoneAtPeriod extends WorkZoneEvent {
  final String site;
  final DateTime date;
  final TrendPeriod period;

  SearchWorkZoneAtPeriod(this.site, this.date, this.period);

  @override
  List<Object> get props => [site, date, period];
}
