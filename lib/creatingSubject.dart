import 'package:flutter/material.dart';
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

  int value = 2;

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
      body: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: value,
          itemBuilder: (context, index) => _buildRow(index)),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }

  _buildRow(int index) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreatingTest()));
        },
        title: const Text('title'),
        subtitle: Text('subtitle$index'),
      ),
    );
  }
}
