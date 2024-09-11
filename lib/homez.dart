import 'package:flutter/material.dart';
import 'package:mtla_2/api.dart';
import 'package:mtla_2/login.dart';
import 'package:mtla_2/quiz/quize.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'textonly.dart';
import 'pallete.dart';
import 'package:http/http.dart' as http;
import 'package:mtla_2/dictionary/engdictionary.dart';
import 'package:mtla_2/dictionary/fildictionary.dart';
import 'package:mtla_2/dictionary/ilocanodictionary.dart';
import 'package:mtla_2/dictionary/pangasinandictionary.dart';

class Homez extends StatefulWidget {
  const Homez({Key? key}) : super(key: key);

  @override
  HomezState createState() => HomezState();
}

class HomezState extends State<Homez> {
  Color bleu = Colores.bleu;
  Color gri = Colors.grey.withOpacity(0.3);
  Color transparentSmokey = Colores.smokey.withOpacity(0.3);

  String u =  LoginPageState.getUsername() ;
  final pers = Colores.peri;
  final gradient = GradientPalettePresets.nih.getLinearGradient(45.0);
  bool _isDictionaryExpanded = false;

  @override
  void initState() {
    super.initState();
  }
void clearToken() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('token');
  prefs.remove('username');  // Replace 'token' with the key you used to store the token.
}
  // Future<void> _loadUsername() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final savedUsername = prefs.getString('username');
  //   if (savedUsername != null) {
  //     setState(() {
  //       username = savedUsername;
  //     });
  //   }
  // }
 Widget title() {
    return SizedBox(
      height: 140,
      width: double.maxFinite,
      child: Center(
        child:Image.asset('assets/Filpen.png'),
      ),
    );
  }

Future<void> deleteUser() async {
  String w =API.w;
     String apiUrl = "http://$w/api/delete_account.php";
 

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'username': u},
      );

      if (response.statusCode == 200) {
        print("User deleted successfully");
      } else {
        print("Failed to delete user: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

onLogoutButtonPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:  FutureBuilder<String>(
                  future: u as Future<String>,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Text(
                        snapshot.data ?? '',

                      );
                    }
                  },
                ),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                clearToken();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

deletedialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:  FutureBuilder<String>(
                  future: u as Future<String>,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Text(
                        snapshot.data ?? '',

                      );
                    }
                  },
                ),
          content: const Text('Are you sure you want to Delete your account?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                clearToken();
                deleteUser();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
@override
  Widget build(BuildContext context) {
         final screenSize = MediaQuery.of(context).size;
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 198, 135, 255),
      child: 
      Column(children: [Container(
        height:screenSize.height-50 ,width: screenSize.width ,
        decoration: BoxDecoration(gradient: gradient),
        child:
      Column(children: [
        SingleChildScrollView(child: Column(children: [Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            title(),
            divider(),
            buildDictionaryExpansionTile(context),
            divider(),
            Row(children: [space1(), buildButton(context, 'Translation', 
            const Textonly(), 'assets/translation.png'),space()],),
            divider(),
            Row(children: [space1(),buildButton(context, 'Quiz', const Quiz(), "assets/game.png"),space()],),
            divider(),
           Row(children: [space1(),TextButton.icon(
      onPressed: () {
       onLogoutButtonPressed(context);
      },
      icon: SizedBox(
        width: 50,
        height: 50,
        child: Image.asset('assets/logout.png'),
      ),
      label: const Text(
        'Logout',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    ),space()],),
            divider(),
          ],
        )],),
      ),
     
      
        ],)
    ), Stack(children: [Column(children: [
divider(),TextButton(onPressed: (){
deletedialog(context);
}, child: const Text('Delete Account'))
      ],)],)],),);
  }

  
  ExpansionTile buildDictionaryExpansionTile(BuildContext context) {
    return ExpansionTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          SizedBox(
            height: 50,
            width: 50,
            child: Image.asset('assets/book.png'),
          ),
          const SizedBox(width: 20),
          const Text(
            'Dictionary',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ],
      ),
      trailing: Icon(_isDictionaryExpanded ? Icons.expand_less : Icons.expand_more),
      onExpansionChanged: (bool expanded) {
        setState(() {
          _isDictionaryExpanded = expanded;
        });
      },
      children: [
         dictionaryItemButton(context, 'English', const EnglishDictionaryList(), Colores.mernk),
        const SizedBox(height: 10),
        dictionaryItemButton(context, 'Pangasinan', const PangasinanDictionaryList(), Colores.bleu),
        const SizedBox(height: 10),
        dictionaryItemButton(context, 'Ilocano', const IlocanoDictionaryList(), Colores.gree),
        const SizedBox(height: 10),
        dictionaryItemButton(context, 'Filipino', const TagalogDictionaryList(), Colores.skin),
      ],
    );
  }
}