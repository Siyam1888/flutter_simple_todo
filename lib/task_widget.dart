import 'package:flutter/material.dart';

class TaskWidget extends StatelessWidget {
  final Animation<double> animation;
  final Map task;
  final Tween<Offset> offset;
  final VoidCallback? onClicked;
  final VoidCallback? onClicked2;
  final bool hasLeading;
  final Icon icon;

  // Constructor of the class
  const TaskWidget(
      {required this.task,
      required this.animation,
      required this.offset,
      required this.icon,
      this.onClicked,
      this.onClicked2,
      this.hasLeading: false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool taskCompleted = task['completed'];
    String taskName = task['task'];
    return SlideTransition(
      position: offset.animate(CurvedAnimation(
        parent: animation,
        curve: Curves.fastOutSlowIn,
      )),
      child: Card(
        child: ListTile(
          title: Text(taskName),
          leading: hasLeading
              ? IconButton(
                  icon: Icon(Icons.restore, color: Colors.green),
                  onPressed: onClicked2,
                )
              : null,
          trailing: IconButton(
            icon: icon,
            color: taskCompleted ? Colors.red[500] : Colors.black,
            onPressed: onClicked,
          ),
        ),
      ),
    );
  }
}
