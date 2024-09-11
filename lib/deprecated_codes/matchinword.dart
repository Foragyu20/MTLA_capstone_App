/*import 'package:flutter/material.dart';
import 'dart:math';

class Page {
  final String pageS; // Page #
  final String questionS; // The question
  final List<String> preV1;
  final List<String> preV2; // The choices
  final List<String> rightAnswer; // The correct answer

  Page({
    required this.pageS,
    required this.questionS,
    required this.preV1,
    required this.preV2,
    required this.rightAnswer,
  });
}

class MathinPage extends StatefulWidget {
  const MathinPage({super.key});

  @override
  MathinPageState createState() => MathinPageState();
}

class MatchingWordsPageState extends State<MatchingWordsPage> {
  List<Page> matchingPages = [
    // Existing page definitions
  ];

  int currentPageIndex = 0;
  int score = 0;
  int health = 5;
  int highScore = 0;

  List<List<bool>> selectedAnswers = [];

  // Rest of the code

  @override
  void initState() {
    super.initState();
    selectedAnswers = List.generate(
      matchingPages.length,
      (_) => List.generate(
        matchingPages[currentPageIndex].preV1.length,
        (_) => false,
      ),
    );
  }

  void checkAnswers() {
    List<String> correctAnswers = matchingPages[currentPageIndex].rightAnswer;
    int questionScore = 0;

    for (int i = 0; i < selectedAnswers[currentPageIndex].length; i++) {
      if (selectedAnswers[currentPageIndex][i] &&
          correctAnswers.contains(matchingPages[currentPageIndex].preV1[i] +
              "=" +
              matchingPages[currentPageIndex].preV2[i])) {
        questionScore += 1;
      } else if (selectedAnswers[currentPageIndex][i] &&
          !correctAnswers.contains(matchingPages[currentPageIndex].preV1[i] +
              "=" +
              matchingPages[currentPageIndex].preV2[i])) {
        health -= 1;
      }
    }

    score += questionScore;

    goToNextQuestion();
  }

  void goToNextQuestion() {
    if (health > 0) {
      int nextIndex = currentPageIndex;
      while (nextIndex == currentPageIndex) {
        nextIndex = Random().nextInt(matchingPages.length);
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
      // Perform other actions when the game ends
    }

    selectedAnswers[currentPageIndex] = List.generate(
      matchingPages[currentPageIndex].preV1.length,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text('Score: $score'),
          Text('Health: $health'),
          Text('High Score: $highScore'),
          Text(matchingPages[currentPageIndex].pageS),
          Text(matchingPages[currentPageIndex].questionS),
          ListView.builder(
            shrinkWrap: true,
            itemCount: matchingPages[currentPageIndex].preV1.length,
            itemBuilder: (BuildContext context, int index) {
              String preV1 = matchingPages[currentPageIndex].preV1[index];
              String preV2 = matchingPages[currentPageIndex].preV2[index];

              return CheckboxListTile(
                title: Text(preV1),
                subtitle: Text(preV2),
                value: selectedAnswers[currentPageIndex][index],
                onChanged: selectedAnswers[currentPageIndex][index]
                    ? null
                    : (bool? value) {
                        setState(() {
                          selectedAnswers[currentPageIndex][index] =
                              value ?? false;
                        });
                      },
              );
            },
          ),
          ElevatedButton(
            onPressed: checkAnswers,
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}*/
