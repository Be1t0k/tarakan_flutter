import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Прохождение теста $testId"),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            SizedBox()
            // Text(questionList[questionsCount]['text'].toString(), style: const TextStyle(fontSize: 28), textAlign: TextAlign.center),
            // Padding(
            //   padding: const EdgeInsets.all(14.0),
            //       child: ListView.builder(
            //           scrollDirection: Axis.vertical,
            //           shrinkWrap: true,
            //           physics: const NeverScrollableScrollPhysics(),
            //           itemBuilder: (BuildContext context, int index) {
            //           return Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: InkWell(
            //               child: Container(
            //                   padding: const EdgeInsets.all(15.0),
            //                   decoration: BoxDecoration(
            //                     border: Border.all(width: 1.0, color: Colors.grey),
            //                     borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            //                   ),
            //                   child: Row(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     children: [
            //                       Expanded(child: Text(questionList[questionsCount]['answers'][index]['text'].toString(), style: TextStyle(fontSize: 24), textAlign: TextAlign.center)),
            //                     ],
            //                   )),
            //                 onTap: () =>{
            //                   answerScore[questionList[questionsCount]['answers'][index]['criterion']['title']] =
            //                   answerScore[questionList[questionsCount]['answers'][index]['criterion']['title']]! + questionList[questionsCount]['answers'][index]['criterionScore'] as int,
            //                   setState(() {
            //                     if (questionsCount < jsonQuestions.length - 1)
            //                       questionsCount++;
            //                     else {
            //                       Navigator.pop(context,true);
            //                       showDialog(
            //                           context: context,
            //                           builder: (context) {
            //                             Future.delayed(const Duration(seconds: 2), () {
            //                               Navigator.of(context).pop(true);
            //                             });
            //                             return const AlertDialog(
            //                               title: Text('Тест пройден'),
            //                             );
            //                           }
            //                       );
            //                       Dio().post("http://$baseUrl:8080/characteristic/$testId?user_login=${currentUser?.email}", data: answerScore);
            //                     }
            //                   }),
            //                 }
            //             ),
            //           );
            //           },
            //           itemCount: counterAnswers[questionsCount + 1],
            //       ),
            // )
          ],
        ),
      ),
    );
  }

  // var jsonQuestions = [];
  // var questionList = [];
  var answers = [];
  Map<int, int> counterAnswers = {};

  Future<void> _getData() async {
    List jsonQuestions;
    List answerQuestion;

    var questions = await Dio().get("http://$baseUrl:8080/question/$testId");
    jsonQuestions = questions.data as List;
    jsonQuestions.forEach((index) {
      print(jsonQuestions[jsonQuestions.indexOf(index)]['text']);
      answerQuestion =
          jsonQuestions[jsonQuestions.indexOf(index)]['answers'] as List;
      answerQuestion.forEach((element) {
        print("_-----=-------=--------");
        print(answerQuestion[answerQuestion.indexOf(element)]['text']);
      });
    });
  }
}
