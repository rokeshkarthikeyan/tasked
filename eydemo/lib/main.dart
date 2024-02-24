import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url = "https://jsonplaceholder.typicode.com/todos";
  List<dynamic> apiOutput = [];
  @override
  void initState() {
    super.initState();
    fetchValue(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ey demo Task'),
      ),
      body: ListView.separated(
          itemCount: apiOutput.length,
          separatorBuilder: (BuildContext context, int index) => const Divider(
                thickness: 2,
              ),
          itemBuilder: (BuildContext context, int index) {
            DataResponse itr = apiOutput[index];
            return Padding(
              padding: const EdgeInsets.all(6),
              child: SizedBox(
                height: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('title: '),
                        SizedBox(
                            width: 200,
                            child: Text(
                              itr.title!,
                              overflow: TextOverflow.ellipsis,
                            )),
                        const Spacer(),
                        const Text('Completed: '),
                        Text(itr.completed.toString()),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Row(
                      children: [
                        const Text('id: '),
                        Text(itr.id.toString()),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Future<void> fetchValue(String url) async {
    final http.Response resp = await http.get(Uri.parse(url));
    if (resp.statusCode == 200) {
      List<dynamic> decodedData = json.decode(resp.body);
      List<DataResponse> dataResponses = List<DataResponse>.from(
        decodedData.map((data) => DataResponse.fromJson(data)),
      );
      setState(() {
        apiOutput = dataResponses;
      });
    } else {
      print('Failed to load data');
    }
  }
}

class DataResponse {
  int? userId;
  int? id;
  String? title;
  bool? completed;

  DataResponse({this.userId, this.id, this.title, this.completed});

  DataResponse.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    completed = json['completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['userId'] = userId;
    data['id'] = id;
    data['title'] = title;
    data['completed'] = completed;
    return data;
  }
}
