import 'package:flutter/material.dart';
import 'dart:math';

import 'package:mtla_2/pallete.dart';

class Page {
  final String questionS; // The question
  final List<String> answerS; // The choices
  final String rightAnswer; // The correct answer

  Page({
    required this.questionS,
    required this.answerS,
    required this.rightAnswer,
  });
}

class GuessPage extends StatefulWidget {
  const GuessPage({super.key});

  @override
  GuessPageState createState() => GuessPageState();
}

class GuessPageState extends State<GuessPage> {
  List<Page> guessPages = [
    Page(
      questionS: 'Dagsen ti awit ko.',
      answerS: ['Filipino', 'Ilocano', 'English', 'Pangasinan'],
      rightAnswer: 'Ilocano',
    ),
    Page(
      questionS: 'Ampetang ed paway.',
      answerS: ['Filipino', 'Ilocano', 'English', 'Pangasinan'],
      rightAnswer: 'Pangasinan',
    ),
    Page(
      questionS: 'Dagsen ti awit ko.',
      answerS: ['Filipino', 'Ilocano', 'English', 'Pangasinan'],
      rightAnswer: 'Ilocano',
    ),
    Page(
      questionS: 'The mango is sweet.',
      answerS: ['Filipino', 'Ilocano', 'English', 'Pangasinan'],
      rightAnswer: 'English',
    ),
    Page(
      questionS: 'Marami ang dumalo kahapon.',
      answerS: ['Filipino', 'Ilocano', 'English', 'Pangasinan'],
      rightAnswer: 'Filipino',
    ),
    Page(
      questionS: 'Mabaen nak keng ka.',
      answerS: ['Filipino', 'Ilocano', 'English', 'Pangasinan'],
      rightAnswer: 'Ilocano',
    ),
  ];

  int currentPageIndex = 0;
  int score = 0;
  int lives = 3;
  int highScore = 0;

  void selectAnswer(String selectedAnswer) {
    String correctAnswer = guessPages[currentPageIndex].rightAnswer;
    if (selectedAnswer == correctAnswer) {
      setState(() {
        score += 3;
      });
    } else {
      setState(() {
        lives--;
      });
    }
    goToNextQuestion();
  }

  void goToNextQuestion() {
    if (lives > 0) {
      int nextIndex = currentPageIndex;
      while (nextIndex == currentPageIndex) {
        nextIndex = Random().nextInt(guessPages.length);
      }
      setState(() {
        currentPageIndex = nextIndex;
      });
    } else {
      if (score > highScore) {
        setState(() {
          highScore = score;
        });
      }
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colores.liskin,
          title: const Text('Game Over'),
          content: Text('Your final score: $score\nHigh Score: $highScore'),
          actions: [
            Container(
              alignment: Alignment.center,
              height: 50,
              width: double.maxFinite,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(width: 3, color: Colors.black),
                  color: Colors.white.withOpacity(0.7)),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    score = 0;
                    lives = 3;
                    currentPageIndex = 0;
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  'Restart',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Page currentPage = guessPages[currentPageIndex];

    return Scaffold(
      backgroundColor: Colores.liskin,
      appBar: AppBar(
        title: const Text('Guess The Dialect'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(20),
              width: double.maxFinite,
              decoration: BoxDecoration(
                  border: Border.all(width: 3, color: Colors.black),
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white.withOpacity(0.7)),
              child: Text(
                currentPage.questionS,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50.0,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Column(
              children: currentPage.answerS
                  .map((answer) => TextButton(
                        onPressed: () => selectAnswer(answer),
                        child: Container(
                          alignment: Alignment.center,
                          height: 70,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(width: 3, color: Colors.black),
                              color: Colors.white.withOpacity(0.7)),
                          child: Text(
                            answer,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 30.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            SizedBox(
                width: 50,
                child: Column(children: [
                  const SizedBox(height: 16.0),
                  Text(
                    'Score: $score',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Lives: $lives',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'High Score: $highScore',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ])),
          ],
        ),
      ),
    );
  }
}
