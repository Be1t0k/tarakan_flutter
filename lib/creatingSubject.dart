import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_test_system/account_screen.dart';
import 'package:student_test_system/creatingTest.dart';

void main() {
  runApp(const MaterialApp(home: CreatingSubject()));
}

class CreatingSubject extends StatefulWidget {
  const CreatingSubject({super.key});

  @override
  State<CreatingSubject> createState() => _CreatingSubjectState();
}

class _CreatingSubjectState extends State<CreatingSubject> {
  final creatingSubjectController = TextEditingController();
  final List<String> subjectObjects = ['first', 'second'];
  int value = 2;
  var role = true;

  String baseUrl = "192.168.155.6";

  _addItem() {
    Navigator.pop(context);
    setState(() {
      value = value + 1;
    });
    Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreatingTest(creatingSubjectController.text))).then((_) => setState(() {
                creatingSubjectController.text = "";
              }));;
  }

  
Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Basic dialog title'),
          content: 
  TextFormField(
          controller: creatingSubjectController,
          onFieldSubmitted: (text) {
            setState(() {
              Dio()
                  .post("http://$baseUrl:8080/test", data: {'title': text});
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
                _addItem();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                signOutUser;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AccountScreen()),
                );
              },
              icon: const Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: subjectObjects.length,
            itemBuilder: (context, index) => _buildRow(index, subjectObjects[index])),
        floatingActionButton: Visibility(
          visible: true,
          child: FloatingActionButton(
            onPressed: () => _dialogBuilder(context),
            child: const Icon(Icons.add),
          ),
        ),);
  }

  void signOutUser() {
    setState(() {
      FirebaseAuth.instance.signOut();
    });
  }

  _buildRow(int index, var nameSubject) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreatingTest(nameSubject)));
        },
        title: Text(subjectObjects[index]),
        subtitle: Text('subtitle$index'),
      ),
    );
  }

  isVisible() {
    if (role == 'ADMIN') {
      return true;
    } else {
      return false;
    }
  }
}
