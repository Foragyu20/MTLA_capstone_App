import 'package:http/http.dart' as http;

class API {
  static String? _w;
  static void setLocalIP(String ip) {
    _w = ip;
  }

  static String get w => _w ?? 'Gubat.local'; // Fallback to localhost if not set
  static String get equiz => "http://$w/api/quizes/quize.php";
  static String get loginz => 'http://$w/api/login.php';
  static String get registerz => 'http://$w/api/register.php';
  static String get trailoca => 'http://$w/api/translator/translatetext_ilocano.php';
  static String get trapang => 'http://$w/api/translator/translatetext_pagasinan.php';
  static String get tratag => "http://$w/api/translator/translatetext_tagalog.php";
  static String get tr => "http://$w/api/Crudtranslationdictionary.php";
  static String get qe => "http://$w/api/quizes/quize.php";
}


class SentenceTranslator {
  final String apiUrl;

  SentenceTranslator(this.apiUrl);

  Future<String> searchSentenceInDatabase(String sentence) async {
    final response = await http.get(Uri.parse('$apiUrl?sentence=$sentence'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "Error: ${response.statusCode}";
    }
  }
}