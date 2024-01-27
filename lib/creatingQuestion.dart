import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'creatingTest.dart';

void main() {
  runApp(const MaterialApp(
      home: CreatingQuestion(
          "Не пришел name_test с прошлой страницы (создания теста)")));
}

class CreatingQuestion extends StatefulWidget {
  const CreatingQuestion(this.test_name, {super.key});

  final String test_name;

  @override
  State<CreatingQuestion> createState() => _CreatingQuestionState(test_name);
}

class _CreatingQuestionState extends State<CreatingQuestion> {
  
  final String test_name;

  _CreatingQuestionState(this.test_name);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
