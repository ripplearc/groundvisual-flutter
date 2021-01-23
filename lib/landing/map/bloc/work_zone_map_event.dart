part of 'work_zone_map_bloc.dart';

@immutable
abstract class WorkZoneMapEvent extends Equatable {}

class SelectWorkZoneAtTime extends WorkZoneMapEvent {
  final String site;
  final DateTime time;
  final BuildContext context;

  SelectWorkZoneAtTime(this.site, this.time, this.context);

  @override
  List<Object> get props => [site, time];
}

class SelectWorkZoneAtDate extends WorkZoneMapEvent {
  final String site;
  final DateTime date;
  final BuildContext context;

  SelectWorkZoneAtDate(this.site, this.date, this.context);

  @override
  List<Object> get props => [site, date];
}

class SelectWorkZoneAtPeriod extends WorkZoneMapEvent {
  final String site;
  final DateTime date;
  final TrendPeriod period;
  final BuildContext context;

  SelectWorkZoneAtPeriod(this.site, this.date, this.period, this.context);

  @override
  List<Object> get props => [site, date];
}
