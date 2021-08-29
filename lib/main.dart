import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_todo/screens/todo_form.dart';
import 'package:simple_todo/screens/completed_tasks.dart';
import 'package:simple_todo/widgets/task_widget.dart';
import 'package:simple_todo/utils/todo_preferences.dart';
import 'package:simple_todo/models/task.dart';

Future main() async {
  // This line is required for initializing the shared preferences library before runApp()
  WidgetsFlutterBinding.ensureInitialized();
  // initalilze SharedPreferences
  await TodoPreferences.init();
  runApp(MyApp());
}

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

  // States
  List<Task> todos = [
    Task(task: 'Task 1', date: 'Today', completed: false),
    Task(task: 'Task 2', date: 'tomorrow', completed: true)
  ];
  List<Task> incompleteTodos = [];
  List<Task> completedTodos = [];

  // Offset tweens for slide animation
  Tween<Offset> _offsetInsert = Tween(begin: Offset(-1, 0), end: Offset(0, 0));
  Tween<Offset> _offsetRemove = Tween(begin: Offset(1, 0), end: Offset(0, 0));

  // initialize the states
  @override
  void initState() {
    super.initState();

    todos = TodoPreferences.getTodos();
    classifyTodos(todos);
  }

  // move completed and incompleted todos into seperate lists
  void classifyTodos(List<Task> todos) {
    incompleteTodos = todos.where((i) => !i.completed).toList();
    completedTodos = todos.where((i) => i.completed).toList();
  }

  // Changes the route to todoform and recieves the data
  Future _goToTodoForm() async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TodoForm()));
    if (result != null) {
      setState(() {
        // add to the non persisting list
        incompleteTodos.add(result);
        // add to the UI
        _animatedListKey.currentState?.insertItem(incompleteTodos.length - 1,
            duration: Duration(seconds: 1));
      });
    }
    // add to localStorage
    await addToTodos(incompleteTodos, todos);
  }

  Future _updateTask(currentTask) async {
    var updatedTask = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TodoForm(
                  initialTask: currentTask,
                )));

    // update the temporary storage
    incompleteTodos[incompleteTodos.indexOf(currentTask)] = updatedTask;

    // update the local storage
    todos[todos.indexOf(currentTask)] = updatedTask;
    await TodoPreferences.setTodos(todos);
  }

  // Mark a task as completed
  Future _markAsCompleted(int index, Task currentTask) async {
    setState(() {
      currentTask.completed = true;

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
    // change the completed status of the task in the local storage
    await TodoPreferences.setTodos(todos);
  }

  void _goToCompletedTasks() async {
    int oldLength = incompleteTodos.length;
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CompletedTasks(
                  mainPageKey: _animatedListKey,
                  todos: todos,
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
              onClicked: () async =>
                  await _markAsCompleted(index, incompleteTodos[index]),
              updateFunc: () async => await _updateTask(incompleteTodos[index]),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await _goToTodoForm(),
        child: Icon(Icons.add),
        backgroundColor: Colors.orange[900],
      ),
    );
  }
}
