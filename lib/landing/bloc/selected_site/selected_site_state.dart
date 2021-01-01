part of 'selected_site_bloc.dart';

abstract class SelectedSiteState extends Equatable {
  const SelectedSiteState();

  @override
  List<Object> get props => [];
}

abstract class BasicSelectedSite extends SelectedSiteState {
  const BasicSelectedSite();
}

abstract class MachineStatusAtSelectedSite extends SelectedSiteState {
  const MachineStatusAtSelectedSite();
}

class SelectedSiteEmpty extends BasicSelectedSite {}

class SelectedSiteAtDate extends BasicSelectedSite {
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

class SelectedSiteAtTrend extends BasicSelectedSite {
  final String siteName;
  final DateTimeRange dateRange;
  final TrendPeriod period;
  final WorkingTimeChartData chartData;

  const SelectedSiteAtTrend(this.siteName, this.dateRange, this.period,
      {this.chartData});

  @override
  List<Object> get props => [siteName, dateRange, period, chartData];

  @override
  String toString() =>
      'SelectedSteAtWindow { name: $siteName, ' +
      ' start day: ${dateRange.start.day},' +
      ' end day: ${dateRange.end.day} }' +
      'period: $period';
}

class MachineInitialStatusAtSelectedSite extends MachineStatusAtSelectedSite {}

class WorkingTimeAtSelectedSite extends MachineStatusAtSelectedSite {
  final Map<String, UnitWorkingTime> workingTimes;

  WorkingTimeAtSelectedSite(this.workingTimes);

  @override
  List<Object> get props => [workingTimes];
}
