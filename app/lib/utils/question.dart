import 'option.dart';

class Question {
  final String question;
  final List<Option?> options;
  int selectedOption = 0;

  Question(this.question, this.options);
}
