import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppSecrets {
  static const String apiKey = 'YOUR_API_KEY';
  static const String apiSecret = 'YOUR_API_SECRET';
  static String supabaseUrl = dotenv.env['SUPABASE_URL']!;
  static String supabaseAnonKey = dotenv.env['SUPABASE_API_KEY']!;
}
