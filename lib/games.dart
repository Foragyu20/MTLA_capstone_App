import 'package:flutter/material.dart';
import 'homez.dart';
import 'pallete.dart';
import 'quiz/quize.dart';
import 'quiz/quizm.dart';
import 'quiz/quizeh.dart';
class GamesPage extends StatelessWidget {
  GamesPage({super.key});
  final gradient = GradientPalettePresets.nih.getLinearGradient(45.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const Homez(),
        appBar: AppBar(
          title: const Text('Quiz'),
        ),
        body: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(gradient: gradient),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    height: 140,
                    width: 140,
                    child: Image.asset('assets/Quiz.png'),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Container(
                      width: 300,
                      height: 200,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white, width: 0),
                          color: Colores.smokey.withOpacity(0.8)),
                      child: Column(
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(const Size(400, 50)),
              foregroundColor: MaterialStateProperty.all(
                const Color.fromARGB(255, 0, 0, 0),
              ),
              backgroundColor: MaterialStateProperty.all(Colores.qe),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              overlayColor: MaterialStateProperty.all(
                const Color.fromARGB(255, 142, 227, 139),
              ),
            ),
                            onPressed: (){Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Quiz()),
        );},
                            child:const Text('Easy')),
                          const SizedBox(height: 5,),
ElevatedButton(   style:ButtonStyle(
              fixedSize: MaterialStateProperty.all(const Size(400, 50)),
              foregroundColor: MaterialStateProperty.all(
                const Color.fromARGB(255, 0, 0, 0),
              ),
              backgroundColor: MaterialStateProperty.all( Colores.qm),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              overlayColor: MaterialStateProperty.all(
                const Color.fromARGB(255, 142, 227, 139),
              ),
            ),
                            onPressed: (){Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>   const Quizm(),),
        );},
                            child:const Text('Moderate')),
                                 const SizedBox(height: 5,),
                          ElevatedButton(
                             style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(const Size(400, 50)),
              foregroundColor: MaterialStateProperty.all(
                const Color.fromARGB(255, 0, 0, 0),
              ),
              backgroundColor: MaterialStateProperty.all(Colores.qh),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              overlayColor: MaterialStateProperty.all(
                const Color.fromARGB(255, 142, 227, 139),
              ),
            ),
                            onPressed: (){Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>   const Quizh(),),
        );},
                            child:const Text('Difficult')),
                           
                        ],
                      )),
                ],
              ),
            )));
  }
}
