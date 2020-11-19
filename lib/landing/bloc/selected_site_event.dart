part of 'selected_site_bloc.dart';

abstract class SelectedSiteDateTimeEvent extends Equatable {
  const SelectedSiteDateTimeEvent();
}

class SiteSelected extends SelectedSiteDateTimeEvent {
  final String siteName;

  const SiteSelected(this.siteName);

  @override
  List<Object> get props => throw [siteName];
}

class DateSelected extends SelectedSiteDateTimeEvent {
  final DateTime day;

  const DateSelected(this.day);

  @override
  List<Object> get props => throw [day];
}

class TrendSelected extends SelectedSiteDateTimeEvent {
  final LengthOfTrendAnalysis numberOfLastDays;

  const TrendSelected(this.numberOfLastDays);

  @override
  List<Object> get props => throw [numberOfLastDays];
}

enum LengthOfTrendAnalysis { oneWeek, twoWeeks, oneMonth, twoMonths }
