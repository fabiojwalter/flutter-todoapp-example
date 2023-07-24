import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'dart:developer';

import '../../models/todo.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({
    Key? key,
    required this.todo,
    required this.onDelete,
  }) : super(key: key);

  final Todo todo;
  final Function(Todo) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          extentRatio: 0.25,
          // All actions are defined in the children parameter.
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              spacing: 2,
              onPressed: (context) {
                onDelete(todo);
              },
            ),
          ],
        ),
        child: contentItem(),
      ),
    );
  }

  Widget contentItem() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            DateFormat('dd/MM/yyyy - HH:mm').format(todo.dateTime),
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            todo.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
