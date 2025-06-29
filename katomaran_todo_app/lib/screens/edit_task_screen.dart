import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditTaskScreen extends StatefulWidget {
  final Map task;
  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;
  late String priority;
  DateTime? dueDate;

  @override
  void initState() {
    super.initState();
    title = widget.task['title'];
    description = widget.task['description'];
    priority = widget.task['priority'];
    dueDate = DateTime.tryParse(widget.task['dueDate'] ?? '');
  }

  Future<void> updateTask() async {
    final url = Uri.parse('http://localhost:5000/tasks/${widget.task['_id']}');

    final updatedTask = {
      "userId": widget.task['userId'],
      "title": title,
      "description": description,
      "dueDate": dueDate?.toIso8601String(),
      "priority": priority,
      "status": widget.task['status'],
    };

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(updatedTask),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context, true); // return true to refresh list
    } else {
      print('Update failed: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (val) => setState(() => title = val),
                validator: (val) => val!.isEmpty ? 'Enter title' : null,
              ),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (val) => setState(() => description = val),
              ),
              const SizedBox(height: 16),
              Text("Due Date: ${dueDate != null ? dueDate!.toLocal().toString().split(' ')[0] : 'Not selected'}"),
              ElevatedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: dueDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => dueDate = picked);
                },
                child: const Text("Pick Due Date"),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: priority,
                decoration: const InputDecoration(labelText: 'Priority'),
                items: ['low', 'medium', 'high']
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (val) => setState(() => priority = val!),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateTask();
                  }
                },
                child: const Text('Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
