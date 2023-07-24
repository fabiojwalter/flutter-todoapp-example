import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/todo.dart';

const _todoKey = 'todo_list';

class TodoRepository {
  TodoRepository() {
    SharedPreferences.getInstance().then((value) => sharedPreferences = value);
  }

  late SharedPreferences sharedPreferences;

  void saveTodoList(List<Todo> todoList) {
    String jsonList = json.encode(todoList);
    sharedPreferences.setString(_todoKey, jsonList);
  }

  Future<List<Todo>> getTodoList() async {
    sharedPreferences = await SharedPreferences.getInstance();

    final String jsonString = sharedPreferences.getString(_todoKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;

    return jsonDecoded.map((e) => Todo.fromJson(e)).toList();
  }
}
