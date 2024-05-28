import 'package:flutter/material.dart';
import 'widgets/login_page.dart';
import 'widgets/selector_page.dart';
import 'widgets/teacher_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var data = ["", "", ""];

  setData(response) {
    setState(() {
      data[0] = response['token'];
      data[1] = response['username'];
      data[2] = response['type'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My test',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromRGBO(0, 0, 255, 1)),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: data[0] == ""
          ? LoginPage(setData: setData)
          : data[2] == "T"
              ? TeacherPage(data: data)
              : SelectorPage(data: data),
    );
  }
}
