part of 'selected_site_bloc.dart';

abstract class SelectedSiteDateTimeEvent extends Equatable {
  final BuildContext context;

  const SelectedSiteDateTimeEvent(this.context);
}

class SelectedSiteInit extends SelectedSiteDateTimeEvent {
  SelectedSiteInit(BuildContext context) : super(context);

  @override
  List<Object> get props => [];
}

class SiteSelected extends SelectedSiteDateTimeEvent {
  final String siteName;

  const SiteSelected(this.siteName, BuildContext context) : super(context);

  @override
  List<Object> get props => [siteName];
}

class DateSelected extends SelectedSiteDateTimeEvent {
  final DateTime date;

  const DateSelected(this.date, BuildContext context) : super(context);

  @override
  List<Object> get props => [date];
}

class TrendSelected extends SelectedSiteDateTimeEvent {
  final TrendPeriod period;

  const TrendSelected(this.period, BuildContext context) : super(context);

  @override
  List<Object> get props => [period];
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

  int toInt() {
    switch (this) {
      case TrendPeriod.oneWeek:
        return 7;
      case TrendPeriod.twoWeeks:
        return 14;
      case TrendPeriod.oneMonth:
        return 30;
      case TrendPeriod.twoMonths:
        return 60;
    }
    throw ArgumentError('$this is not a valid Trend Period');
  }
}
