import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuizPage(),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int viewState = 0;
  int questionIndex = 0;
  int score = 0;
  bool answered = false;
  int? selectedAnswer;

  final List<Map<String, dynamic>> questions = [
    {
      "question":
          "Which mobile app feature would help KD Sari-Sari Store manage inventory efficiently?",
      "choices": [
        "Inventory alerts",
        "Music player",
        "Photo filters",
        "Mobile games",
      ],
      "answer": 0,
    },
    {
      "question": "Which feature allows customers to order products remotely?",
      "choices": [
        "Online ordering",
        "Camera effects",
        "Wallpaper changer",
        "Audio player",
      ],
      "answer": 0,
    },
    {
      "question": "Which app function helps track daily sales and income?",
      "choices": [
        "Sales reports",
        "Video editor",
        "Emoji stickers",
        "Music streaming",
      ],
      "answer": 0,
    },
    {
      "question":
          "What feature improves communication between store and customers?",
      "choices": [
        "Push notifications",
        "Game rewards",
        "Live filters",
        "Photo gallery",
      ],
      "answer": 0,
    },
  ];

  void startQuiz() {
    setState(() {
      viewState = 1;
      questionIndex = 0;
      score = 0;
      answered = false;
      selectedAnswer = null;
    });
  }

  void answerQuestion(int index) {
    setState(() {
      answered = true;
      selectedAnswer = index;
      if (index == questions[questionIndex]["answer"]) {
        score++;
      }
    });
  }

  void nextQuestion() {
    setState(() {
      answered = false;
      selectedAnswer = null;
      if (questionIndex < questions.length - 1) {
        questionIndex++;
      } else {
        viewState = 2;
      }
    });
  }

  void restartQuiz() {
    setState(() {
      viewState = 0;
      questionIndex = 0;
      score = 0;
      answered = false;
      selectedAnswer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B4F7C), // Deep ocean blue
      appBar: AppBar(
        title: const Text(
          "Knowledge Test",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E88E5), // Ocean blue
        elevation: 4,
        shadowColor: Colors.black26,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0B4F7C), // Deep ocean blue
              Color(0xFF1565C0), // Medium ocean blue
              Color(0xFF1976D2), // Lighter ocean blue
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildView(),
          ),
        ),
      ),
    );
  }

  Widget _buildView() {
    // START VIEW
    if (viewState == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Color(0xFFE3F2FD), // Light blue tint
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0D47A1).withOpacity(0.3),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(
                color: const Color(0xFF42A5F5).withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.quiz,
                  size: 120,
                  color: Color(0xFF1565C0), // Ocean blue
                ),
                const SizedBox(height: 32),
                const Text(
                  "Business App Knowledge Test",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1), // Dark ocean blue
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: startQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2), // Ocean blue
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 18,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 6,
                    shadowColor: const Color(0xFF0D47A1).withOpacity(0.4),
                  ),
                  child: const Text(
                    "Start Quiz",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // QUIZ VIEW WITH Q&A STYLE
    if (viewState == 1) {
      final q = questions[questionIndex];

      return SingleChildScrollView(
        child: Column(
          children: [
            // Q&A Header
            const Text(
              "Q&A",
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 3,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Color(0xFF0D47A1),
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Progress indicator
            Text(
              "Question ${questionIndex + 1} of ${questions.length}",
              style: const TextStyle(
                color: Color(0xFFE3F2FD),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),

            // Question bubble
            _qaBubble(text: q["question"], isQuestion: true),
            const SizedBox(height: 20),

            // Answer choices as bubbles
            for (int i = 0; i < q["choices"].length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _answerBubble(
                  text: q["choices"][i],
                  index: i,
                  isCorrect: i == q["answer"],
                ),
              ),

            const SizedBox(height: 32),

            if (answered)
              ElevatedButton(
                onPressed: nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2), // Ocean blue
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 6,
                  shadowColor: const Color(0xFF0D47A1).withOpacity(0.4),
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // Brand name at bottom
            const Text(
              "@yourbrandname",
              style: TextStyle(
                color: Color(0xFFBBDEFB),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }

    // END VIEW
    double percent = (score / questions.length) * 100;
    String message = percent == 100
        ? "🎉 Congratulations! You did great!"
        : percent < 50
        ? "💡 Better luck next time. Review and try again."
        : "👍 Good job! Keep improving.";

    return _card(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.emoji_events,
            size: 70,
            color: Color(0xFF4CAF50), // Keep green for success
          ),
          const SizedBox(height: 16),
          const Text(
            "Quiz Result",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D47A1), // Dark ocean blue
            ),
          ),
          Text(
            "Score: $score / ${questions.length}",
            style: const TextStyle(color: Color(0xFF1565C0)),
          ),
          Text(
            "Percentage: ${percent.toStringAsFixed(0)}%",
            style: const TextStyle(color: Color(0xFF1565C0)),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF1976D2)),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: restartQuiz,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
              elevation: 4,
              shadowColor: const Color(0xFF0D47A1).withOpacity(0.3),
            ),
            child: const Text(
              "Restart Quiz",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Q&A style bubble for questions
  Widget _qaBubble({required String text, required bool isQuestion}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Color(0xFFE3F2FD), // Light ocean blue
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D47A1).withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF42A5F5).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Color(0xFF0D47A1), // Dark ocean blue
        ),
      ),
    );
  }

  // Answer bubble (clickable)
  Widget _answerBubble({
    required String text,
    required int index,
    required bool isCorrect,
  }) {
    Color backgroundColor = Colors.white;
    Color borderColor = const Color(0xFF42A5F5).withOpacity(0.3);
    Gradient? gradient;

    if (answered) {
      if (isCorrect) {
        gradient = const LinearGradient(
          colors: [Color(0xFFE8F5E8), Color(0xFFC8E6C9)],
        );
        borderColor = const Color(0xFF4CAF50);
      } else if (index == selectedAnswer) {
        gradient = const LinearGradient(
          colors: [Color(0xFFFFEBEE), Color(0xFFFFCDD2)],
        );
        borderColor = const Color(0xFFE53935);
      }
    } else {
      gradient = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white,
          Color(0xFFE3F2FD), // Light ocean blue
        ],
      );
    }

    return GestureDetector(
      onTap: answered ? null : () => answerQuestion(index),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: gradient == null ? backgroundColor : null,
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D47A1).withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: Color(0xFF0D47A1), // Dark ocean blue
          ),
        ),
      ),
    );
  }

  Widget _card(Widget child) {
    return Card(
      elevation: 12,
      shadowColor: const Color(0xFF0D47A1).withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Color(0xFFE3F2FD), // Light ocean blue tint
            ],
          ),
        ),
        child: Padding(padding: const EdgeInsets.all(24), child: child),
      ),
    );
  }
}
