import 'package:flutter/material.dart';
import 'package:simple_todo/models/task.dart';
import 'package:simple_todo/utils/todo_preferences.dart';
import 'package:simple_todo/widgets/task_widget.dart';

class CompletedTasks extends StatefulWidget {
  // Data from the home page
  List<Task> todos;
  List<Task> completedTodos;
  List<Task> incompleteTodos;

  final GlobalKey<AnimatedListState> mainPageKey;
  final Tween<Offset> offset;
  CompletedTasks({
    required this.todos,
    required this.completedTodos,
    required this.incompleteTodos,
    required this.offset,
    required this.mainPageKey,
  });
  @override
  _CompletedTasksState createState() => _CompletedTasksState();
}

class _CompletedTasksState extends State<CompletedTasks> {
  // a global key for the animated list
  GlobalKey<AnimatedListState> animatedListKey = GlobalKey<AnimatedListState>();

  void _removeTask(index) {
    setState(() {
      Task currentTask = widget.completedTodos[index];
      // Remove from the temporary list
      widget.completedTodos.removeAt(index);

      // remove from the local storage
      widget.todos.remove(currentTask);
      TodoPreferences.setTodos(widget.todos);

      // Remove from the UI
      animatedListKey.currentState!.removeItem(
          index,
          (context, animation) => TaskWidget(
              task: currentTask,
              animation: animation,
              offset: widget.offset,
              icon: Icon(Icons.delete)));
    });
  }

  _markAsIncomplete(index) {
    setState(() {
      Task currentTask = widget.completedTodos[index];

      // Add the task to incompleteTodos
      currentTask.completed = false;
      // save the change on the local storage
      TodoPreferences.setTodos(widget.todos);

      // add to the incomplete todos list
      widget.incompleteTodos.add(currentTask);

      // add it to the UI on function `_goToCompletedTasks` at the main.dart file

      // Remove from the actual list
      widget.completedTodos.removeAt(index);

      // Remove from the UI
      animatedListKey.currentState!.removeItem(
          index,
          (context, animation) => TaskWidget(
              task: currentTask,
              animation: animation,
              offset: widget.offset,
              icon: Icon(Icons.delete)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Completed Tasks')),
      body: AnimatedList(
        key: animatedListKey,
        initialItemCount: widget.completedTodos.length,
        itemBuilder: (BuildContext context, index, animation) => TaskWidget(
          task: widget.completedTodos[index],
          animation: animation,
          offset: widget.offset,
          icon: Icon(Icons.delete),
          hasLeading: true,
          onClicked: () => _removeTask(index),
          onClicked2: () => _markAsIncomplete(index),
        ),
      ),
    );
  }
}
