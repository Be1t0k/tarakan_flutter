import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_test_system/account_screen.dart';
import 'package:student_test_system/creatingTest.dart';
import 'package:student_test_system/main.dart';
import 'package:student_test_system/testList.dart';

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
  int value = 2;

  var role = true;

  _addItem() {
    Navigator.pop(context);
    setState(() {
      value = value + 1;
    });
    Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreatingTest("asd"))).then((_) => setState(() {
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
            itemCount: value,
            itemBuilder: (context, index) => _buildRow(index)),
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

  _buildRow(int index) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreatingTest("asd")));
        },
        title: const Text('title'),
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
