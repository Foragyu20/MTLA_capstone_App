import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:shared_preferences/shared_preferences.dart';

import 'api.dart';
import 'homez.dart';
import 'pallete.dart';


class Textonly extends StatefulWidget {
  const Textonly({
    Key? key,
    this.token,
    this.username
  }) : super(key: key);

  final String? token;
final String? username;
  @override
  TextonlyState createState() => TextonlyState();
}

class TextonlyState extends State<Textonly> {
  String selectedTargetLanguage = 'Ilocano';
  TextEditingController textEditingController = TextEditingController();
  String translatedText = '';
  String translatedText1 = '';
  String translatedText2 = '';
  stt.SpeechToText speech = stt.SpeechToText();
  SharedPreferences? prefs;
  int index = 0;
  final gradient = GradientPalettePresets.nih.getLinearGradient(2);

  late SentenceTranslator sentenceTranslator;
  late SentenceTranslator sentenceTranslator1;
  late SentenceTranslator sentenceTranslator2;
  @override
  void initState() {
    super.initState();
    speech.initialize();
    SharedPreferences.getInstance().then((prefs) {
      this.prefs = prefs;
      final savedToken = prefs.getString('token');
      if (savedToken != null) {
        // Do something with the token if needed.
      }
    });

    sentenceTranslator = SentenceTranslator(API.trapang);
    sentenceTranslator1 = SentenceTranslator(API.trailoca);
    sentenceTranslator2 = SentenceTranslator(API.tratag);
    // Start listening for speech as soon as the app is initialized.
    startListening();
  }

  bool isListening = false;

  void startListening() {
    if (isListening) {
      stopListening();
      return;
    }

    if (!speech.isAvailable) return;

    speech.listen(
      onResult: (result) {
        setState(() {
          textEditingController.text = result.recognizedWords;
        });
         translateText(result.recognizedWords);
        translateText1(result.recognizedWords);
        translateText2(result.recognizedWords);
      },
      listenMode: stt.ListenMode.dictation,
    );

    setState(() {
      isListening = true;
    });
  }

  void stopListening() {
    speech.stop();

    setState(() {
      isListening = false;
    });
  }

 Future<void> translateText(String text) async {
      final translatedSentence = await sentenceTranslator1.searchSentenceInDatabase(text);
      setState(() {
        translatedText1 = translatedSentence;
      });
  }

  Future<void> translateText1(String text) async {
      final translatedSentence = await sentenceTranslator.searchSentenceInDatabase(text);
      setState(() {
        translatedText = translatedSentence;
      });
    } 
  
   Future<void> translateText2(String text) async {
      final translatedSentence = await sentenceTranslator2.searchSentenceInDatabase(text);
      setState(() {
        translatedText2 = translatedSentence;
      });
  }

final flutterTts = FlutterTts();
Future<void> play1(int i) async {
    final List<String> words = translatedText.split(' ');
    words.insert(0,"0");
    setState(() {
       index = words.length;
    });

  if (i >= 0 && i < words.length) {
    final word = words[i];
    final l = word.toLowerCase();
    final player = AudioPlayer();
    await player.play(AssetSource('audio/$l.mp3'));

    await player.onPlayerStateChanged
        .firstWhere((state) => state == PlayerState.completed);
    await Future.delayed(const Duration(milliseconds: 50));
    await play1(i + 1);
     await player.dispose();
     setState(() {
       index = 0;
     });
  }
  
}
Future<void> play2(int i) async {
    final List<String> words = translatedText1.split(' ');
    words.insert(0,"0");
    setState(() {
       index = words.length;
    });

  if (i >= 0 && i < words.length) {
    final word = words[i];
    final uword = word.toUpperCase();
    final player = AudioPlayer();
    await player.play(AssetSource('audio2/$uword.mp3'));

    await player.onPlayerStateChanged
        .firstWhere((state) => state == PlayerState.completed);
    await Future.delayed(const Duration(milliseconds: 50));
    await play2(i + 1);
     await player.dispose();
     setState(() {
       index = 0;
     });
  }
}
  speak(text) async {
  await flutterTts.setLanguage("PH");
  await flutterTts.setSpeechRate(0.5);
  await flutterTts.setVolume(1.0);
  await flutterTts.setPitch(1.0); 
    await flutterTts.speak(text);
  }

  speak2(text) async {
  await flutterTts.setLanguage("US");
  await flutterTts.setSpeechRate(0.5);
  await flutterTts.setVolume(1.0);
  await flutterTts.setPitch(1.0); 
    await flutterTts.speak(text);
  }
@override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 22, 125, 255),
        title: const Text('Translator'),
      ),
      drawer: const Homez(),
      body: 
          Container(
            decoration: BoxDecoration(gradient: gradient),
            height: screenSize.height,
            width: screenSize.width,
            padding: const EdgeInsets.all(10),
            child:SingleChildScrollView(child: Column(
              children: [
                Container(
                  height: 180,
                  width: 600,
                  decoration: BoxDecoration(
                    color: Colores.smokey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: 
                  Column(
                    children: [
                       Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('English'),
                         
                          IconButton(
                            onPressed: () {
                              startListening();
                              },
                              icon: Icon(isListening ? Icons.stop : Icons.mic),)
                        ],
                      ),
                      Expanded(
                        child: SizedBox(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          child: TextField(
                            maxLines: null,
                            expands: true,
                            textAlign: TextAlign.center,
                            controller: textEditingController,
                            style: const TextStyle(fontSize: 15),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            onChanged: (text) {
                              translateText(text);
                              translateText1(text);
                              translateText2(text);
                            },
                          ),
                        ),
                      ),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(onPressed: ()=>speak2(textEditingController.text), icon: const Icon(Icons.volume_up))
                          
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colores.smokey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  height: 120,
                  width: 600,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        const Text('Pangasinan'),
                          const SizedBox(width: 148),
                          IconButton(onPressed:() { 
        play1(index);
    } , icon: const Icon(Icons.volume_up))
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            translatedText,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                    color: Colores.smokey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  height: 120,
                  width: 600,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        const Text('Ilocano'),
                          const SizedBox(width: 148),
                          IconButton(onPressed:() { 
        play2(index);
    } , icon: const Icon(Icons.volume_up))
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            translatedText1,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(
                    color: Colores.smokey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  height: 120,
                  width: 600,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        const Text('Filipino'),
                          const SizedBox(width: 148),
                          IconButton(onPressed:() { 
        speak(translatedText2);
    } , icon: const Icon(Icons.volume_up))
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            translatedText2,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ) ,) 
           ,)
    );
  }
}

