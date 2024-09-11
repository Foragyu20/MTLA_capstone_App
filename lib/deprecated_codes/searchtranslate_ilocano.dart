import 'package:http/http.dart' as http;

class SentenceSeparator {
  String sentence;

  SentenceSeparator(this.sentence);

  List<String> separateWords() {
    return sentence.split(' ');
  }
}

class Translator {
  final String apiUrl;

  Translator(this.apiUrl);

  Future<String> searchWordInDatabase(String word) async {
    final response = await http.get(Uri.parse('$apiUrl?word=$word'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "Error: ${response.statusCode}";
    }
  }

  Future<String> translateSentence(String sentence) async {
    final separator = SentenceSeparator(sentence);
    final words = separator.separateWords();
    final translatedWords = [];

    for (final word in words) {
      final translation = await searchWordInDatabase(word);
      translatedWords.add(translation);
    }

    return translatedWords.join(' ');
  }
}

void main() async {
  final translator = Translator("http:/192.168.0.102/api_php/translatetext_ilocano.php");
  const sentence = "This is a sample sentence";
  final translatedSentence = await translator.translateSentence(sentence);
  print("Original Sentence: $sentence");
  print("Translated Sentence: $translatedSentence");
}
