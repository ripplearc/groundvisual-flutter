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

  const SelectedSiteAtDate(this.siteName, this.date);

  @override
  List<Object> get props => [siteName, date];

  @override
  String toString() =>
      'SelectedSiteAtDay { name: $siteName, day: ${date.day} }';
}

class SelectedSiteAtWindow extends SelectedSiteState {
  final String siteName;
  final DateTimeRange dateRange;

  const SelectedSiteAtWindow(this.siteName, this.dateRange);

  @override
  List<Object> get props => [siteName, dateRange];

  @override
  String toString() =>
      'SelectedSteAtWindow { name: $siteName, ' +
      ' start day: ${dateRange.start.day},' +
      ' end day: ${dateRange.end.day} }';
}
