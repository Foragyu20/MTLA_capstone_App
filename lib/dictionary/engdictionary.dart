import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:mtla_2/api.dart';
import 'dart:convert';
import 'package:mtla_2/pallete.dart';
import 'package:mtla_2/homez.dart';



class EnglishDictionaryList extends StatefulWidget {
  const EnglishDictionaryList({Key? key}) : super(key: key);

  @override
  EnglishDictionaryListState createState() => EnglishDictionaryListState();
}

class EnglishDictionaryListState extends State<EnglishDictionaryList> {
  List<Map<String, dynamic>> records = [];
  String searchText = '';


  @override
  void initState() {
    super.initState();
    fetchRecords();
   
  }
  


  Future<void> fetchRecords() async {
    final response = await http.get(
       Uri.parse(API.tr),
    );

    if (response.statusCode == 200) {
      setState(() {
        records = List<Map<String, dynamic>>.from(json.decode(response.body));
        records = records.where((record) {
          return record['english_word'].toLowerCase().contains(searchText.toLowerCase());
        }).toList();
      });
    } else {
      // Handle error
    }
  }

void handleWordTap(word,partofspeech,definition,example,translate1,translate2,translate3) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WordDetailPage(
          word: word,
          partofspeech: partofspeech,
          definition: definition,
          example: example,
          translate1: translate1,
          translate2: translate2,
          translate3: translate3,
          ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
 drawer: const Homez(),
      appBar:  AppBar(
        backgroundColor: Colores.mink.withOpacity(1),
        title: const ListTile(title:Text('English Dictionary') ,) ,
      ),
      backgroundColor: const Color.fromARGB(255,216, 171, 255),
      body: Container(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              color:const Color.fromARGB(255,216, 171, 255), 
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                    fetchRecords();
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final record = records[index];
                  return Container(
                    color: const Color.fromARGB(255,216, 171, 255),
                    child: ListTile(
                      title:
                          SizedBox(
                            width: 140,
                            child: Column(children: [ Text(
                              record['english_word'],
                              style: const TextStyle(fontSize: 20, fontFamily: 'Kadwa'),
                            ), Text(
                              record['part_of_speech'],
                              style: const TextStyle(fontSize: 10, fontFamily: 'Kadwa'),
                            ),],)
                          ),
                        trailing:IconButton(onPressed: (){
                          handleWordTap(
                            record['english_word'],
                            record['part_of_speech'],
                            record['definition'],
                            record['english_example'],
                            record['pangasinan_word'],
                            record['tagalog_word'],
                            record['ilocano_word'],);}, icon: const Icon(Icons.forward) ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

    

}


class WordDetailPage extends StatelessWidget {
    final String word;
final String partofspeech;
final String definition;
final String example;
final String translate1;
final String translate2;
final String translate3;

    WordDetailPage({Key? key, 
  required this.word,
  required this.definition,
  required this.example,
  required this.partofspeech,
  required this.translate1,
  required this.translate2,
  required this.translate3}) : super(key: key);

final flutterTts = FlutterTts();

void speak(text) async {
    await flutterTts.speak(text);
    await flutterTts.setLanguage("US"); 
    await flutterTts.setSpeechRate(0.5); 
    await flutterTts.setVolume(1.0); 
    await flutterTts.setPitch(1.0); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colores.gree.withOpacity(0.3),
      ),
      backgroundColor: Colores.gree,
      body: 
      Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
       IconButton(onPressed: (){speak(word);}, icon: const Icon(Icons.volume_up)),
       Text(word,style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 25),), 
       Text(partofspeech,style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),),
       Text('Definition : $definition',style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),),
       Text('Example : $example',style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),),
       Container(alignment: Alignment.centerLeft, child: Column(children: [
       Text('Pangasinan : $translate1',style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),),
       Text('Tagalog : $translate2',style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),),
       Text('Ilocano : $translate3',style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 16),),
      ],),)
      ],
      ),
      
    );
  }
}
