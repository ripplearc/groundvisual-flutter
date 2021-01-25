part of 'work_zone_map_bloc.dart';

@immutable
abstract class WorkZoneMapEvent extends Equatable {}

/// Select a time interval of 15 mins to query the work zone.
class SelectWorkZoneAtTime extends WorkZoneMapEvent {
  final String site;
  final DateTime time;
  final BuildContext context;

  SelectWorkZoneAtTime(this.site, this.time, this.context);

  @override
  List<Object> get props => [site, time];
}

/// Select a date to query the work zone.
class SearchWorkZoneOnDate extends WorkZoneMapEvent {
  final String site;
  final DateTime date;
  final BuildContext context;

  SearchWorkZoneOnDate(this.site, this.date, this.context);

  @override
  List<Object> get props => [site, date];
}

/// Select a period to query the work zone.
class SelectWorkZoneAtPeriod extends WorkZoneMapEvent {
  final String site;
  final DateTime date;
  final TrendPeriod period;
  final BuildContext context;

  SelectWorkZoneAtPeriod(this.site, this.date, this.period, this.context);

  @override
  List<Object> get props => [site, date, period];
}
