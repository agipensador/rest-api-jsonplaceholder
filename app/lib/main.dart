import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List? todos;
  Future<List>? getTodosFuture;

  @override
  void initState() {
    super.initState();
    getTodosFuture = getTodos();
  }

  Future<List> getTodos() async {
    final response = await http
        .get(Uri.parse("https://jsonplaceholder.typicode.com/todos/"));
    // print(response.statusCode);
    // if (response.statusCode == 200) print(response.body);

    final list = jsonDecode(response.body) as List;
    // print(list);
    // print(list.length);]
    // print(list[0]);
    return response.statusCode == 200 ? list : [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: getTodosFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return TodosList(todos: snapshot.data);
              } else {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: LinearProgressIndicator(),
                );
              }
            }),
        // child: SingleChildScrollView(
        //   child: todos == null ? LinearProgressIndicator() : TodoList(todos),
        // ),
      ),
    );
  }
}

class TodosList extends StatelessWidget {
  final List? todos;
  const TodosList({super.key, this.todos});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (_, i) => ListTile(
        leading: Text('${i + 1}'),
        title: Text(todos?[i]['title']),
      ),
      itemCount: todos?.length,
    );
  }
}
