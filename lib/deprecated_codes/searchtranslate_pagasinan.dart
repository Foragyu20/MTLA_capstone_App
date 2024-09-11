
import 'package:http/http.dart' as http;

class SentenceSeparatorPang {
  String sentence;

  SentenceSeparatorPang(this.sentence);

  List<String> separateWordsPang() {
    return sentence.split(' ');
  }
}
Future<String> searchWordsInDatabasePang(String word) async {
  const String phpScriptURL = "http://192.168.0.102/api_php/translatetext_pagasinan.php";
  final uri = Uri.parse('$phpScriptURL?word=${Uri.encodeComponent(word)}');

  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      // Successfully fetched data, return the response as a string
      return response.body;
    } else {
      // Handle errors with a more descriptive message or log the error.
      return "Translation not found. HTTP ${response.statusCode}";
    }
  } catch (e) {
    // Handle other exceptions, e.g., network or parsing errors.
    return "Error: $e";
  }
}
