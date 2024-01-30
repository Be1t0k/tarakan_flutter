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

  var role;

  _addItem() {
    setState(() {
      value = value + 1;
    });
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
          visible: isVisible(),
          child: FloatingActionButton(
            onPressed: _addItem,
            child: const Icon(Icons.add),
          ),
        ));
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
