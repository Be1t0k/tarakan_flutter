import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:student_test_system/creatingSubject.dart';
import 'package:student_test_system/testList.dart';
import 'package:student_test_system/userStatistic.dart';
import 'account_screen.dart';
import 'auth_page.dart';
import 'firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(home: Main()));
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int index = 0;
  bool isAdmin = true;
  bool gotRole = false;

  var baseUrl = '192.168.0.109';

  @override
  void initState() {
    super.initState();
  }

  final screens = [
    const UserStatistic(),
    const CreatingSubject(),
    const TestList(),
  ];

  @override
  Widget build(BuildContext context) {
    if (!gotRole) {
      gotRole = true;
      getRole();
    }
    if (FirebaseAuth.instance.currentUser != null) {
      return Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: signOutUser,
              icon: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AccountScreen()),
                  );
                },
                icon: const Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
              ),
              color: Colors.red[600],
            )
          ],
        ),
        body: screens[index],
        bottomNavigationBar: NavigationBar(
          backgroundColor: Colors.blueAccent,
          height: 55,
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() => this.index = index),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.info_outline, color: Colors.white),
                label: 'Statistic'),
            NavigationDestination(
                icon: Icon(Icons.add, color: Colors.white), label: 'Subjects'),
            NavigationDestination(
                icon: Icon(Icons.table_chart_sharp, color: Colors.white),
                label: 'Tests'),
          ],
        ),
      );
    } else {
      return const AuthPage();
    }
  }

  void signOutUser() {
    setState(() {
      FirebaseAuth.instance.signOut();
    });
  }

  Future<bool> getRole() async {
    var response = await Dio().get(
        "http://${baseUrl}:8080/lowUser/${FirebaseAuth.instance.currentUser?.email}");
    setState(() {
      if (response.toString() == "ADMIN") {
        isAdmin = true;
      } else {
        isAdmin = false;
      }
      print(response.toString());
      print(isAdmin);
    });

    return isAdmin;
  }
}
