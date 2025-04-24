import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/view_models/task_view_model.dart';
import 'package:todoapp/views/widgets/task_list_widget.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<TaskViewModel>(context, listen: false);
    vm.fetchTasks('demo@user.com');
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TaskViewModel>(context);
    final tasks = Provider.of<TaskViewModel>(context).tasks;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Shared TODO",
          style: GoogleFonts.nunito(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 4,
        shadowColor: Colors.indigo.withOpacity(0.3),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ModernTextField(
              controller: _titleController,
              hintText: 'Enter task title...',
              labelText: 'Task Title',
              prefixIcon: Icons.title,
              suffixText: 'Required',
              isRequired: true,
            ),
            const SizedBox(height: 16),
            ModernTextField(
              controller: _descController,
              hintText: 'Describe your task...',
              labelText: 'Task Description',
              prefixIcon: Icons.description,
              suffixText: 'Optional',
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text.trim();
                final description = _descController.text.trim();

                if (title.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Task title cannot be empty',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  );
                  return;
                }

                final task = Task(
                  id: const Uuid().v4(),
                  title: title,
                  description: description,
                  sharedWith: ['demo@user.com'],
                  ownerId: 'mock-user-id',
                  timestamp: Timestamp.now(),
                );
                vm.addTask(task);
                _titleController.clear();
                _descController.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              child: Text(
                "Add Task",
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (tasks.isNotEmpty)
            Text(
              "All Tasks",
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.indigo[800],
              ),
            ),
            const SizedBox(height: 16),
            const Expanded(child: TaskListWidget()),
          ],
        ),
      ),
    );
  }
}

class ModernTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final IconData prefixIcon;
  final String? suffixText;
  final bool isRequired;
  final int? maxLines;

  const ModernTextField({
    required this.controller,
    required this.hintText,
    required this.labelText,
    required this.prefixIcon,
    this.suffixText,
    this.isRequired = false,
    this.maxLines = 1,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.nunito(color: Colors.indigo[800]),
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.nunito(color: Colors.indigo[200]),
          labelText: labelText,
          labelStyle: GoogleFonts.nunito(color: Colors.indigo),
          prefixIcon: Icon(prefixIcon, color: Colors.indigo),
          suffixText: suffixText,
          suffixStyle: GoogleFonts.nunito(
            color: isRequired ? Colors.red[300] : Colors.grey,
            fontSize: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: false,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
        ),
      ),
    );
  }
}
