import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import '../utils/exam.dart';
import 'dart:io';

class TeacherPage extends StatefulWidget {
  const TeacherPage({Key? key, required this.data}) : super(key: key);

  final List<String> data;

  @override
  State<TeacherPage> createState() => _TeacherPageState(data: data);
}

class _TeacherPageState extends State<TeacherPage> {
  _TeacherPageState({required this.data}) {
    getExams();
    getGallery();
  }

  final List<String> data;
  final TextEditingController examContentController = TextEditingController();
  final TextEditingController examNameController = TextEditingController();
  final TextEditingController studentsController = TextEditingController();
  final TextEditingController assistanceNameController =
      TextEditingController();
  final TextEditingController assistanceContentController =
      TextEditingController();
  List<Exam> exams = [];
  List<String> scores = [];
  List<String> gallery = [];
  List<File> _images = [];
  final picker = ImagePicker();

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

  Future<void> getGallery() async {
    final response =
        await http.get(Uri.parse('http://192.168.12.1:3000/api/gallery'));
    if (response.statusCode == 200) {
      var list = jsonDecode(response.body);
      list.forEach((galeryData) => setState(
          () => gallery.add("http://192.168.12.1:3000/uploads/" + galeryData)));
    }
  }

  Future<void> _pickImages() async {
    final pickedFiles = await picker.pickMultiImage();

    setState(() {
      _images = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
    });
  }

  Future<void> _uploadImages() async {
    if (_images.isEmpty) return;

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.12.1:3000/api/gallery'),
    );

    request.headers['authorization'] = data[0];

    for (var image in _images) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'images', // Asegúrate de que el campo coincida con el backend
          image.path,
          contentType: MediaType('image', 'png'),
        ),
      );
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await http.Response.fromStream(response);
      final decodedResponse = jsonDecode(responseBody.body);
      print('Upload successful: $decodedResponse');
    } else {
      print('Upload failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: scores.length,
                itemBuilder: (context, index) {
                  return Text(scores[index]);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: exams.length,
                itemBuilder: (context, index) {
                  return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            scores = [];
                          });
                          jsonDecode(exams[index].scores ?? '').forEach(
                            (key, value) => setState(() => scores
                                .add('Estudiante: $key, Calificación: $value')),
                          );
                        },
                        child: Text(exams[index].name),
                      ));
                },
              ),
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
            Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    var students = studentsController.text.split(',');
                    var response = await http.post(
                      Uri.parse('http://192.168.12.1:3000/api/createExam'),
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
                )),
            TextField(
              controller: assistanceNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nombre de la asistencia',
              ),
            ),
            TextField(
              controller: assistanceContentController,
              maxLines: 2,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Contenido de la asistencia',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                var response = await http.post(
                  Uri.parse('http://192.168.12.1:3000/api/createAssistance'),
                  body: jsonEncode({
                    'content': assistanceContentController.text,
                    'name': assistanceNameController.text,
                  }),
                  headers: {
                    'authorization': data[0],
                    'Content-Type': 'application/json',
                  },
                );
                if (response.statusCode == 201) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Asistencia creada correctamente'),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Error al crear la asistencia'),
                  ));
                }
              },
              child: const Text('Crear asistencia'),
            ),
            const Text(
                'Galería (presiona el boton copiar el enlace de la imagen)'),
            _images.isEmpty
                ? Text('No images selected.')
                : Text('Selected ${_images.length} images.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImages,
              child: Text('Pick Images'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadImages,
              child: Text('Upload Images'),
            ),
            Container(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: gallery.length,
                itemBuilder: (context, index) {
                  return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          Image.network(gallery[index]),
                          ElevatedButton(
                              onPressed: () async {
                                await Clipboard.setData(
                                    ClipboardData(text: gallery[index]));
                              },
                              child: Text(gallery[index]))
                        ],
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
