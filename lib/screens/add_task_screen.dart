import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/supabase_task_service.dart';
import '../models/task_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dailyquest2/services/notification_service.dart';
import 'dart:math';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final _taskService = SupabaseTaskService();
  bool _isSaving = false;

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );

      if (time != null) {
        setState(() {
          _selectedDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _saveTask() async {
    final title = _titleController.text.trim();
    final desc = _descriptionController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul tidak boleh kosong')),
      );
      return;
    }

    setState(() => _isSaving = true);
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengambil user ID')),
      );
      setState(() => _isSaving = false);
      return;
    }

    final newTask = Task(
      id: '',
      userId: userId,
      title: title,
      description: desc,
      dueDate: _selectedDate,
      isCompleted: false,
    );

    await _taskService.addTask(newTask);

    // ✅ Tambahkan ini: set notifikasi pengingat
    final randomId = Random().nextInt(100000);
    await NotificationService.showDailyReminder(
      id: randomId,
      title: 'Tugas: $title',
      body: desc.isNotEmpty ? desc : 'Jangan lupa selesaikan tugas ini.',
      hour: _selectedDate.hour,
      minute: _selectedDate.minute,
    );

    if (mounted) {
      Navigator.pop(context, true);
    }

    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Kegiatan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            ListTile(
              tileColor: Colors.grey[200],
              title:
                  Text(DateFormat('dd MMM yyyy – HH:mm').format(_selectedDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDateTime,
            ),
            const SizedBox(height: 30),
            _isSaving
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: _saveTask,
                    icon: const Icon(Icons.save),
                    label: const Text('Simpan'),
                  ),
          ],
        ),
      ),
    );
  }
}
