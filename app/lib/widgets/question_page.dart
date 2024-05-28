import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/question.dart';
import '../utils/option.dart';
import '../utils/answer.dart';

class QuestionSelect extends StatefulWidget {
  const QuestionSelect({Key? key}) : super(key: key);

  @override
  State<QuestionSelect> createState() => _QuestionSelectState();
}

class _QuestionSelectState extends State<QuestionSelect> {
  _QuestionSelectState() {
    getAssistance();
  }

  final List<Map> questions = [];

  Future<void> getAssistance() async {
    final response = await http.get(
        Uri.parse('http://192.168.12.1:3000/api/getAssistance'),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      var list = jsonDecode(response.body);
      list.forEach((assistanceData) => setState(() => questions.add({
            assistanceData['id']: [
              assistanceData['content'],
              assistanceData['name']
            ]
          })));
    }
  }

  @override
  Widget build(BuildContext context) {
    print(questions);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Select'),
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
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    return ElevatedButton(
                      child: Text(questions[index].values.first[1]),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuestionPage(
                                  title: 'Test',
                                  questionString:
                                      questions[index].values.first[0])),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionPage extends StatefulWidget {
  const QuestionPage(
      {super.key, required this.title, required this.questionString});

  final String title;
  final String questionString;

  @override
  State<QuestionPage> createState() =>
      _QuestionPageState(questionString: questionString);
}

class _QuestionPageState extends State<QuestionPage> {
  _QuestionPageState({required this.questionString}) {
    List<Question> allQuestions = [];
    List<Option> allOptions = [];
    List<Answer> allAnswers = [];

    var question = questionString.split("\n");
    question.removeWhere((element) => element.isEmpty);
    for (var i = 0; i < question.length; i++) {
      var text = question[i].trim();
      if (text.contains("<p>")) {
        allQuestions.add(Question(text.replaceAll("<p>", ""), [null]));
      } else if (text.contains("<o>")) {
        allOptions.add(Option(text.replaceAll("<o>", ""), null, null));
      } else if (text.contains("<a>")) {
        allAnswers.add(Answer(text.replaceAll("<a>", ""), "", ""));
      } else if (text.contains("<i>")) {
        allAnswers.last.img = text.replaceAll("<i>", "").replaceAll("</i>", "");
      } else if (text.contains("</a>")) {
        allOptions.last.answer = allAnswers.last;
        allAnswers.removeLast();
      } else if (text.contains("</o>")) {
        allQuestions.last.options.add(allOptions.last);
        allOptions.removeLast();
      } else if (text.contains("</p>")) {
        if (allOptions.isNotEmpty) {
          allOptions.last.question = allQuestions.last;
          allQuestions.removeLast();
        }
      }
    }
    questions.add(allQuestions.first);
  }
  List<Question> questions = [];
  final String questionString;

  void addQuestion(Question question) {
    setState(() {
      questions.add(question);
    });
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
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    return Column(children: [
                      ListTile(
                        title: Text(
                          questions[index].question,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      DropdownButton(
                          value: questions[index].selectedOption,
                          items: questions[index]
                              .options
                              .asMap()
                              .entries
                              .map((entry) {
                            return DropdownMenuItem(
                              value: entry.key,
                              child: Text(entry.value?.option ?? ""),
                            );
                          }).toList(),
                          onChanged: (int? value) {
                            if (value == 0) return;
                            setState(() {
                              questions = questions.sublist(0, index + 1);
                            });
                            questions[index].selectedOption = value!;
                            questions[index]
                                .options[value]
                                ?.getAnswer(context, addQuestion);
                          }),
                    ]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
