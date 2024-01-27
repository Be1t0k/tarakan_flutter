import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:student_test_system/creatingQuestion.dart';

void main() {
  runApp(const MaterialApp(home: CreatingTest()));
}

class CreatingTest extends StatefulWidget {
  const CreatingTest({super.key});

  @override
  State<CreatingTest> createState() => _CreatingTestState();
}

class _CreatingTestState extends State<CreatingTest> {

  var testNameController  = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        TextFormField(
                      controller: testNameController,
                      onFieldSubmitted: (text) {
                        setState(() {
                          Dio().post("http://192.168.1.15:8080/test", data: {'title': text});
                        });
                        },
                      decoration: const InputDecoration(
                        labelText: 'Название теста',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: ()=>{
                        goPush(),
                      },
                      child: const Text("Go to questions"),
                    ),
      ]),
    );
  }

  goPush() {
    setState(() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const CreatingQuestion("123"))).then((_) => setState(() {
            testNameController.text = "";
          }));
    });
  }

}
