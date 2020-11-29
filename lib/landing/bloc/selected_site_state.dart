part of 'selected_site_bloc.dart';

abstract class SelectedSiteState extends Equatable {
  const SelectedSiteState();

  @override
  List<Object> get props => [];
}

class SelectedSiteEmpty extends SelectedSiteState {}

class SelectedSiteAtDate extends SelectedSiteState {
  final String siteName;
  final DateTime date;
  final WorkingTimeDailyChartData dailyChart;

  const SelectedSiteAtDate(this.siteName, this.date, {this.dailyChart});

  @override
  List<Object> get props => [siteName, date, dailyChart];

  @override
  String toString() =>
      'SelectedSiteAtDay { name: $siteName, day: ${date.day} }';
}

class SelectedSiteAtWindow extends SelectedSiteState {
  final String siteName;
  final DateTimeRange dateRange;
  final TrendPeriod period;

  const SelectedSiteAtWindow(this.siteName, this.dateRange, this.period);

  @override
  List<Object> get props => [siteName, dateRange];

  @override
  String toString() =>
      'SelectedSteAtWindow { name: $siteName, ' +
      ' start day: ${dateRange.start.day},' +
      ' end day: ${dateRange.end.day} }' +
      'period: $period';
}
