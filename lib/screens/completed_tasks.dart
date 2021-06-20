import 'package:flutter/material.dart';
import 'package:simple_todo/task_widget.dart';

class CompletedTasks extends StatefulWidget {
  // Data from the home page
  List completedTodos;
  List incompleteTodos;
  final GlobalKey<AnimatedListState> mainPageKey;
  final Tween<Offset> offset;
  CompletedTasks({
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
      Map currentTask = widget.completedTodos[index];
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
    print(widget.completedTodos);
  }

  _markAsIncomplete(index) {
    setState(() {
      Map currentTask = widget.completedTodos[index];

      // Add the task to incompleteTodos
      currentTask['completed'] = false;
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
