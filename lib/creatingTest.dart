import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:student_test_system/creatingQuestion.dart';

void main() {
  runApp(const MaterialApp(home: CreatingTest("Не пришел name_test с прошлой страницы (создания предмета)")));
}

class CreatingTest extends StatefulWidget {
  const CreatingTest(this.nameSub, {super.key});

  final String nameSub;

  @override
  State<CreatingTest> createState() => _CreatingTestState(nameSub);
}

class _CreatingTestState extends State<CreatingTest> {
  
  var testNameController = TextEditingController();
  final String nameSub;
  final List<String> testObjects = [];

  String baseUrl = "192.168.0.107";
  
  _CreatingTestState(this.nameSub);

  @override
  void initState() {
    super.initState();
    getAllTests();
  }

  int value = 2;

  _addItem() {
    setState(() {
      value = value + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Тесты дисциплины $nameSub"),
      ),
      body: 
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: testObjects.length,
            itemBuilder: (context, index) => _buildRow(index, testObjects[index])),
      floatingActionButton: OutlinedButton(
          onPressed: () => _dialogBuilder(context),
          child: const Text('Добавить тест'),
        ),
    );
  }

  _buildRow(int index, var testName) {
    return Card(
      child: ListTile(
        onTap: () {
          Navigator.of(context).pop;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreatingQuestion(testObjects[index])));
        },
        title: Text(testObjects[index]),
        subtitle: Text('subtitle$index'),
      ),
    );
  }

Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Создание теста'),
          content: 
  TextFormField(
          controller: testNameController,
          onFieldSubmitted: (text) {
            setState(() {
              Dio()
                  .post("http://$baseUrl:8080/test", data: {'title': text});
            });
          },
          decoration: const InputDecoration(
            labelText: 'Название теста',
          ),
        ),
          actions: <Widget>[
            
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Создать'),
              onPressed: () {
                goPush();
              },
            ),
          ],
        );
      },
    );
  }

  goPush() {
    Navigator.pop(context);
    setState(() {
      Dio().post("http://$baseUrl:8080/test/$nameSub",
          data: {'title': testNameController.text});
      value = value + 1;
    });
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreatingQuestion(testNameController.text)))
          .then((_) => setState(() {
                testNameController.text = "";
              }));
  }

  void getAllTests() async {
    List jsonList;
    var response;
    try {
      response = await Dio().get("http://$baseUrl:8080/test",
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
          value++;
          testObjects.add(jsonList[jsonList.indexOf(item)]['title']);
        });
      });
    });
  }
}
