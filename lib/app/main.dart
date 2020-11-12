import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/di/di.dart';

import 'GroundVisualApp.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureInjection();
  return runApp(GroundVisualApp());
}
