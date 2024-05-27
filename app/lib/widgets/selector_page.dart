import 'package:flutter/material.dart';
import 'question_page.dart';
import 'exam_page.dart';

class SelectorPage extends StatelessWidget {
  const SelectorPage({super.key, required this.data});
  final List<String> data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido ${data[1]}'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const QuestionPage(title: 'Asistencia')),
              );
            },
            child: const Text('Sección de asistencia'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ExamPage(
                          title: 'Examen',
                          data: data,
                        )),
              );
            },
            child: const Text('Sección de evaluación'),
          ),
        ],
      )),
    );
  }
}
