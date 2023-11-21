// home_page.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:todolist/Taskpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TodoItem> todos = [];

  bool showTodayTasks = true;
  bool showTomorrowTasks = true;

  @override
  Widget build(BuildContext context) {
    List<TodoItem> todayTasks = [];
    List<TodoItem> tomorrowTasks = [];

    // Split tasks into Today and Tomorrow
    for (var task in todos) {
      if (task.dueToday) {
        todayTasks.add(task);
      } else {
        tomorrowTasks.add(task);
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          actions: const [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                  'https://s3-alpha-sig.figma.com/img/fe2f/6b88/3e531567a3537dc90a399876c35e4a32?Expires=1700438400&Signature=Fuu27sWwmiEliBtaD7Do4ucTAjHULxHWyx-EnjcAfss6R2nJI7~ni-raJMmr4KAXHWsWNzMmBiyNF7H25TYz9se7FXDwJZGc1LF5l7XHpKM0ciOFjU5Z5kyH26wir44~IpQaZAMzChentSla1eYrbtlvofG~0n7XDemHAaoduQe~IzPTcQ4zIdztOK4wG4kxhvrxGYTKrsfAebjjWWzuJQNRvivAPM3W-f-l7GKZDVxpYrIxeZxzmkn5uJo5KIhZ8-gtgRtbCMwNL6hxzlR-kjtTNqPsnxPLAq9MfiHXrCM6TmZnZbVVJSv8j4YdPATAnntzndG0nREDXttggjk8WQ__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4')),
            SizedBox(width: 10),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTask(
                  onAdd: (newTask) {
                    _addTodo(newTask);
                  },
                ),
              ),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.black,
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: Column(
          children: [
            _buildToggleSection('Today', showTodayTasks, () {
              setState(() {
                showTodayTasks = !showTodayTasks;
              });
            }, false),
            if (showTodayTasks) _buildTaskList(todayTasks),
            _buildToggleSection('Tomorrow', showTomorrowTasks, () {
              setState(() {
                showTomorrowTasks = !showTomorrowTasks;
              });
            }, false),
            if (showTomorrowTasks) _buildTaskList(tomorrowTasks),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(List<TodoItem> tasks) {
  return tasks.isNotEmpty
      ? Expanded(
          child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(), // Enable infinite scroll
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return ListTile(
                key: Key('todo_$index'),
                onLongPress: () {
                  _showDeleteDialog(index, tasks);
                },
                leading: Checkbox(
                  activeColor: Colors.black,
                  value: tasks[index].isCompleted,
                  onChanged: (value) {
                    _toggleTodoCompleted(tasks[index], value!);
                  },
                ),
                title: Text(
                  tasks[index].task,
                  style: TextStyle(
                    fontFamily: 'SF-Pro',
                    decoration: tasks[index].isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    color: tasks[index].isCompleted ? Colors.grey : null,
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  _formatTime(tasks[index].time),
                  style: TextStyle(
                    fontFamily: 'SF-Pro',
                    color: Colors.grey,
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              );
            },
          ),
        )
      : SizedBox.shrink();
}

Widget _buildToggleSection(
    String title, bool showTasks, VoidCallback onPressed, bool isTomorrow) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'SF-Pro',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        CupertinoButton(
          onPressed: onPressed,
          child: Text(
            showTasks ? 'Hide completely' : 'Show completely',
            style: TextStyle(
              fontFamily: 'SF-Pro',
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    ),
  );
}


  void _addTodo(Map<String, dynamic> newTask) {
    if (newTask['name'].isNotEmpty) {
      setState(() {
        todos.add(TodoItem(
          task: newTask['name'],
          isCompleted: false,
          time: newTask['time'],
          dueToday: newTask['dueToday'],
        ));
      });
    }
  }

  void _toggleTodoCompleted(TodoItem task, bool value) {
    setState(() {
      task.isCompleted = value;
    });
  }

  void _showDeleteDialog(int index, List<TodoItem> tasks) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteTodo(index, tasks);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTodo(int index, List<TodoItem> tasks) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  String _formatTime(DateTime time) {
    int hour = time.hour;
    String period = (hour < 12) ? 'AM' : 'PM';

    // Convert to 12-hour format
    if (hour > 12) {
      hour -= 12;
    } else if (hour == 0) {
      hour = 12;
    }

    final formattedTime = "$hour:${time.minute} $period";
    return formattedTime;
  }
}