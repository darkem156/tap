class Exam {
  List<List<String>> questions = [];
  final int id;
  final String name;
  final String? scores;

  Exam(String content, this.id, this.name, {this.scores}) {
    for (var element in content.split('\n')) {
      if (element[0] == "*") {
        questions.add([element.substring(1)]);
      } else if (element[0] == "-") {
        questions[questions.length - 1].add(element.substring(1));
      }
    }
  }
}
