import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:mtla_2/api.dart';
import 'dart:convert';
import 'package:mtla_2/pallete.dart';
import 'package:mtla_2/homez.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';


class IlocanoDictionaryList extends StatefulWidget {
  const IlocanoDictionaryList({Key? key}) : super(key: key);

  @override
  IlocanoDictionaryListState createState() => IlocanoDictionaryListState();
}

class IlocanoDictionaryListState extends State<IlocanoDictionaryList> {
  List<Map<String, dynamic>> records = [];
  String searchText = '';
  late File audio;
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
          return record['ilocano_word'].toLowerCase().contains(searchText.toLowerCase());
        }).toList();
      });
    } else {
      // Handle error
    }
  }


 Future<void> audioUp(File audioz) async {
  final url = Uri.parse("http://192.168.1.72/api/upload_audio.php");

    final request = http.MultipartRequest('POST', url)
      ..files.add(await http.MultipartFile.fromPath('audio', audioz.path));

    // Send the request
    final response = await request.send();

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON response
      final responseData = await response.stream.bytesToString();
      final message = jsonDecode(responseData);
if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('File'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("File name: ${message['filename']}"),
              ],
            ),
            actions: [
               TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Nice'),
              ),
            ],
          );
        },
      );
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

  Future<void> pickFile(word) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );

    if (result != null) {
     PlatformFile platformFile  = result.files.first;
File file = File(platformFile.path!);
String newFileName = '$word.mp3';
 File renamedFile = await file.rename('${file.parent.path}/$newFileName');
audio = renamedFile;
if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('File'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("File path: ${file.path}"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  audioUp(audio);
                  Navigator.pop(context);
                },
                child: const Text('Nice'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    drawer: const Homez(),
      appBar:  AppBar(
        backgroundColor: Colores.gree.withOpacity(1),
        title: const ListTile(title:Text('Ilocano Dictionary'),) ,
      ),
      backgroundColor: Colores.gree.withOpacity(1),
      body: Container(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              color:Colores.gree.withOpacity(0.3), 
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
                    color: Colores.gree.withOpacity(0.3), 
                    child: ListTile(
                      title:
                          SizedBox(
                            width: 140,
                            child: Column(children: [ Text(
                              record['ilocano_word'],
                              style: const TextStyle(fontSize: 20, fontFamily: 'Kadwa'),
                            ), Text(
                              record['part_of_speech'],
                              style: const TextStyle(fontSize: 10, fontFamily: 'Kadwa'),
                            ),],)
                          ),
                        trailing:IconButton(onPressed: (){
                          handleWordTap(
                            record['ilocano_word'],
                            record['part_of_speech'],
                            record['definition'],
                            record['ilocano_example'],
                            record['english_word'],
                            record['pangasinan_word'],
                            record['tagalog_word'],
                            );}, icon: const Icon(Icons.forward) ),
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
final player = AudioPlayer();
String get wordz => word.toUpperCase();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colores.gree.withOpacity(1), 
      ),
      backgroundColor:Colores.gree.withOpacity(0.3), 
      body: 
      Container(
        alignment: Alignment.center,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         IconButton(onPressed: ()async{
     await player.play(AssetSource("audio2/$wordz.mp3"),);
  }, icon: const Icon(Icons.volume_up)),
           Text(
                      word,
                      style: const TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 25),
                    ), 
                     Text(
                      partofspeech,
                      style: const TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 12),
                    ),
                     Text(
                      'Definition : $definition',
                      style: const TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 16),
                    ),
                     Text(
                      'Example : $example',
                      style: const TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 16),
                    ),
        Text(
                      'english : $translate1',
                      style: const TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 16),
                    ),
                    Text(
                      'pangasinan : $translate2',
                      style: const TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 16),
                    ),
                    Text(
                      'tagalog : $translate3',
                      style: const TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 16),
                    ),
        ],
      ),),
      
    );
  }
}
