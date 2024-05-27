import 'package:flutter/material.dart';
import '../utils/question.dart';
import '../utils/option.dart';
import '../utils/answer.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key, required this.title});

  final String title;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  /*
  <p>
    Preguntas iniciales
    <o>
      El problema son pitidos
      <p>
        Número de pitidos
      </p>
    </o>
    <o>
    </o>
  </p>
  */
  List<Question> questions = [
    Question(
      'What is the capital of France?',
      [
        null,
        Option(
            'Paris',
            null,
            Question('What is the capital of Spain?', [
              null,
              Option(
                  'Madrid',
                  null,
                  Question('What is the capital of Italy?', [
                    null,
                    Option(
                        'Rome',
                        null,
                        Question('What is the capital of USA?', [
                          null,
                          Option('Washington',
                              Answer("razon", "solucion", "/img.jpg"), null),
                        ])),
                  ])),
              Option(
                  'Barcelona', Answer("razon", "solucion", "/img.jpg"), null),
            ])),
        Option('France', Answer("razon", "solucion", "/img.jpg"), null),
        Option(
            'Cancun',
            null,
            Question('What is the capital of Spain?', [
              null,
              Option('Madrid', Answer("razon", "solucion", "/img.jpg"), null),
              Option(
                  'Barcelona', Answer("razon", "solucion", "/img.jpg"), null),
            ])),
      ],
    ),
  ];

  void addQuestion(Question question) {
    setState(() {
      questions.add(question);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
