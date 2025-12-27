import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get geminiKey => dotenv.get('GEMINI_API_KEY');

  static String get model =>
      dotenv.get('GEMINI_MODEL', fallback: 'gemini-2.5-flash');
}
