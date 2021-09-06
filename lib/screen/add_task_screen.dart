import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../provider/task.dart';

class AddTaskScreen extends StatefulWidget {
  static const routename = 'add_task_screen';

  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  Task? task;
  bool _isFrist = true;
  var arg;
  var _titlecontrelar = TextEditingController();
  var _timecontrelar = TextEditingController();
  var _datecontrelar = TextEditingController();
  TimeOfDay _selectedtime = TimeOfDay.now();
  void _showTime() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then(
      (value) => setState(() {
        _selectedtime = value ?? TimeOfDay.now();
        _timecontrelar.text =
            value?.format(context) ?? TimeOfDay.now().format(context);
      }),
    );
  }

  void _showdate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 7)))
        .then((value) => setState(
              () => _datecontrelar.text =
                  DateFormat.yMMMd().format(value ?? DateTime.now()),
            ));
  }

  @override
  void didChangeDependencies() {
    if (_isFrist) {
      arg = ModalRoute.of(context)!.settings.arguments;
      print(arg);
      if (arg != null) {
        task = Provider.of<Tasks>(context, listen: false).findById(arg['id']);
        _titlecontrelar.text = task!.title;
        _timecontrelar.text = task!.time.format(context);
        _datecontrelar.text = DateFormat.yMMMd().format(task!.date);
      }
      _isFrist = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            TextField(
              controller: _titlecontrelar,
              decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.task_alt_sharp)),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _timecontrelar,
              onTap: _showTime,
              readOnly: true,
              decoration: InputDecoration(
                  labelText: 'Time',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.schedule_sharp)),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              onTap: _showdate,
              controller: _datecontrelar,
              readOnly: true,
              decoration: InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.date_range_sharp)),
            ),
            ElevatedButton(
                onPressed: () {
                  task == null
                      ? Provider.of<Tasks>(context, listen: false).addtask(
                          _titlecontrelar.text,
                          _selectedtime,
                          DateFormat().add_yMMMd().parse(_datecontrelar.text))
                      : Provider.of<Tasks>(context, listen: false).edittask(
                          arg['id'],
                          _titlecontrelar.text,
                          _selectedtime,
                          DateFormat().add_yMMMd().parse(_datecontrelar.text));

                  Navigator.pop(context);
                },
                child: Text(task == null ? 'Add Task' : 'Edit Task'))
          ],
        ),
      ),
    );
  }
}
