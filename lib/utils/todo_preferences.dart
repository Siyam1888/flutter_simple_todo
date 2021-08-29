import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:simple_todo/models/task.dart';

class TodoPreferences {
  static late SharedPreferences _preferences;
  static const _keyTodos = 'todos';

  static Future init() async {
    return _preferences = await SharedPreferences.getInstance();
  }

  static Future setTodos(List<Task> todos) async {
    String todosString = json.encode(todos);
    await _preferences.setString(_keyTodos, todosString);
  }

  static List<Task> getTodos() {
    List jsonList = [];
    List<Task> todosList = [];
    String? todosString = _preferences.getString(_keyTodos);

    todosString != null ? jsonList = json.decode(todosString) : null;
    todosList = jsonList.map((task) => Task.fromJson(task)).toList();
    print(todosList.runtimeType);
    return todosList;
  }
}

// check a child list and add the new items to the parent list
Future addToTodos(List<Task> childTodos, List<Task> parent) async {
  // identify new elements added on the child todos list
  List<Task> newTodos = childTodos.where((i) => !parent.contains(i)).toList();

  // update the local storage with the new todos
  parent.addAll(newTodos);
  await TodoPreferences.setTodos(parent);
}
