import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groundvisual_flutter/di/di.dart';

import 'app/ground_visual_app.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent
  ));
  await configureInjection();
  return runApp(GroundVisualApp());
}
