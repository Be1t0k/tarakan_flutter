import 'package:flutter/material.dart';


void main() {
  runApp(const MaterialApp(
      home: CreatingQuestion(
          "Не пришел name_test с прошлой страницы (создания теста)")));
}

class CreatingQuestion extends StatefulWidget {
  const CreatingQuestion(this.testName, {super.key});

  final String testName;

  @override
  State<CreatingQuestion> createState() => _CreatingQuestionState(testName);
}

class _CreatingQuestionState extends State<CreatingQuestion> {

  final String testName;

  _CreatingQuestionState(this.testName);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
