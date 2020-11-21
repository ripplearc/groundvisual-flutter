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
  final TrendPeriod period;

  const TrendSelected(this.period);

  @override
  List<Object> get props => throw [period];
}

enum TrendPeriod { oneWeek, twoWeeks, oneMonth, twoMonths }

extension Value on TrendPeriod {
  String value() {
    switch (this) {
      case TrendPeriod.oneWeek:
        return "Last 7 days";
      case TrendPeriod.twoWeeks:
        return "Last 14 days";
      case TrendPeriod.oneMonth:
        return "Last 30 days";
      case TrendPeriod.twoMonths:
        return "Last 60 days";
    }
    throw ArgumentError('$this is not a valid Trend Period');
  }
}
