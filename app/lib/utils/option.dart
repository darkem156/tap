import 'package:flutter/material.dart';
import '../widgets/answer_page.dart';

import 'answer.dart';
import 'question.dart';

class Option {
  final String option;
  final Answer? answer;
  final Question? question;

  Option(this.option, this.answer, this.question);

  getAnswer(context, addQuestion) {
    if (answer == null) {
      addQuestion(question!);
    } else if (question == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnswerPage(
            title: 'Answer',
            answer: answer!,
          ),
        ),
      );
    }
  }
}
