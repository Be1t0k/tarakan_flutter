import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_test_system/account_screen.dart';
import 'package:student_test_system/passingTest.dart';

void main() {
  runApp(const MaterialApp(home: TestList()));
}

class TestList extends StatefulWidget {
  const TestList({super.key});

  @override
  State<TestList> createState() => _TestListState();
}

class _TestListState extends State<TestList> {

  final List<String> testsObjects = [];
  
  var baseUrl = "192.168.0.109";

  @override
  void initState() {
    super.initState();
    getMyDisciplines();
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
          itemCount: testsObjects.length,
          itemBuilder: (context, index) =>
              _buildRow(index, testsObjects[index]))
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PassingTest("123")));
        },
        title: Text(testsObjects[index]),
        subtitle: Text('subtitle$index'),
      ),
    );
  }

  void getMyDisciplines() async {
    List jsonList;
    var response;
    try {
      response = await Dio().get("http://$baseUrl:8080/discipline/pasha@gmail.com",
          options: Options(
              sendTimeout: const Duration(minutes: 1),
              receiveTimeout: const Duration(minutes: 1),
              receiveDataWhenStatusError: true));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception("Connection  Timeout Exception");
      }
      throw Exception(e.message);
    }
    setState(() {
      jsonList = response.data as List;
      print(jsonList);
      jsonList.length;

      jsonList.forEach((item) async {
        print("----------------------------------------------------");
        print("----------------------------------------------------");
        print(jsonList[jsonList.indexOf(item)]['id']);
        print(jsonList[jsonList.indexOf(item)]['title']);
        // Обновление айдишника на новый
        setState(() {
          testsObjects.add(jsonList[jsonList.indexOf(item)]['title']);
        });
      });
    });
  }

}
