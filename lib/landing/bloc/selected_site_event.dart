part of 'selected_site_bloc.dart';

abstract class SelectedSiteEvent extends Equatable {
  const SelectedSiteEvent();
}

class SiteSelected extends SelectedSiteEvent {
  final String siteName;

  const SiteSelected(this.siteName);

  @override
  List<Object> get props => throw [siteName];
}
//
// class DaySelected extends SelectedSiteDateTimeEvent {
//   final DateTime day;
//
//   const DaySelected(this.day);
//
//   @override
//   List<Object> get props => throw [day];
// }
//
// class TrendSelected extends SelectedSiteDateTimeEvent {
//   final int numberOfLastDays;
//
//   const TrendSelected(this.numberOfLastDays);
//
//   @override
//   List<Object> get props => throw [numberOfLastDays];
// }
