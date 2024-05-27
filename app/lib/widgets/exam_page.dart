import 'dart:convert';

import 'package:test/widgets/exam.dart';

import '../utils/exam.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ExamPage extends StatefulWidget {
  const ExamPage({Key? key, required this.title, required this.data})
      : super(key: key);
  final List<String> data;

  final String title;

  @override
  State<ExamPage> createState() => _ExamPageState(data: data);
}

class _ExamPageState extends State<ExamPage> {
  final List<String> data;
  List<Exam> exams = [];
  _ExamPageState({required this.data}) {
    getExams();
  }

  Future<void> getExams() async {
    final response = await http
        .get(Uri.parse('http://192.168.12.1:3000/api/getExams'), headers: {
      'authorization': data[0],
      'Content-Type': 'application/json'
    });
    if (response.statusCode == 200) {
      var list = jsonDecode(response.body);
      list.forEach((examData) => setState(() => exams
          .add(Exam(examData['content'], examData['id'], examData['name']))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Exámenes de ${data[1]}'),
            Expanded(
              child: Container(
                  alignment: Alignment.center,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: exams.length,
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ExamWidget(
                                        exam: exams[index], data: data)));
                          },
                          child: Text(exams[index].name));
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }
}
