import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task_model.dart';

class SupabaseTaskService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Task>> fetchTasks() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User tidak login');

    final response = await _client
        .from('tasks')
        .select()
        .eq('user_id', user.id)
        .order('due_date', ascending: true);

    return (response as List)
        .map((task) => Task.fromMap(task as Map<String, dynamic>))
        .toList();
  }

  Future<void> addTask(Task task) async {
    await _client.from('tasks').insert(task.toMap());
  }

  Future<void> updateTask(Task task) async {
    await _client.from('tasks').update(task.toMap()).eq('id', task.id);
  }

  Future<void> deleteTask(String id) async {
    await _client.from('tasks').delete().eq('id', id);
  }

  Future<void> toggleTaskCompletion(Task task) async {
    await _client
        .from('tasks')
        .update({'is_completed': !task.isCompleted}).eq('id', task.id);
  }
}
