import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_test_system/account_screen.dart';

class PassingTest extends StatefulWidget {
  const PassingTest(this.testId, {super.key});
  final String testId;

  @override
  State<PassingTest> createState() => _PassingTestState(testId);
}

class _PassingTestState extends State<PassingTest> {
  final String testId;

  var _tileColor;

  var _selectedIndex;
  var _selectedInd;

  _PassingTestState(this.testId);

  var baseUrl = "192.168.0.109";
  var currentUser = FirebaseAuth.instance.currentUser;
  List<dynamic> jsonQuestions = [];
  Map<String, int> selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    var questions = await Dio().get("http://$baseUrl:8080/question/$testId");
    setState(() {
      jsonQuestions = questions.data as List;
    });
  }

  void signOutUser() {
    setState(() {
      FirebaseAuth.instance.signOut();
    });
  }

  void _changeColor(String question, int index, String answerTitle) {
  setState(() {
    if (selectedAnswers.containsKey(question) && selectedAnswers[question] != index) {
      return; // ответ уже выбран в текущем вопросе, менять цвет не разрешено
    }

    selectedAnswers[question] = index;
    print("отправим ${answerTitle}");
    Dio().post("http://$baseUrl:8080/answer/$currentUser/${answerTitle}");
  });
}

  // void _changeColor(resScore, question, index, ind) {
  //   setState(() {
  //     selectedAnswers[question] = index;
  //     _selectedIndex = index;
  //     _selectedInd = ind;
  //     if (resScore < 100)
  //                       {
  //                         setState(() {
  //                           _tileColor = Colors.red;
  //                         });
  //                       }
  //                     else{
  //                       setState(() {
  //                           _tileColor = Colors.green;
  //                         });
  //                     }
  //   });
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       centerTitle: true,
  //       title: Text("Прохождение теста $testId"),
  //       backgroundColor: Colors.blue,
  //       elevation: 0,
  //       actions: [
  //         IconButton(
  //           onPressed: () {
  //             signOutUser;
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(builder: (context) => const AccountScreen()),
  //             );
  //           },
  //           icon: const Icon(
  //             Icons.person,
  //             color: Colors.white,
  //           ),
  //         ),
  //       ],
  //     ),
  //     body: ListView.builder(
  //       itemCount: jsonQuestions.length,
  //       itemBuilder: (context, index) {
  //         return Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: <Widget>[
  //             Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Text(jsonQuestions[index]["text"],
  //                   style: const TextStyle(
  //                       fontSize: 18, fontWeight: FontWeight.bold)),
  //             ),
  //             Column(
  //               children: List.generate(jsonQuestions[index]["answers"].length,
  //                   (ind) {
  //                 return ListTile(
  //                   title: Text(jsonQuestions[index]["answers"][ind]["text"]),
  //                   tileColor: (_selectedInd == ind && _selectedIndex == index) ? _tileColor : null,
  //                   onTap: () => {
  //                     print(jsonQuestions[index]["answers"][ind]["text"]),
  //                     print(index),
  //                     print(ind),
  //                     _changeColor(jsonQuestions[index]["answers"][ind]["score"], index, ind)
  //                     //Dio().post("http://$baseUrl:8080/answer/$currentUser/${jsonQuestions[index]["answers"][ind]["text"]}")
  //                   },
  //                   // subtitle: Text("Score: ${jsonQuestions[index]["answers"][ind]["score"]}"),
  //                 );
  //               }),
  //             ),
  //           ],
  //         );
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Прохождение теста $testId"),
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
        itemBuilder: (context, questionIndex) {
          final question = jsonQuestions[questionIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  question['text'],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: question['answers'].length,
                itemBuilder: (context, answerIndex) {
                  final answer = question['answers'][answerIndex];
                  return ListTile(
                    tileColor: selectedAnswers[question['text']] == answerIndex
                        ? Colors.green
                        : null,
                    title: Text(answer['text']),
                    onTap: () {
                      _changeColor(question['text'], answerIndex, answer['text']);
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
