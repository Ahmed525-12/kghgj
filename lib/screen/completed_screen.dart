import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/task.dart';
import '../widget/task_widget.dart';

class CompletedScreen extends StatelessWidget {
  const CompletedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _tasks = Provider.of<Tasks>(context).tasks(status: Status.Completed);
    return ListView.separated(
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
              value: _tasks[index],
              child: TaskWidget(),
            ),
        separatorBuilder: (context, index) => Divider(
              thickness: 1.5,
              height: 0,
            ),
        itemCount: _tasks.length);
  }
}
