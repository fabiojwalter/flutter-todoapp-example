import 'package:flutter/material.dart';
import 'package:todoapp/pages/todo_list_page.dart';

void main() {
  runApp(const MyApp());
}

// MyApp copomnent
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoListPage(),
    );
  }
}
