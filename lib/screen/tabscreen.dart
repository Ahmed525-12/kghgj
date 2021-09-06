import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/task.dart';
import '../screen/completed_screen.dart';
import '../screen/inprogress_screen.dart';
import '../screen/tasks_screen.dart';
import './add_task_screen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _currentIndex = 0;
  late List<Map<String, dynamic>> _pages;
  @override
  void initState() {
    _pages = [
      {
        'title': 'Tasks',
        'page': TasksScreen(),
      },
      {
        'title': 'In Progress',
        'page': InProgress(),
      },
      {
        'title': 'Completed',
        'page': CompletedScreen(),
      }
    ];
    super.initState();
  }

  void _changeindex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_currentIndex]['title']),
      ),
      body: FutureBuilder(
        future: Provider.of<Tasks>(context).getData(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _pages[_currentIndex]['page'];
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
          onTap: _changeindex,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.task_alt), label: 'Tasks'),
            BottomNavigationBarItem(
                icon: Icon(Icons.archive_outlined), label: 'In Progress'),
            BottomNavigationBarItem(
                icon: Icon(Icons.done_all), label: 'Completed')
          ]),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () => Navigator.pushNamed(
                context,
                AddTaskScreen.routename,
              ),
              child: Icon(Icons.add_task),
            )
          : null,
    );
  }
}
