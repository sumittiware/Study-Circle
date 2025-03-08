import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:study_circle/models/chat.dart';
import 'package:study_circle/models/quiz.dart';
import 'package:study_circle/repository/chat_repository.dart';
import 'package:study_circle/repository/quiz_repo.dart';

class QuizScreen extends StatefulWidget {
  final TestModel test;
  final String groupId;
  const QuizScreen({super.key, required this.test, required this.groupId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final _pageController = PageController();
  String _selectedOption = "";
  bool loading = false;

  // Method to submit quiz
  void submitQuiz() async {
    if (_selectedOption.isEmpty) {
      return;
    }
    setState(() {
      loading = true;
    });
    final currentIndex = _pageController.page!.toInt();

    final submitQuizOption = QuizAnswer(
      quizId: widget.test.id,
      questionId: widget.test.questions[currentIndex].id,
      optionId: _selectedOption,
      answerTime: DateTime.now().millisecondsSinceEpoch,
    );

    // Make Submit request with the submitQuizOption
    try {
      await QuizRepository.submitAnswer(submitQuizOption);
    } catch (err) {
      Fluttertoast.showToast(msg: "Error submtting answer");
      setState(() {
        loading = false;
      });
      return;
    }

    // Check if last page
    if (currentIndex + 1 == widget.test.questions.length) {
      try {
        await ChatRepository.submitMessage(
          SubmitMessageRequest(
            text: "Done",
            groupId: widget.groupId,
            sendToAllie: false,
          ),
        );
        if (!mounted) {
          return;
        }
        Navigator.pop(context);
      } catch (err) {
        Fluttertoast.showToast(msg: "Error submtting answer");
        setState(() {
          loading = false;
        });
        return;
      }
      // ignore: use_build_context_synchronously
    } else {
      _pageController.animateToPage(
        currentIndex + 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    }
    setState(() {
      _selectedOption = "";
      loading = true;
    });
  }

  int getTimeDifferenceInMinutes(int startTime, int endTime) {
    // Calculate the difference in milliseconds
    int differenceInMillis = endTime - startTime;

    // Convert milliseconds to minutes
    int differenceInMinutes = (differenceInMillis / 60000).round();

    return differenceInMinutes;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return PopScope(
      onPopInvokedWithResult:
          (didPop, result) => Future<bool>(false as FutureOr<bool> Function()),

      child: Scaffold(
        backgroundColor: Color(0xff3F3F40),
        body: Padding(
          padding: EdgeInsets.only(
            top: mediaQuery.viewPadding.top + 16,
            left: 16,
            right: 16,
            bottom: 16,
          ),
          child: Column(
            children: [
              SizedBox(height: 24),
              CountdownTimerScreen(
                time: getTimeDifferenceInMinutes(
                  widget.test.startTime,
                  widget.test.endTime,
                ),
                onTimerFinished: () {
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(height: 24),
              Expanded(
                child: PageView.builder(
                  allowImplicitScrolling: false,
                  physics: NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  itemBuilder: (context, index) {
                    return QuestionWidget(
                      index: index + 1,
                      question: widget.test.questions[index],
                      quizId: widget.test.id,
                      onOptionSelect: (String optionId) {
                        setState(() {
                          _selectedOption = optionId;
                        });
                      },
                    );
                  },
                  itemCount: widget.test.questions.length,
                ),
              ),

              //Build CTA
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _selectedOption.isEmpty
                          ? Color(0xff292929)
                          : Color(0xff0266DA),
                ),
                onPressed: submitQuiz,
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  child: _buildButtonText(),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonText() {
    final isLastQuestion =
        _pageController.hasClients &&
        (_pageController.page! + 1) == widget.test.questions.length;

    if (isLastQuestion || _selectedOption.isEmpty) {
      return Text(
        isLastQuestion ? "Submit" : "Next",
        style: TextStyle(
          color: _selectedOption.isNotEmpty ? Colors.white : Color(0xff848484),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Next",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 6),
        Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
      ],
    );
  }
}

class QuestionWidget extends StatefulWidget {
  final int index;
  final String quizId;
  final Question question;
  final Function(String) onOptionSelect;

  const QuestionWidget({
    super.key,
    required this.index,
    required this.quizId,
    required this.question,
    required this.onOptionSelect,
  });

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  String selectedAnswerId = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Q${widget.index}",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 24),
        SizedBox(
          height: 100,
          child: Text(
            widget.question.text,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        SizedBox(height: 8),

        ...List.generate(widget.question.options.length, (i) {
          final currentOptionId = widget.question.options[i].id;
          return GestureDetector(
            onTap: () {
              widget.onOptionSelect(currentOptionId);
              setState(() {
                selectedAnswerId = currentOptionId;
              });
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Color(0xff0f0f0f),
                border: Border.all(
                  color:
                      selectedAnswerId == currentOptionId
                          ? Color(0xff78ABFB)
                          : Color(0xff0f0f0f),
                ),
                gradient:
                    selectedAnswerId == currentOptionId
                        ? LinearGradient(
                          colors: [
                            Color(0xff233a6c),
                            Color(0xff233a6c).withOpacity(0.3),
                          ],
                        )
                        : null,
              ),
              child: Text(
                "${widget.question.options[i].id}. ${widget.question.options[i].text}",
                style: TextStyle(color: Color(0xffbcbcbc), fontSize: 14),
              ),
            ),
          );
        }),

        // Build CTA
      ],
    );
  }
}

class CountdownTimerScreen extends StatefulWidget {
  final int time; // Time in seconds
  final Function() onTimerFinished;

  const CountdownTimerScreen({
    super.key,
    required this.time,
    required this.onTimerFinished,
  });

  @override
  _CountdownTimerScreenState createState() => _CountdownTimerScreenState();
}

class _CountdownTimerScreenState extends State<CountdownTimerScreen> {
  late int remainingTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    remainingTime = widget.time * 60; // Initialize with passed time
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        timer.cancel();
        widget.onTimerFinished();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = formatTime(remainingTime);

    return Center(
      child: Text(
        formattedTime,
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }
}
