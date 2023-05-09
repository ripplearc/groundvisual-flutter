

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di.config.dart';

// final GetIt getIt = GetIt.instance;
//
// @injectableInit
// Future<void> configureInjection() async => $initGetIt(getIt);

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureInjection() => getIt.init();
