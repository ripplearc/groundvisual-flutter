part of 'machine_status_bloc.dart';

@immutable
abstract class MachineStatusState extends Equatable {}

class MachineStatusInitial extends MachineStatusState {
  List<Object> get props => [];
}

class MachineStatusWorkingTime extends MachineStatusState {
  final Map<String, UnitWorkingTime> workingTimes;
  final Map<String, Stream<MachineOnlineStatus>> onlineStatuses;

  MachineStatusWorkingTime(this.workingTimes, this.onlineStatuses);

  @override
  List<Object> get props => [workingTimes];
}
