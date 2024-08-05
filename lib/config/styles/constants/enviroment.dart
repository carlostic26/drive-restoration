import 'package:flutter_dotenv/flutter_dotenv.dart';

class Enviroment {
  static String flutterVersion = dotenv.env['flutterVersion'] ?? '0.0.0';
}
