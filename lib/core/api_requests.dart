import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiRequests {
  ApiRequests._();

  static const String baseUrl = 'https://content.guardianapis.com/';

  static final String apikey = dotenv.env['GUARDIAN_API_KEY']!;

  static String allSections = '${baseUrl}sections?api-key=$apikey';
  
  static String contentUrl(String contentId) => '${baseUrl}$contentId?api-key=$apikey';
}