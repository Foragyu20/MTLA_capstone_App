/*import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'pallete.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'searchtranslate_pagasinan.dart';
import 'searchtranslate_ilocano.dart';

class TranslatorPage extends StatefulWidget {
  const TranslatorPage({
    Key? key,
    this.token,
  }) : super(key: key);

  final String? token;

  @override
  TranslatorPageState createState() => TranslatorPageState();
}

class TranslatorPageState extends State<TranslatorPage> {
  final stt.SpeechToText speechToText = stt.SpeechToText();
  final gradient = GradientPalettePresets.nih.getLinearGradient(2);
  String transcription = '';
  String translation = '';
  List<String> retrievedWords = [];

  String selectedOutputLanguage = 'Pangasinan';

  Future<void> translatetextPagasinan() async {
    String inputText = transcription;
    SentenceSeparatorpang separator = SentenceSeparatorpang(inputText);
    List<String> words = separator.separateWordspang();

    List<String> retrievedWords = [];
    String combinedSentence = retrievedWords.join(' ');
    String translatedText = combinedSentence;

    for (String word in words) {
      String result = await searchWordsInDatabasepang(word);
      retrievedWords.add(result);
    }

    setState(() {
      translation = translatedText;
    });
  }

  Future<void> translatetextIlocano() async {
    String inputText = transcription;
    SentenceSeparator separator = SentenceSeparator(inputText);
    List<String> words = separator.separateWords();

    List<String> retrievedWords = [];
    String combinedSentence = retrievedWords.join(' ');
    String translatedText = combinedSentence;

    for (String word in words) {
      String result = await searchWordsInDatabase(word);
      retrievedWords.add(result);
    }

    setState(() {
      translation = translatedText;
    });
  }

  final Map<String, String> languageCodeMap = {
    'English': 'en',
    'Tagalog': 'tl',
    'Ilocano': 'ilo',
    'Pangasinan Dialect': 'pag',
  };

  bool isListening = false;

  void startListening() {
    if (isListening) {
      stopListening();
      return;
    }

    if (!speechToText.isAvailable) return;

    speechToText.listen(
      onResult: (result) => setState(() async {
        transcription = result.recognizedWords;
        SentenceSeparator ha = SentenceSeparator(transcription);
        List<String> words = ha.separateWords();

        for (String word in words) {
  
          if (selectedOutputLanguage == 'Pangasinan') {
            searchWordsInDatabasepang(word);
          } else if (selectedOutputLanguage == 'Ilocano') {
            searchWordsInDatabase(word);
          }
        } 
      }),
      onSoundLevelChange: (level) {
        // Do something with the sound level, if desired
      },
      listenMode: stt.ListenMode.dictation,
    );

    setState(() {
      isListening = true;
    });
  }

  void stopListening() {
    speechToText.stop();

    setState(() {
      isListening = false;
    });
  }

  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    speechToText.initialize();

    // Initialize SharedPreferences
    SharedPreferences.getInstance().then((prefs) {
      this.prefs = prefs;
      // Load the token when the page is first created
      final savedToken = prefs.getString('token');
      if (savedToken != null) {
      }
    });
  }

  // Function to save the token
  void saveToken(String token) {
    if (prefs != null) {
      prefs!.setString('token', token);
    }
  }

  // Function to remove the token
  void removeToken() {
    if (prefs != null) {
      prefs!.remove('token');
    }
  }

  @override
  void dispose() {
    speechToText.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech Translator'),
      ),
      body: ListView(
        children: [
          Container(
            height: screenSize.height,
            width: screenSize.width,
            decoration: BoxDecoration(gradient: gradient),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colores.coolgray,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 300,
                  width: 300,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 230),
                          IconButton(
                            icon: Icon(isListening ? Icons.stop : Icons.mic),
                            onPressed: startListening,
                          ),
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            transcription,
                            maxLines: null,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  height: 300,
                  width: 300,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colores.coolgray,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildLanguageDropdown(
                              '        ',
                              selectedOutputLanguage,
                              (String? newValue) {
                                setState(() {
                                  selectedOutputLanguage = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            translation,
                            maxLines: null,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              fontStyle: FontStyle.normal,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageDropdown(
    String label,
    String value,
    ValueChanged<String?> onChanged,
  ) {
    return Row(
      children: [
        Text(label),
        DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          items: languageCodeMap.keys.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}*/
