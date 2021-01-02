part of 'machine_status_bloc.dart';

@immutable
abstract class MachineStatusState extends Equatable {}

class MachineStatusInitial extends MachineStatusState {
  List<Object> get props => [];
}

class WorkingTimeAtSelectedSite extends MachineStatusState {
  final Map<String, UnitWorkingTime> workingTimes;

  WorkingTimeAtSelectedSite(this.workingTimes);

  @override
  List<Object> get props => [workingTimes];
}
