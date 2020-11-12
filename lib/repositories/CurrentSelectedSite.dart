import 'package:injectable/injectable.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

abstract class CurrentSelectedSite {
  Stream<String> site();

  void setSelectedSite(String value);

  String value();
}

@LazySingleton(as: CurrentSelectedSite)
class CurrentSelectedSiteImpl implements CurrentSelectedSite {
  CurrentSelectedSiteImpl(StreamingSharedPreferences preferences)
      : _site = preferences.getString('selected_site', defaultValue: "");

  final Preference<String> _site;

  @override
  Stream<String> site() => _site;

  @override
  String value() => _site.getValue();

  @override
  void setSelectedSite(String value) => _site.setValue(value);
}
