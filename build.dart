import 'dart:io';
import 'package:dotenv/dotenv.dart' as dotenv;

Future<void> main() async {
  var env = dotenv.DotEnv(includePlatformEnvironment: true)..load(['web/.env']);

  final apiKey = env['GOOGLE_MAPS_API_KEY'] ?? '';

  final indexHtml = File('web/index.html');
  var contents = await indexHtml.readAsString();

  contents = contents.replaceAll('YOUR_GOOGLE_MAP_API_KEY', apiKey);

  await indexHtml.writeAsString(contents);
}
