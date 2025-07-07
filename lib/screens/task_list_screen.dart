import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/supabase_task_service.dart';
import 'edit_task_screen.dart';
import 'add_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final taskService = SupabaseTaskService();
  late Future<List<Task>> _taskFuture;

  @override
  void initState() {
    super.initState();
    _taskFuture = taskService.fetchTasks();
  }

  Future<void> _refreshTasks() async {
    setState(() {
      _taskFuture = taskService.fetchTasks();
    });
  }

  Future<void> _toggleCompleted(Task task) async {
    await taskService.toggleTaskCompletion(task);
    await _refreshTasks();
  }

  Future<void> _deleteTask(String id) async {
    await taskService.deleteTask(id);
    await _refreshTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Kegiatan'),
      ),
      body: FutureBuilder<List<Task>>(
        future: _taskFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          final tasks = snapshot.data ?? [];

          if (tasks.isEmpty) {
            return const Center(child: Text('Belum ada kegiatan'));
          }

          return RefreshIndicator(
            onRefresh: _refreshTasks,
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                return ListTile(
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (_) => _toggleCompleted(task),
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(
                    task.description.isNotEmpty
                        ? task.description
                        : 'Tanpa deskripsi',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteTask(task.id),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditTaskScreen(task: task),
                      ),
                    ).then((_) => _refreshTasks());
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
          if (result == true) _refreshTasks();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
