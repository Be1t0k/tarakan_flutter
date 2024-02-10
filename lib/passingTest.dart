import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_test_system/account_screen.dart';
import 'package:student_test_system/creatingQuestion.dart';

class PassingTest extends StatefulWidget {
  const PassingTest(this.testId, {super.key});
  final String testId;

  @override
  State<PassingTest> createState() => _PassingTestState(testId);
}

class _PassingTestState extends State<PassingTest> {
  final String testId;
  _PassingTestState(this.testId);

  bool isLoading = true;
  var index = 1;
  var questionsCount = 0;
  var answerInQuestionCount = 0;
  Map<String, int> answerScore = {};
  var baseUrl = "192.168.0.109";
  var currentUser = FirebaseAuth.instance.currentUser;
  List<dynamic> jsonQuestions = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  final List<dynamic> data1 = [
    {
      "id": 1,
      "question": "1 вопрос mobile_test",
      "answers": [
        {"id": 1, "text": "ответ_1_1", "score": 10},
        {"id": 2, "text": "ответ_1_2", "score": 20}
      ]
    },
    {
      "id": 2,
      "question": "2 вопрос mobile_test",
      "answers": [
        {"id": 3, "text": "ответ_1", "score": 100},
        {"id": 4, "text": "ответ_2", "score": 200}
      ]
    }
  ];

  void _getData() async {
    List answerQuestion;
    var questions = await Dio().get("http://$baseUrl:8080/question/$testId");
    print(jsonQuestions);
    setState(() {
      jsonQuestions = questions.data as List;
    });
  }

  void signOutUser() {
    setState(() {
      FirebaseAuth.instance.signOut();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Статистика прохождения"),
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
        itemCount: jsonQuestions.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(jsonQuestions[index]["text"], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Column(
                children: List.generate(jsonQuestions[index]["answers"].length, (ind) {
                  return ListTile(
                    title: Text(jsonQuestions[index]["answers"][ind]["text"]),
                    subtitle: Text("Score: ${jsonQuestions[index]["answers"][ind]["score"]}"),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
