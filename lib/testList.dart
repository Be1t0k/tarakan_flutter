import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_test_system/account_screen.dart';

void main() {
  runApp(const MaterialApp(home: TestList()));
}

class TestList extends StatefulWidget {
  const TestList({super.key});

  @override
  State<TestList> createState() => _TestListState();
}

class _TestListState extends State<TestList> {
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
                MaterialPageRoute(builder: (context) => const AccountScreen()),
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
          itemCount: 2,
          itemBuilder: (context, index) =>
              _buildRow(index, "subjectObjects[index]")),
      floatingActionButton: Visibility(
        visible: true,
        child: FloatingActionButton(
          onPressed: () => print(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
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
          print("123");
        },
        title: Text("subjectObjects[index]"),
        subtitle: Text('subtitle$index'),
      ),
    );
  }
}
