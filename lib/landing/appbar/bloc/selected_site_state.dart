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
  final WorkingTimeChartData chartData;

  const SelectedSiteAtDate(this.siteName, this.date, {this.chartData});

  @override
  List<Object> get props => [siteName, date, chartData];

  @override
  String toString() =>
      'SelectedSiteAtDay { name: $siteName, day: ${date.day} }';
}

class SelectedSiteAtTrend extends SelectedSiteState {
  final String siteName;
  final DateTimeRange dateRange;
  final TrendPeriod period;

  const SelectedSiteAtTrend(this.siteName, this.dateRange, this.period);

  @override
  List<Object> get props => [siteName, dateRange, period];

  @override
  String toString() =>
      'SelectedSteAtWindow { name: $siteName, ' +
      ' start day: ${dateRange.start.day},' +
      ' end day: ${dateRange.end.day} }' +
      'period: $period';
}
