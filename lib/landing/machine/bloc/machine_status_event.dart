part of 'machine_status_bloc.dart';

@immutable
abstract class MachineStatusEvent extends Equatable {
  const MachineStatusEvent();
}

class SearchMachineStatusOnDate extends MachineStatusEvent {
  final String siteName;
  final DateTime date;

  const SearchMachineStatusOnDate(this.siteName, this.date) : super();

  @override
  List<Object> get props => [siteName, date];
}

class SearchMachineStatueOnTrend extends MachineStatusEvent {
  final String siteName;
  final TrendPeriod period;

  SearchMachineStatueOnTrend(this.siteName, this.period);

  @override
  List<Object> get props => [siteName, period];
}
