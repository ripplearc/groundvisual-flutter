part of 'machine_status_bloc.dart';

@immutable
abstract class MachineStatusState extends Equatable {}

class MachineStatusInitial extends MachineStatusState {
  List<Object> get props => [];
}

class MachineStatusOfWorkingTimeAndOnline extends MachineStatusState {
  final Map<String, UnitWorkingTime> workingTimes;
  final Map<String, Stream<MachineOnlineStatus>> onlineStatuses;

  MachineStatusOfWorkingTimeAndOnline(this.workingTimes, this.onlineStatuses);

  @override
  List<Object> get props => [workingTimes];
}
