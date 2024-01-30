import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:student_test_system/creatingQuestion.dart';

void main() {
  runApp(const MaterialApp(home: CreatingTest("Не пришел name_test с прошлой страницы (создания предмета)")));
}

class CreatingTest extends StatefulWidget {
  const CreatingTest(this.nameSub, {super.key});

  final String nameSub;

  @override
  State<CreatingTest> createState() => _CreatingTestState(nameSub);
}

class _CreatingTestState extends State<CreatingTest> {
  
  var testNameController = TextEditingController();
  final String nameSub;
  
  _CreatingTestState(this.nameSub);

  @override
  void initState() {
    super.initState();
  }

  int value = 2;

  _addItem() {
    setState(() {
      value = value + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Тесты дисциплины$nameSub"),
      ),
      body: 
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: value,
            itemBuilder: (context, index) => _buildRow(index)),
      floatingActionButton: OutlinedButton(
          onPressed: () => _dialogBuilder(context),
          child: const Text('Open Dialog'),
        ),
    );
  }

  _buildRow(int index) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreatingQuestion("123")));
        },
        title: const Text('title'),
        subtitle: Text('subtitle$index'),
      ),
    );
  }

Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Basic dialog title'),
          content: 
  TextFormField(
          controller: testNameController,
          onFieldSubmitted: (text) {
            setState(() {
              Dio()
                  .post("http://192.168.1.15:8080/test", data: {'title': text});
            });
          },
          decoration: const InputDecoration(
            labelText: 'Название теста',
          ),
        ),
          actions: <Widget>[
            
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Создать'),
              onPressed: () {
                goPush();
              },
            ),
          ],
        );
      },
    );
  }



  goPush() {
    setState(() {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreatingQuestion("123")))
          .then((_) => setState(() {
                testNameController.text = "";
              }));
    });
  }
}
