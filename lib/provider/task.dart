import 'package:flutter/material.dart';
import '../util/database_ref.dart';

enum Status { Inprogress, Completed }

class Task with ChangeNotifier {
  int id;
  String title;
  DateTime date;
  TimeOfDay time;
  Status? status;
  Task(
      {required this.id,
      required this.title,
      required this.date,
      required this.time,
      this.status});
}

class Tasks with ChangeNotifier {
  List<Task> _tasks = [];

  ////////////////////////////////////////////////////////////////////////////
  List<Task> tasks({Status? status}) =>
      _tasks.where((element) => element.status == status).toList();

  ////////////////////////////////////////////////////////////////////////////
  Future<void> getData() async {
    List<Map<String, dynamic>> data =
        await database_ref!.rawQuery('select * from tasks');
    data.forEach((element) {
      String time = element['time'].substring(10, 15);

      _tasks.add(
        Task(
          id: element['id'],
          title: element['title'],
          date: DateTime.parse(element['date']),
          time: TimeOfDay(
              hour: int.parse(time.split(':')[0]),
              minute: int.parse(time.split(':')[1])),
          status: convertToString(element['status']),
        ),
      );
    });
  }

  ////////////////////////////////////////////////////////////////////////////

  Future<void> addtask(String title, TimeOfDay time, DateTime date) async {
    int? id;
    await database_ref!.transaction((txn) async {
      id = await txn.rawInsert(
          'insert into tasks(title,time,date) values("$title","$time","$date") ');
      print(id);
    });
    // _tasks.add(Task(id: id!, title: title, date: date, time: time));
    notifyListeners();
  }

  ////////////////////////////////////////////////////////////////////////////
  Task? findById(int id) {
    _tasks.firstWhere((element) => element.id == id);
  }
////////////////////////////////////////////////////////////////////////////

  Future<void> edittask(
      int id, String title, TimeOfDay time, DateTime date) async {
    await database_ref!.rawUpdate(
        'UPDATE tasks SET title = "$title",time="$time",date="$date" WHERE id = $id');
    _tasks.add(Task(id: id, title: title, date: date, time: time));
    notifyListeners();
  }
  ////////////////////////////////////////////////////////////////////////////

  Future<void> changestatus(Status status, int id) async {
    await database_ref!.rawUpdate(
        'UPDATE tasks SET status = "${convertFromStatus(status)}" WHERE id = $id');

    _tasks.firstWhere((element) => element.id == id).status = status;
    notifyListeners();
  }

////////////////////////////////////////////////////////////////////////////
  Future<void> removeTask(int id) async {
    await database_ref!.rawDelete('DELETE FROM tasks WHERE id = $id');
    _tasks.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  ////////////////////////////////////////////////////////////////////////////
  String convertFromStatus(Status status) {
    if (status == Status.Completed) {
      return 'Completed';
    }
    return 'Inprogress';
  }

  ////////////////////////////////////////////////////////////////////////////
  Status? convertToString(String? status) {
    if (status == 'Completed') {
      return Status.Completed;
    } else if (status == 'Inprogress') {
      return Status.Inprogress;
    } else {
      return null;
    }
  }
}
