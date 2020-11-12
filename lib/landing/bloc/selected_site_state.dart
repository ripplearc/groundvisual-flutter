part of 'selected_site_bloc.dart';

abstract class SelectedSiteState extends Equatable {
  const SelectedSiteState();

  @override
  List<Object> get props => [];
}

class SelectedSiteEmpty extends SelectedSiteState {}

class SelectedSiteName extends SelectedSiteState {
  final String name;

  const SelectedSiteName(this.name);

  @override
  List<Object> get props => [name];

  @override
  String toString() => 'SelectedSiteName { name: $name }';
}
