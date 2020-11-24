import 'package:flutter/material.dart';
import 'package:groundvisual_flutter/di/di.dart';

import 'ground_visual_app.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureInjection();
  return runApp(GroundVisualApp());
}
