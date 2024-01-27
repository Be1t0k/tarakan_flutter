import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

Future<void> updateDisplayedName(user, name)async {
  user!.updateDisplayName(name);
  return;
}

class _AccountScreenState extends State<AccountScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final displayNameController = TextEditingController();
  String baseUrl = '192.168.0.109';
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> signOut() async {
    final navigator = Navigator.of(context);
    await FirebaseAuth.instance.signOut();
    navigator.pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios, // add custom icons also
          ),
        ),
        title: const Text('Аккаунт'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => signOut(),
          ),
        ],
      ),
      body:
      SingleChildScrollView(
          child: LayoutBuilder (builder: (context, constraint){
            return Center(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  const Text("Мои данные", style: TextStyle(fontSize: 24, color: Colors.black, letterSpacing: 1)),
                  const SizedBox(height: 55),
                  const Text("Имя студента", style: TextStyle(fontSize: 20, color: Colors.black, letterSpacing: 1)),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
                    child: TextFormField(
                      controller: displayNameController,
                      onFieldSubmitted: (text) {
                        setState(() {
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "ФИО",
                        fillColor: Colors.black,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        hintStyle: const TextStyle(color: Colors.black),
                        labelStyle: const TextStyle(color: Colors.black),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () {
                      sendInfo();
                    },
                    child: const Text('Изменить имя', style: TextStyle(fontSize: 20, color: Colors.black, letterSpacing: 1)),
                  ),
                ],
              ),
            );
          })
      ),
    );
  }

  getData() async{
    var response = await Dio().get("http://$baseUrl:8080/client/${FirebaseAuth.instance.currentUser?.email}");
    setState(() {
      displayNameController.text = response.data["displayName"].toString();
      // if (response.data["role"].toString() == "ADMIN"){
      //   isAdmin = true;
      // } else {
      //   isAdmin = false;
      // }
    });
  }

  sendInfo() {
    var displayName = displayNameController.text;
    Dio().put("http://$baseUrl:8080/client/change-name/$displayName/${FirebaseAuth.instance.currentUser?.email}");
  }

}