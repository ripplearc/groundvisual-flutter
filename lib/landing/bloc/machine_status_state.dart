part of 'machine_status_bloc.dart';

@immutable
abstract class MachineStatusState extends Equatable {}

class MachineStatusInitial extends MachineStatusState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class WorkingTimeAtSelectedSite extends MachineStatusState {
  final Map<String, UnitWorkingTime> workingTimes;

  WorkingTimeAtSelectedSite(this.workingTimes);

  @override
  List<Object> get props => [workingTimes];
}
