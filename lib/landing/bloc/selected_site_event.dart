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
