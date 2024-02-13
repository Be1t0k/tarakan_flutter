import 'package:charts_flutter_new/flutter.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:student_test_system/account_screen.dart';
import 'package:student_test_system/scoreChartWidget.dart';

void main() {
  runApp(const MaterialApp(home: UserStatistic()));
}

class UserStatistic extends StatefulWidget {
  const UserStatistic({super.key});

  @override
  State<UserStatistic> createState() => _UserStatisticState();
}

class _UserStatisticState extends State<UserStatistic> {
  var currentUser = FirebaseAuth.instance.currentUser;

  var baseUrl = "192.168.0.109";
  List<bool> isSelected = [false, false, false, false, false];
  final List<String> testObjects = [];

  var scoresData;
  // = [
    // {
    //   "id": 1,
    //   "text": "ответ_1_1",
    //   "score": 10,
    //   "clients": [
    //     {
    //       "id": 1,
    //       "email": "dima123@gmail.com",
    //       "role": {"id": 1, "title": "STUDENT"}
    //     },
    //     {
    //       "id": 1,
    //       "email": "dima123@gmail.com",
    //       "role": {"id": 1, "title": "STUDENT"}
    //     }
    //   ]
    // },
    // {
    //   "id": 4,
    //   "text": "ответ_2",
    //   "score": 200,
    //   "clients": [
    //     {
    //       "id": 1,
    //       "email": "dima123@gmail.com",
    //       "role": {"id": 1, "title": "STUDENT"}
    //     }
    //   ]
    // },
    // {
    //   "id": 6,
    //   "text": "ответ 2 второго вопроса",
    //   "score": 10,
    //   "clients": [
    //     {
    //       "id": 1,
    //       "email": "dima123@gmail.com",
    //       "role": {"id": 1, "title": "STUDENT"}
    //     }
    //   ]
    // }
  //];

  @override
  void initState() {
    super.initState();
    getData();
    getAllTests();
  }

  _buildRow(int index, var testName) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        CheckboxListTile(
        onChanged: (bool? value) async {
          setState(() {
                        isSelected[index] = value!;
                      });
          if (isSelected[index] == true) {
            var scores = await Dio().get("http://$baseUrl:8080/answer/$testName/${currentUser?.email}");
            scoresData = scores.data;
          }
        },
        title: Text(testObjects[index]), 
        value: isSelected[index],
      ),
      AnimatedContainer(
              width: 500,
              height: isSelected[index] ? 300.0 : 0.0,
              alignment:
                  isSelected[index] ? Alignment.center : AlignmentDirectional.topCenter,
              duration: const Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              child: ScoreChartWidget(scoresData),
            ),
      ],
    );
  }

  void getAllTests() async {
    List jsonList;
    var response;
    try {
      response = await Dio().get(
          "http://$baseUrl:8080/discipline/${currentUser?.email}",
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
      jsonList.forEach((item) async {
        var testList = jsonList[jsonList.indexOf(item)]['tests'] as List;
        var subTitle = jsonList[jsonList.indexOf(item)]['title'];
        testList.forEach((element) => setState(() {
              testObjects.add(testList[testList.indexOf(element)]['title']);
            }));
      });
    });
  }

  bool selected = false;

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
        body: ListView(
          children: [
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: testObjects.length,
                itemBuilder: (context, index) =>
                    _buildRow(index, testObjects[index]))
          ],
        ));
  }

  void signOutUser() {
    setState(() {
      FirebaseAuth.instance.signOut();
    });
  }

  Future<void> getData() async {
    var scores = await Dio().get(
        "http://$baseUrl:8080/answer/mobile_hardware_test/dima123@gmail.com");
    //scoresData = scores as List<Map<String, Object>>;
  }
}
