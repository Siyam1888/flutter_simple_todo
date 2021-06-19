import 'package:flutter/material.dart';
import 'package:simple_todo/screens/todo_form.dart';

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
  List todos = [
    {'task': 'Complete The App', 'completed': false, 'date': '19/06/21'},
    {'task': 'Learn Flutter', 'completed': false, 'date': '19/06/21'},
    {
      'task': 'Upload the app to play store',
      'completed': false,
      'date': '19/06/21'
    }
  ];
  bool showForm = false;
  Tween<Offset> _offsetInsert = Tween(begin: Offset(-1, 0), end: Offset(0, 0));
  Tween<Offset> _offsetRemove = Tween(begin: Offset(1, 0), end: Offset(0, 0));
  // Changes the route to todoform and recieves the data
  void _goToTodoForm() async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => TodoForm()));
    if (result != null) {
      setState(() {
        todos.add(result);
        _animatedListKey.currentState
            ?.insertItem(todos.length - 1, duration: Duration(seconds: 1));
      });
    }
  }

  // Deletes a task
  void _removeItem(index, currentTask) {
    setState(() {
      todos[index]['completed'] = !todos[index]['completed'];
      // remove from the actual list
      todos.removeAt(index);
      // remove from the UI with animation
      // not using the slide transition here caused me a great headache!
      _animatedListKey.currentState?.removeItem(
          index,
          (context, animation) => SlideTransition(
              position: _offsetRemove.animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: Card(
                child: ListTile(
                  title: Text(
                    currentTask,
                  ),
                  trailing: Icon(Icons.done_outline_outlined,
                      color: Colors.orange[900]),
                ),
              )),
          duration: Duration(seconds: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        centerTitle: true,
      ),
      body: AnimatedList(
          key: _animatedListKey,
          initialItemCount: todos.length,
          itemBuilder: (BuildContext context, index, animation) {
            bool taskCompleted = todos[index]['completed'];
            String currentTask = todos[index]['task'];

            // Transition
            return SlideTransition(
              position: _offsetInsert.animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: Card(
                child: ListTile(
                  title: Text(currentTask),
                  trailing: IconButton(
                    icon: taskCompleted
                        ? Icon(Icons.done_outline)
                        : Icon(Icons.done_outline_outlined),
                    color: taskCompleted ? Colors.orange[900] : Colors.black,
                    onPressed: () => _removeItem(index, currentTask),
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _goToTodoForm(),
        child: Icon(Icons.add),
        backgroundColor: Colors.orange[900],
      ),
    );
  }
}
