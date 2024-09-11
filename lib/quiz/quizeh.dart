import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mtla_2/api.dart';
class Quizh extends StatefulWidget {
  const Quizh({Key? key}) : super(key: key);

  @override
  QuizhState createState() => QuizhState();
}

class QuizhState extends State<Quizh> {
  int currentPageIndex = 0;
  int score = 0;
  int highScore = 0;
  late List<Question> allQuizQuestions;
   late List<Question> availableQuizQuestions;

  @override
  void initState() {
    super.initState();
    fetchQuizQuestions();
  }

  Future<void> fetchQuizQuestions() async {
  final response = await http.get(Uri.parse(API.qe));

  if (response.statusCode == 200) {
    final List<dynamic> responseData = json.decode(response.body);
      final questions = responseData.map((item) {
        return Question(
          id: item['id'].toString(),
          question: item['question'] ?? '',
          options:[
            item['option_1'] ?? '',
            item['option_2'] ?? '',
            item['option_3'] ?? '',
            item['option_4'] ?? '',],
          correctAnswer: item['correct_answer'].toString(),
          answeredCorrectly: false,
        );
      }).toList();

      setState(() {
        allQuizQuestions = questions;
        availableQuizQuestions = List.from(allQuizQuestions);
      });
  
  } else {
    throw Exception('Failed to fetch quiz questions');
  }
  print('allQuizQuestions: $allQuizQuestions');
  print('availableQuizQuestions: $availableQuizQuestions');

  if (availableQuizQuestions.isEmpty) {
    print('Error: availableQuizQuestions is empty.');
  }
}

  void selectAnswer(String selectedAnswer) {
    String correctAnswer = availableQuizQuestions[currentPageIndex].correctAnswer;
    if (selectedAnswer == correctAnswer) {
      setState(() {
        score += 3;
        availableQuizQuestions[currentPageIndex].answeredCorrectly = true;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.lightBlue,
          title: const Text('Wrong Answer'),
          content: const Text('You answered this question incorrectly.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Continue',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      );
    }
    goToNextQuestion();
  }

  void goToNextQuestion() {
    if (currentPageIndex < availableQuizQuestions.length - 1) {
      setState(() {
        currentPageIndex++;
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
          backgroundColor: Colors.lightBlue,
          title: const Text('Game Over'),
          content: Text('Your final score: $score\nHigh Score: $highScore'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  score = 0;
                  currentPageIndex = 0;
                  resetQuizQuestions();
                });
                Navigator.pop(context);
              },
              child: Container(
                alignment: Alignment.center,
                height: 50,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white.withOpacity(0.7),
                ),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      score = 0;
                      currentPageIndex = 0;
                      resetQuizQuestions();
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
            ),
          ],
        ),
      );
    }
  }

  void resetQuizQuestions() {
    setState(() {
      availableQuizQuestions = List.from(allQuizQuestions);
      for (var question in availableQuizQuestions) {
        question.answeredCorrectly = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (availableQuizQuestions.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    else{Question currentQuestion = availableQuizQuestions[currentPageIndex];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 171, 88, 87),
      appBar: AppBar(
        backgroundColor:const Color.fromARGB(255, 144, 6, 3),
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: const Text('Quiz Difficult'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [const Text(
              'Score',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),Text(
              '$score',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),],),
            const SizedBox(height: 16.0),
            Container(
              alignment: Alignment.center,
              width: double.maxFinite,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: const Color.fromARGB(255, 217, 217, 217),
              ),
              child: Text(
                currentQuestion.question,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50.0,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
           Column(
  children: [
    for (String option in currentQuestion.options)
      Column(
        children: [
          ElevatedButton(
            onPressed: () => selectAnswer(option),
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(const Size(400, 50)),
              foregroundColor: MaterialStateProperty.all(
                const Color.fromARGB(255, 0, 0, 0),
              ),
              backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 217, 217, 217)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              overlayColor: MaterialStateProperty.all(
                const Color.fromARGB(255, 144, 6, 3),
              ),
            ),
            child: Text(option),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
  ],
),

            const SizedBox(height: 16.0),
            
            
            Text(
              'High Score: $highScore',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );}

    
  }
}

class Question {
  final String id;
  final String question;
   List<String> options;
  final String correctAnswer;
  bool answeredCorrectly;

  Question({
    required this.id,
    required this.options,
    required this.question,
    required this.correctAnswer,
    required this.answeredCorrectly,
  });
}