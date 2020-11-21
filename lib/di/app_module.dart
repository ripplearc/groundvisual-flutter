import 'package:injectable/injectable.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

@module
abstract class AppModule {
  @preResolve
  Future<StreamingSharedPreferences> get prefs => StreamingSharedPreferences.instance;
}
