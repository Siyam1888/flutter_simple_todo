import 'package:flutter/material.dart';
import 'package:simple_todo/screens/todo_form.dart';
import 'package:simple_todo/screens/completed_tasks.dart';
import 'package:simple_todo/task_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.orange[800],
      ),
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}
// all styles and functions of todo list

class _TodoListState extends State<TodoList> {
  // States
  final GlobalKey<AnimatedListState> _animatedListKey =
      GlobalKey<AnimatedListState>();
  List incompleteTodos = [
    {'task': 'Complete The App', 'completed': false, 'date': '19/06/21'},
    {'task': 'Learn Flutter', 'completed': false, 'date': '19/06/21'},
    {
      'task': 'Upload the app to play store',
      'completed': false,
      'date': '19/06/21'
    }
  ];
  List completedTodos = [];
  bool showForm = false;
  // Offset tweens for slide animation
  Tween<Offset> _offsetInsert = Tween(begin: Offset(-1, 0), end: Offset(0, 0));
  Tween<Offset> _offsetRemove = Tween(begin: Offset(1, 0), end: Offset(0, 0));
  // Changes the route to todoform and recieves the data
  void _goToTodoForm() async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TodoForm()));
    if (result != null) {
      setState(() {
        incompleteTodos.add(result);
        _animatedListKey.currentState?.insertItem(incompleteTodos.length - 1,
            duration: Duration(seconds: 1));
      });
    }
  }

  // Deletes a task
  void _removeItem(int index, Map currentTask) {
    setState(() {
      currentTask['completed'] = !currentTask['completed'];
      // Add item to the completed todos list
      completedTodos.add(currentTask);
      // remove from the actual list
      incompleteTodos.remove(currentTask);
      // remove from the UI with animation
      _animatedListKey.currentState?.removeItem(
          index,
          (context, animation) => TaskWidget(
                task: currentTask,
                animation: animation,
                offset: _offsetRemove,
                icon: Icon(Icons.done_all_outlined),
                onClicked: () {},
              ),
          duration: Duration(seconds: 1));
    });
  }

  void _goToCompletedTasks() async {
    int oldLength = incompleteTodos.length;
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CompletedTasks(
                  mainPageKey: _animatedListKey,
                  completedTodos: completedTodos,
                  incompleteTodos: incompleteTodos,
                  offset: _offsetInsert,
                )));

    // check how many tasks were added and add to the UI
    int changedTodosNum = incompleteTodos.length - oldLength;

    for (int i = 1; i <= changedTodosNum; i++) {
      // the index `incompleteTodos.length - 1` was causing index errors
      // insert to the UI
      _animatedListKey.currentState!.insertItem(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => _goToCompletedTasks(),
              icon: Icon(
                Icons.done_all_sharp,
              ))
        ],
      ),
      body: AnimatedList(
          key: _animatedListKey,
          initialItemCount: incompleteTodos.length,
          itemBuilder: (BuildContext context, index, animation) {
            return TaskWidget(
                task: incompleteTodos[index],
                animation: animation,
                offset: _offsetInsert,
                icon: Icon(Icons.done_outline_outlined),
                onClicked: () => _removeItem(index, incompleteTodos[index]));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _goToTodoForm(),
        child: Icon(Icons.add),
        backgroundColor: Colors.orange[900],
      ),
    );
  }
}
