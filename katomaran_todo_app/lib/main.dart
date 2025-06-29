import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/task_list_screen.dart';
import 'screens/add_task_screen.dart';
import 'screens/edit_task_screen.dart'; // Edit screen import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Katomaran Todo App',
      debugShowCheckedModeBanner: false, // Optional: hide debug banner
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/tasks': (context) => const TaskListScreen(),
        '/add': (context) => const AddTaskScreen(),
      },
      // 👇 Handles Edit screen navigation with task passed as arguments
      onGenerateRoute: (settings) {
        if (settings.name == '/edit') {
          final task = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => EditTaskScreen(task: task),
          );
        }
        return null;
      },
    );
  }
}
