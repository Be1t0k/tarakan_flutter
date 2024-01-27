import 'package:flutter/material.dart';


void main() {
  runApp(const MaterialApp(home: CreatingTest()));
}

class CreatingTest extends StatefulWidget {
  const CreatingTest({super.key});

  @override
  State<CreatingTest> createState() => _CreatingTestState();
}

class _CreatingTestState extends State<CreatingTest> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }

}
