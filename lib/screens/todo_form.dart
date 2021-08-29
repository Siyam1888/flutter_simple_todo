import 'package:flutter/material.dart';
import 'package:simple_todo/models/task.dart';

// Widget defining the todo form screen
class TodoForm extends StatefulWidget {
  Task? initialTask;
  TodoForm({this.initialTask});

  @override
  _TodoFormState createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  // A form key that uniquely identifies the form
  final _formKey = GlobalKey<FormState>();
  // Task name
  String taskName = '';
  // Date
  String date = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Task"),
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 80),
                // Task name
                TextFormField(
                  initialValue: widget.initialTask != null
                      ? widget.initialTask!.task
                      : '',
                  decoration: InputDecoration(
                    icon: Icon(Icons.done_outline),
                    labelText: 'Task',
                    hintText: 'Add a task',
                  ),
                  onChanged: (value) => setState(() => taskName = value),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a task!';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40),
                // Date
                TextFormField(
                  initialValue: widget.initialTask != null
                      ? widget.initialTask!.date
                      : '',
                  decoration: InputDecoration(
                    icon: Icon(Icons.date_range),
                    labelText: 'Date',
                    hintText: 'Add a date',
                  ),
                  onChanged: (value) => setState(() => date = value),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the date!';
                    }
                    return null;
                  },
                ),
              ],
            ),
          )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('$taskName $date')));

              // Pop the screen and send the taskname and date back to the main screen
              Navigator.pop(
                  context, Task(task: taskName, date: date, completed: false));
            }
          },
          child: Icon(Icons.done),
          backgroundColor: Colors.amber[800]),
    );
  }
}
