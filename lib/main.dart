import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quizy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: '/welcome', // Changed from '/' to '/welcome'
      routes: {
        '/welcome': (context) =>
            const WelcomeScreen(), // Added welcome screen route
        '/': (context) => const QuizScreen(),
        '/results': (context) => const ResultsScreen(),
      },
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _selectedAnswerIndex = -1;
  bool _isAnswerChecked = false;
  int _currentRound = 1;
  bool _gameOver = false;
  List<int> _usedQuestionIndices = [];

  final Random _random = Random();

  final List<Map<String, dynamic>> _allQuestions = [
    {
      'question': 'What is the capital of France?',
      'options': ['Berlin', 'Madrid', 'Paris', 'Rome'],
      'correctIndex': 2,
    },
    {
      'question': 'Which planet is known as the Red Planet?',
      'options': ['Earth', 'Mars', 'Jupiter', 'Venus'],
      'correctIndex': 1,
    },
    {
      'question': 'What is the largest mammal?',
      'options': ['Elephant', 'Giraffe', 'Blue Whale', 'Hippopotamus'],
      'correctIndex': 2,
    },
    {
      'question': 'Who painted the Mona Lisa?',
      'options': ['Van Gogh', 'Picasso', 'Da Vinci', 'Michelangelo'],
      'correctIndex': 2,
    },
    {
      'question': 'What is the chemical symbol for gold?',
      'options': ['Go', 'Gd', 'Au', 'Ag'],
      'correctIndex': 2,
    },
    {
      'question': 'Which country is known as the Land of the Rising Sun?',
      'options': ['China', 'Korea', 'Japan', 'Thailand'],
      'correctIndex': 2,
    },
    {
      'question': 'What is the largest ocean on Earth?',
      'options': ['Atlantic', 'Indian', 'Arctic', 'Pacific'],
      'correctIndex': 3,
    },
    {
      'question': 'Which element has the chemical symbol "O"?',
      'options': ['Osmium', 'Oxygen', 'Oganesson', 'Olivine'],
      'correctIndex': 1,
    },
    {
      'question': 'Who wrote "Romeo and Juliet"?',
      'options': [
        'Charles Dickens',
        'William Shakespeare',
        'Jane Austen',
        'Mark Twain'
      ],
      'correctIndex': 1,
    },
    {
      'question': 'What is the smallest prime number?',
      'options': ['0', '1', '2', '3'],
      'correctIndex': 2,
    },
    {
      'question': 'Which animal is known as the "King of the Jungle"?',
      'options': ['Tiger', 'Lion', 'Elephant', 'Gorilla'],
      'correctIndex': 1,
    },
    {
      'question': 'What is the capital of Japan?',
      'options': ['Seoul', 'Beijing', 'Tokyo', 'Bangkok'],
      'correctIndex': 2,
    },
    {
      'question': 'Which planet is closest to the Sun?',
      'options': ['Venus', 'Earth', 'Mars', 'Mercury'],
      'correctIndex': 3,
    },
    {
      'question': 'What is the hardest natural substance on Earth?',
      'options': ['Gold', 'Iron', 'Diamond', 'Platinum'],
      'correctIndex': 2,
    },
    {
      'question': 'Who is known as the father of modern physics?',
      'options': [
        'Isaac Newton',
        'Albert Einstein',
        'Galileo Galilei',
        'Stephen Hawking'
      ],
      'correctIndex': 1,
    },
    {
      'question': 'Which country is home to the kangaroo?',
      'options': ['New Zealand', 'South Africa', 'Australia', 'Brazil'],
      'correctIndex': 2,
    },
    {
      'question': 'What is the largest desert in the world?',
      'options': ['Sahara', 'Antarctic', 'Arabian', 'Gobi'],
      'correctIndex': 1,
    },
    {
      'question': 'Which is the tallest mountain in the world?',
      'options': ['K2', 'Mount Everest', 'Kangchenjunga', 'Makalu'],
      'correctIndex': 1,
    },
    {
      'question': 'What is the main ingredient in guacamole?',
      'options': ['Banana', 'Avocado', 'Cucumber', 'Spinach'],
      'correctIndex': 1,
    },
    {
      'question': 'Which famous scientist developed the theory of relativity?',
      'options': [
        'Marie Curie',
        'Albert Einstein',
        'Isaac Newton',
        'Nikola Tesla'
      ],
      'correctIndex': 1,
    },
  ];

  List<Map<String, dynamic>> _currentRoundQuestions = [];

  @override
  void initState() {
    super.initState();
    _selectRandomQuestionsForRound();
  }

  void _selectRandomQuestionsForRound() {
    _currentRoundQuestions = [];
    List<int> availableIndices = List.generate(_allQuestions.length, (i) => i)
        .where((i) => !_usedQuestionIndices.contains(i))
        .toList();

    // If we've used all questions, reset the used indices
    if (availableIndices.isEmpty) {
      _usedQuestionIndices = [];
      availableIndices = List.generate(_allQuestions.length, (i) => i);
    }

    // Select 5 random questions for this round
    for (int i = 0; i < 5; i++) {
      if (availableIndices.isEmpty) break;

      int randomIndex = _random.nextInt(availableIndices.length);
      int questionIndex = availableIndices[randomIndex];

      _currentRoundQuestions.add(_allQuestions[questionIndex]);
      _usedQuestionIndices.add(questionIndex);
      availableIndices.removeAt(randomIndex);
    }
  }

  void _checkAnswer() {
    setState(() {
      _isAnswerChecked = true;
      if (_selectedAnswerIndex ==
          _currentRoundQuestions[_currentQuestionIndex]['correctIndex']) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    print(
        "Current round: $_currentRound, Current question: $_currentQuestionIndex, Score: $_score");

    if (_currentQuestionIndex < 4) {
      // Not the last question in the round yet
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = -1;
        _isAnswerChecked = false;
      });
    } else {
      // Last question in the round
      if (_currentRound < 2) {
        // Changed from 5 to 2 for only 2 rounds
        // Not the last round yet
        setState(() {
          _currentRound++;
          _currentQuestionIndex = 0;
          _selectedAnswerIndex = -1;
          _isAnswerChecked = false;
          _selectRandomQuestionsForRound();
        });
      } else {
        // Last question of the last round - navigate to results page
        print("GAME OVER - Final score: $_score");
        // Navigate to results page with the final score
        Navigator.pushReplacementNamed(
          context,
          '/results',
          arguments: {'score': _score},
        );
      }
    }
  }

  void _showFinalScoreDialog() {
    final int finalScore = _score;
    final bool passed = finalScore >= 10;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            passed ? 'Congratulations!' : 'Better Luck Next Time!',
            style: TextStyle(
              color: Colors.deepPurple[800],
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                passed ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                size: 80,
                color: passed ? Colors.amber : Colors.deepPurple,
              ),
              const SizedBox(height: 16),
              Text(
                'Your final score: $finalScore out of 20',
                style: TextStyle(
                  color: Colors.deepPurple[800],
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                passed
                    ? 'Great job! You passed the quiz!'
                    : 'Keep practicing to improve your score!',
                style: TextStyle(
                  color: Colors.deepPurple[600],
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _resetQuiz();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[700],
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Play Again', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _resetQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _selectedAnswerIndex = -1;
      _isAnswerChecked = false;
      _currentRound = 1;
      _gameOver = false;
      _usedQuestionIndices = [];
      _selectRandomQuestionsForRound();
    });
  }

  @override
  Widget build(BuildContext context) {
    // If game is over but dialog hasn't shown yet, show it
    if (_gameOver) {
      Future.microtask(() => _showFinalScoreDialog());
    }

    return Scaffold(
      backgroundColor: Colors.deepPurple[300],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[700],
        title: const Text('Quizy',
            style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 8,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple[300]!, Colors.deepPurple[500]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[600],
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Round $_currentRound - Question ${_currentQuestionIndex + 1}/5',
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Score: $_score',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  _currentRoundQuestions.isNotEmpty
                      ? _currentRoundQuestions[_currentQuestionIndex]
                          ['question']
                      : "Loading...",
                  style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: _buildAnswerOptions(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _selectedAnswerIndex == -1 || _isAnswerChecked
                        ? null
                        : _checkAnswer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: const Text('Submit', style: TextStyle(fontSize: 18)),
                  ),
                  ElevatedButton(
                    onPressed: !_isAnswerChecked ? null : _nextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: const Text('Next', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAnswerOptions() {
    if (_currentRoundQuestions.isEmpty) return [];

    final options = _currentRoundQuestions[_currentQuestionIndex]['options']
        as List<String>;
    final correctIndex =
        _currentRoundQuestions[_currentQuestionIndex]['correctIndex'] as int;

    return List.generate(options.length, (index) {
      Color buttonColor;
      Color textColor;

      if (_isAnswerChecked) {
        if (index == correctIndex) {
          buttonColor = Colors.green[600]!;
          textColor = Colors.white;
        } else if (index == _selectedAnswerIndex) {
          buttonColor = Colors.red[600]!;
          textColor = Colors.white;
        } else {
          buttonColor = Colors.deepPurple[400]!;
          textColor = Colors.white.withOpacity(0.7);
        }
      } else if (index == _selectedAnswerIndex) {
        buttonColor = Colors.amber[400]!;
        textColor = Colors.deepPurple[900]!;
      } else {
        buttonColor = Colors.deepPurple[400]!;
        textColor = Colors.white;
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ElevatedButton(
          onPressed: _isAnswerChecked
              ? null
              : () {
                  setState(() {
                    _selectedAnswerIndex = index;
                  });
                },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.disabled)) {
                return buttonColor; // Keep the color even when disabled
              }
              return buttonColor;
            }),
            foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.disabled)) {
                return textColor; // Keep the text color even when disabled
              }
              return textColor;
            }),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.all(20),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            elevation: MaterialStateProperty.all<double>(5),
          ),
          child: Text(
            options[index],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      );
    });
  }
}

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final int score = args['score'] as int;
    final bool passed =
        score >= 5; // Changed from 10 to 5 (half of total questions)

    return Scaffold(
      backgroundColor: Colors.deepPurple[300],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple[300]!, Colors.deepPurple[500]!],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  passed ? 'Congratulations!' : 'Better Luck Next Time!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      passed
                          ? Icons.emoji_events
                          : Icons.sentiment_dissatisfied,
                      size: 80,
                      color: passed ? Colors.amber : Colors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Your final score:',
                        style: TextStyle(
                          color: Colors.deepPurple[800],
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$score out of 10', // Changed from 20 to 10
                        style: TextStyle(
                          color: Colors.deepPurple[800],
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        passed
                            ? 'Great job! You passed the quiz!'
                            : 'Keep practicing to improve your score!',
                        style: TextStyle(
                          color: Colors.deepPurple[600],
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child:
                      const Text('Play Again', style: TextStyle(fontSize: 22)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[300],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple[300]!, Colors.deepPurple[500]!],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to Quizy!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.quiz,
                      size: 100,
                      color: Colors.deepPurple[700],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Test your knowledge!',
                        style: TextStyle(
                          color: Colors.deepPurple[800],
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'You will face 10 questions across 2 rounds. Are you ready to challenge yourself?',
                        style: TextStyle(
                          color: Colors.deepPurple[600],
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child:
                      const Text('Start Quiz', style: TextStyle(fontSize: 24)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
