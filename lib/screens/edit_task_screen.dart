import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../services/supabase_task_service.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  final taskService = SupabaseTaskService();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);
    _selectedDate = widget.task.dueDate;
  }

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _updateTask() async {
    final title = _titleController.text.trim();
    final desc = _descriptionController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul tidak boleh kosong')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final updatedTask = widget.task.copyWith(
      title: title,
      description: desc,
      dueDate: _selectedDate,
    );

    await taskService.updateTask(updatedTask);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kegiatan berhasil diperbarui')),
      );
      Navigator.pop(context); // Kembali ke list
    }

    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatted =
        DateFormat('dd MMM yyyy, HH:mm').format(_selectedDate);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Kegiatan')),
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
              onTap: _pickDateTime,
              title: Text(dateFormatted),
              leading: const Icon(Icons.calendar_today),
            ),
            const SizedBox(height: 30),
            _isSaving
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    onPressed: _updateTask,
                    icon: const Icon(Icons.save),
                    label: const Text('Simpan Perubahan'),
                  ),
          ],
        ),
      ),
    );
  }
}
