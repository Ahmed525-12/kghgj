import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/task.dart';
import './screen/tabscreen.dart';
import './screen/waiting_screen.dart';
import './screen/add_task_screen.dart';
import './util/database_ref.dart' as dbref;

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Tasks(),
        ),
      ],
      child: MaterialApp(
        home: FutureBuilder(
          future: dbref.openDb(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return TabScreen();
            }
            return WaitingScreen();
          },
        ),
        routes: {
          AddTaskScreen.routename: (_) => AddTaskScreen(),
        },
      ),
    );
  }
}
