import 'package:flutter/material.dart';
import '../utils/answer.dart';

class AnswerPage extends StatelessWidget {
  const AnswerPage({super.key, required this.title, required this.answer});

  final String title;
  final Answer answer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Razón: ${answer.reason}'),
            Text(answer.solution),
            Image.network(answer.img, width: 200),
          ],
        ),
      ),
    );
  }
}
