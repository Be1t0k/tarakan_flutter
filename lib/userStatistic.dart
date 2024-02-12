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

  var scoresData = [
    {
      "id": 9,
      "text": "1 answ 1 que",
      "score": 0,
      "clients": [
        {
          "id": 1,
          "email": "dima123@gmail.com",
          "role": {"id": 1, "title": "STUDENT"}
        }
      ]
    },
    {
      "id": 8,
      "text": "2 answ 2 que",
      "score": 20,
      "clients": [
        {
          "id": 1,
          "email": "dima123@gmail.com",
          "role": {"id": 1, "title": "STUDENT"}
        }
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    getData();
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
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("my_test_name"),
                  Checkbox(
                    checkColor: Colors.white,
                    value: selected,
                    onChanged: (bool? value) {
                      setState(() {
                        selected = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              width: 500,
              height: selected ? 0.0 : 300.0,
              alignment:
                  selected ? Alignment.center : AlignmentDirectional.topCenter,
              duration: const Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              child: ScoreChartWidget(scoresData),
            ),
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
