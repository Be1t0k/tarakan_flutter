import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'creatingQuestion.dart';

void main() {
  runApp(const MaterialApp(home: CreatingSubject()));
}

class CreatingSubject extends StatefulWidget {
  const CreatingSubject({super.key});

  @override
  State<CreatingSubject> createState() => _CreatingSubjectState();
}

class _CreatingSubjectState extends State<CreatingSubject> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
