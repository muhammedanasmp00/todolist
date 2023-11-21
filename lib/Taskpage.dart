// add_task.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;

  AddTask({Key? key, required this.onAdd}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController _textEditingController = TextEditingController();
  DateTime time = DateTime.now();
  bool switchValue = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          title: Row(
            children: [
              SizedBox(width: 50),
              Text(
                'Task',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
          leadingWidth: 100,
          leading: TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Container(
              width: 15,
              child: Icon(Icons.arrow_back_ios_new_rounded),
            ),
            label: Container(
              width: 47,
              child: Text(
                'Close',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  'Add a task',
                  style: TextStyle(
                    fontFamily: 'SF-Pro',
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        'Name',
                        style: TextStyle(
                          fontFamily: 'SF-Pro',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.38,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(30),
                        height: 30,
                        width: 200,
                        color: Color.fromARGB(255, 255, 255, 255),
                        child: TextField(
                          controller: _textEditingController,
                          decoration: InputDecoration(
                              hintText: 'Enter a Task',
                              hintStyle: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Hour',
                        style: TextStyle(
                          fontFamily: 'SF-Pro',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.38,
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Container(
                        height: 40,
                        width: 170,
                        child: CupertinoDatePicker(
                          initialDateTime: time,
                          mode: CupertinoDatePickerMode.time,
                          use24hFormat: false,
                          onDateTimeChanged: (DateTime newTime) {
                            setState(() => time = newTime);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 37),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Today',
                        style: TextStyle(
                          fontFamily: 'SF-Pro',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.38,
                        ),
                      ),
                      SizedBox(
                        width: 210,
                      ),
                      CupertinoSwitch(
                        activeColor: Colors.green,
                        thumbColor: Colors.white,
                        trackColor: Colors.black12,
                        value: switchValue,
                        onChanged: (value) =>
                            setState(() => switchValue = value),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 60,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Create a Map representing the task details
                    Map<String, dynamic> newTask = {
                      'name': _textEditingController.text,
                      'time': time,
                      'dueToday': switchValue,
                    };

                    // Call the onAdd callback with the task details
                    widget.onAdd(newTask);

                    // Close the current screen
                    Navigator.of(context).pop({});
                  },
                  child: Container(
                    height: 46,
                    width: 316,
                    child: Center(
                      child: Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 27,
                  ),
                  Text(
                    'If you disable today, the task will be considered as \ntomorrow',
                    style: TextStyle(fontFamily: 'SF-Pro', color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TodoItem {
  String task;
  bool isCompleted;
  DateTime time;
  bool dueToday;

  TodoItem({
    required this.task,
    required this.isCompleted,
    required this.time,
    required this.dueToday,
  });
}
