import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  DateTime? dueDate;
  String priority = 'low';

  Future<void> submitTask() async {
    final url = Uri.parse('http://localhost:5000/tasks');

    final task = {
      "userId": "test-user-id",
      "title": title,
      "description": description,
      "dueDate": dueDate?.toIso8601String(),
      "priority": priority,
      "status": "open"
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(task),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.pop(context); // Go back to Task List
    } else {
      print("❌ Error: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Task')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (val) => setState(() => title = val),
                validator: (val) => val!.isEmpty ? 'Enter title' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (val) => setState(() => description = val),
              ),
              const SizedBox(height: 16),
              Text("Due Date: ${dueDate != null ? dueDate!.toLocal().toString().split(' ')[0] : 'Not selected'}"),
              ElevatedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => dueDate = picked);
                },
                child: const Text("Pick Due Date"),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Priority'),
                value: priority,
                items: ['low', 'medium', 'high']
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (val) => setState(() => priority = val!),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    submitTask();
                  }
                },
                child: const Text('Submit Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
