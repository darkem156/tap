import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/exam.dart';

class TeacherPage extends StatefulWidget {
  const TeacherPage({Key? key, required this.data}) : super(key: key);

  final List<String> data;

  @override
  State<TeacherPage> createState() => _TeacherPageState(data: data);
}

class _TeacherPageState extends State<TeacherPage> {
  _TeacherPageState({required this.data}) {
    getExams();
  }

  final List<String> data;
  final TextEditingController examContentController = TextEditingController();
  final TextEditingController examNameController = TextEditingController();
  final TextEditingController studentsController = TextEditingController();
  List<Exam> exams = [];
  List<String> scores = [];

  Future<void> getExams() async {
    final response = await http
        .get(Uri.parse('http://192.168.12.1:3000/api/getExams'), headers: {
      'authorization': data[0],
      'Content-Type': 'application/json'
    });
    if (response.statusCode == 200) {
      var list = jsonDecode(response.body);
      list.forEach((examData) => setState(() => exams.add(Exam(
          examData['content'], examData['id'], examData['name'],
          scores: jsonEncode(examData['scores'])))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Container(
                    alignment: Alignment.center,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: scores.length,
                      itemBuilder: (context, index) {
                        return Text(scores[index]);
                      },
                    ))),
            Expanded(
              child: Container(
                  alignment: Alignment.center,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: exams.length,
                    itemBuilder: (context, index) {
                      return ElevatedButton(
                          onPressed: () {
                            setState(() {
                              scores = [];
                            });
                            jsonDecode(exams[index].scores ?? '').forEach(
                                (key, value) => setState(() => scores.add(
                                    'Estudiante: $key, Calificación: $value')));
                          },
                          child: Text(exams[index].name));
                    },
                  )),
            ),
            TextField(
              controller: examNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nombre del examen',
              ),
            ),
            TextField(
              controller: examContentController,
              maxLines: 2,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Contenido del examen',
              ),
            ),
            TextField(
              controller: studentsController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Estudiantes',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                var students = studentsController.text.split(',');
                var response = await http.post(
                  Uri.parse('http://localhost:3000/api/createExam'),
                  body: jsonEncode({
                    'content': examContentController.text,
                    'name': examNameController.text,
                    'students': students,
                  }),
                  headers: {
                    'authorization': data[0],
                    'Content-Type': 'application/json',
                  },
                );
                if (response.statusCode == 201) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Examen creado correctamente'),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Error al crear el examen'),
                  ));
                }
              },
              child: const Text('Crear examen'),
            )
          ],
        ),
      ),
    );
  }
}
