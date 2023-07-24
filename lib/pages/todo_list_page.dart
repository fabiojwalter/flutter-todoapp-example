import 'package:flutter/material.dart';
import 'package:todoapp/models/todo.dart';
import 'package:todoapp/pages/components/todo_list_item.dart';
import 'package:todoapp/repositories/todo_repository.dart';

// TodoList
class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();

  TodoRepository todoRepository = TodoRepository();

  List<Todo> todoList = [];

  Todo? deletedTodo;
  int? deleteTodoIndex;
  String? inputTaskErrorText;

  @override
  void initState() {
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todoList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: todoController,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (value) => addTask(),
                        decoration: InputDecoration(
                          labelText: "Task",
                          floatingLabelStyle: TextStyle(
                            color: Colors.amber.shade600,
                          ),
                          hintText: "Add your task",
                          errorText: inputTaskErrorText,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.amber.shade600,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.amber.shade600,
                              width: 2,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: addTask,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: Colors.amber.shade600,
                        ),
                        child: const Icon(Icons.add, size: 30),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: populateListView(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text("You have ${todoList.length} pendent tasks"),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextButton(
                        onPressed: clearAll,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          foregroundColor: Colors.amber.shade900,
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons
                                .delete_sweep), // Replace with your desired icon
                            Text(
                                'Remove all'), // Replace with your desired text
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<TodoListItem> populateListView() {
    // Use the `map` function to iterate over each element in the `todos` list
    return todoList
        .map((todo) => TodoListItem(todo: todo, onDelete: onDelete))
        .toList();
    // For each element (`todo`), create a new `TodoListItem` object with the `title` set to the current `todo` value
    // Convert the returned `Iterable` into a `List` using the `toList` function
  }

  void addTask() {
    String text = todoController.text;
    if (text.isEmpty) {
      setState(() {
        inputTaskErrorText = 'Task description is required';
      });
      return;
    }
    setState(() {
      inputTaskErrorText = null;
      todoList.add(Todo(title: text, dateTime: DateTime.now()));
    });
    todoController.clear();
    todoRepository.saveTodoList(todoList);
  }

  void clearAll() {
    if (todoList.isNotEmpty) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Please confirm'),
                content: const Text('Do you really want to delete all tasks?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        todoList.clear();
                      });
                      todoRepository.saveTodoList(todoList);
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Delete all'),
                  )
                ],
              ));
    }
  }

  /// Manage task deletion
  void onDelete(Todo todo) {
    deletedTodo = todo;
    deleteTodoIndex = todoList.indexOf(todo);

    setState(() {
      todoList.remove(todo);
    });
    todoRepository.saveTodoList(todoList);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Task deleted: ${todo.title}'),
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: 'Undo',
        textColor: Colors.blue.shade400,
        onPressed: () {
          setState(() {
            todoList.insert(deleteTodoIndex!, deletedTodo!);
          });
          todoRepository.saveTodoList(todoList);
        },
      ),
    ));
  }
}
