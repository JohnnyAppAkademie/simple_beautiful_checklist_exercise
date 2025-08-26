import 'package:flutter/material.dart';
import 'package:simple_beautiful_checklist_exercise/data/database_repository.dart';
import 'package:simple_beautiful_checklist_exercise/data/shared_preference_repository.dart';
import 'package:simple_beautiful_checklist_exercise/src/features/statistics/widgets/task_counter_card.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({
    super.key,
    required this.repository,
  });

  final DatabaseRepository repository;

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int currentTaskCount = 0;
  int finishedTaskCount = 0;
  int deletedTaskCount = 0;

  void loadItemCount() async {
    int taskCount = await widget.repository.getItemCount();
    int done = 0;
    int deleted = 0;

    /* Anzahl offener Tasks */
    if (taskCount != currentTaskCount) {
      setState(() {
        currentTaskCount = taskCount;
      });
    }

    /* Geschaffte / gelöschte Tasks */
    if (widget.repository is SharedPreferencesRepository) {
      final repo = widget.repository as SharedPreferencesRepository;
      done = await repo.getCounter(SharedPreferencesRepository.doneKey);
      deleted = await repo.getCounter(SharedPreferencesRepository.deleteKey);
    }

    setState(() {
      finishedTaskCount = done;
      deletedTaskCount = deleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    loadItemCount();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Task-Statistik"),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 60),
            TaskCounterCard(
              taskCount: currentTaskCount,
              title: "Anzahl der offenen Tasks",
            ),
            TaskCounterCard(
              taskCount: finishedTaskCount,
              title: "Anzahl der fertigen Tasks",
            ),
            TaskCounterCard(
              taskCount: deletedTaskCount,
              title: "Anzahl der gelöschten Tasks",
            ),
          ],
        ),
      ),
    );
  }
}
