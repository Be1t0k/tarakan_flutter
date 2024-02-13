import 'package:charts_flutter_new/flutter.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:student_test_system/account_screen.dart';
import 'package:student_test_system/scoreChartWidget.dart';

import 'firebase/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
  final List<String> testObjects = [];
  late List<bool> isSelected = List<bool>.filled(testObjects.length, false);

  var scoresData;

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
          },
          title: Text(testObjects[index]),
          value: isSelected[index],
        ),
        AnimatedContainer(
          width: 500,
          height: isSelected[index] ? 300.0 : 0.0,
          alignment: isSelected[index]
              ? Alignment.center
              : AlignmentDirectional.topCenter,
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
        "http://$baseUrl:8080/answer/mobile_test/$currentUser");
    var scores_data = scores.data;
    print(scores_data);
    setState(() {
      List<Map<String, dynamic>> mapList = [];
      for (var item in scores_data) {
        if (item is Map<String, dynamic>) {
          mapList.add(item);
        }
      }
      scoresData = mapList;
    });
    print(scoresData.runtimeType);
  }
}
