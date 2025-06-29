import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List allTasks = [];
  List filteredTasks = [];
  bool isLoading = true;
  String filter = 'all'; // all, completed, active
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final response = await http.get(Uri.parse('http://localhost:5000/tasks'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        allTasks = data;
        applyFilter();
        isLoading = false;
      });
    } else {
      print('Error: ${response.body}');
      setState(() => isLoading = false);
    }
  }

  void applyFilter() {
    List temp = [];

    if (filter == 'completed') {
      temp = allTasks.where((task) => task['status'] == 'completed').toList();
    } else if (filter == 'active') {
      temp = allTasks.where((task) => task['status'] != 'completed').toList();
    } else {
      temp = List.from(allTasks);
    }

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      temp = temp
          .where((task) =>
              task['title'].toString().toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    filteredTasks = temp;
  }

  Future<void> deleteTask(String id) async {
    final response = await http.delete(Uri.parse('http://localhost:5000/tasks/$id'));
    if (response.statusCode != 200) {
      print('❌ Delete failed: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    int completedCount = allTasks.where((task) => task['status'] == 'completed').length;
    int activeCount = allTasks.where((task) => task['status'] != 'completed').length;
    int overdueCount = allTasks.where((task) {
      final due = DateTime.tryParse(task['dueDate'] ?? '');
      return due != null && due.isBefore(DateTime.now());
    }).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width > 600)
            Container(
              width: 220,
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Overview", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Text("Total Tasks: ${allTasks.length}"),
                  Text("Completed: $completedCount"),
                  Text("Pending: $activeCount"),
                  Text("Overdue: $overdueCount"),
                  const SizedBox(height: 24),
                  const Text("Filters", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextButton(
                      onPressed: () => setState(() {
                            filter = 'all';
                            applyFilter();
                          }),
                      child: const Text("All Tasks")),
                  TextButton(
                      onPressed: () => setState(() {
                            filter = 'completed';
                            applyFilter();
                          }),
                      child: const Text("Completed")),
                  TextButton(
                      onPressed: () => setState(() {
                            filter = 'active';
                            applyFilter();
                          }),
                      child: const Text("Active")),
                ],
              ),
            ),
          // Main Area
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "My Tasks",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 200,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search tasks...',
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value;
                                  applyFilter();
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          const CircleAvatar(
                            backgroundColor: Colors.deepPurple,
                            child: Icon(Icons.person),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: filteredTasks.length,
                          itemBuilder: (context, index) {
                            final task = filteredTasks[index];
                            return Dismissible(
                              key: Key(task['_id']),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 24),
                                color: Colors.red,
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              onDismissed: (_) {
                                setState(() {
                                  allTasks.removeWhere((t) => t['_id'] == task['_id']);
                                  applyFilter();
                                });
                                deleteTask(task['_id']);
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16),
                                  title: Text(
                                    task['title'],
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 6),
                                      Text(task['description']),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.calendar_today, size: 14),
                                          const SizedBox(width: 4),
                                          Text("Due: ${task['dueDate'].split('T')[0]}"),
                                          const SizedBox(width: 12),
                                          Text(
                                            task['priority'] == 'high'
                                                ? '🔴 High Priority'
                                                : '🟡 Medium Priority',
                                            style: const TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/edit', arguments: task)
                                          .then((_) => fetchTasks());
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add').then((_) => fetchTasks()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
