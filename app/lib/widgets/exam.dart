import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/exam.dart';
import 'package:http/http.dart' as http;

class ExamWidget extends StatefulWidget {
  const ExamWidget({Key? key, required this.data, required this.exam})
      : super(key: key);
  final List<String> data;
  final Exam exam;

  @override
  State<ExamWidget> createState() => _ExamWidgetState(data: data, exam: exam);
}

class _ExamWidgetState extends State<ExamWidget> {
  _ExamWidgetState({required this.data, required this.exam}) {
    exam.questions.forEach((question) => selectedValues.add([null, null]));
    exam.questions.shuffle(Random());
    for (var i = 0; i < exam.questions.length; i++) {
      var answers = exam.questions[i].sublist(1);
      answers.shuffle(Random());
      exam.questions[i] = [exam.questions[i][0], ...answers];
    }
  }

  final List<String> data;
  final Exam exam;
  final List<List<String?>> selectedValues = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exam.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Examen de ${data[1]}'),
            Expanded(
                child: Container(
                    alignment: Alignment.center,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: exam.questions.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Text(exam.questions[index][0]),
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: exam.questions[index].length - 1,
                                itemBuilder: (context, j) {
                                  return ListTile(
                                    title: Text(exam.questions[index][j + 1]),
                                    leading: Radio(
                                        value: exam.questions[index][j + 1],
                                        groupValue: selectedValues[index][1],
                                        onChanged: (value) {
                                          setState(() {
                                            selectedValues[index] = [
                                              exam.questions[index][0],
                                              value
                                            ];
                                          });
                                        }),
                                  );
                                })
                          ],
                        );
                      },
                    ))),
            ElevatedButton(
                onPressed: () async {
                  print(selectedValues);
                  var anyNull = selectedValues.any(
                      (element) => element[0] == null || element[1] == null);
                  if (anyNull) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please answer all questions')));
                    return;
                  } else {
                    var response = await http.post(
                        Uri.parse('http://192.168.12.1:3000/api/sendExam'),
                        headers: {
                          'authorization': data[0],
                          'Content-Type': 'application/json'
                        },
                        body: jsonEncode(
                            {'id': exam.id, 'answers': selectedValues}));
                    if (response.statusCode == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Score: ${jsonDecode(response.body)['score']}')));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(jsonDecode(response.body)['error'])));
                    }
                  }
                },
                child: const Text('Submit'))
          ],
        ),
      ),
    );
  }
}
