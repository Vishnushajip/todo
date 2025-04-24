import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/view_models/shared_task_view_model.dart';
import 'package:todoapp/views/widgets/modern_text_field.dart';

class SharedTaskScreen extends StatelessWidget {
  final String taskId;
  const SharedTaskScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SharedTaskViewModel()..fetchTask(taskId),
      child: Consumer<SharedTaskViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("Shared Task", style: GoogleFonts.poppins(color: Colors.white)),
              backgroundColor: Colors.indigo,
            ),
            body: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ModernTextField(
                          controller: vm.titleController,
                          hintText: 'Enter task title...',
                          labelText: 'Task Title',
                          prefixIcon: Icons.title,
                          suffixText: 'Required',
                        ),
                        const SizedBox(height: 16),
                        ModernTextField(
                          controller: vm.descController,
                          hintText: 'Enter task description...',
                          labelText: 'Description',
                          prefixIcon: Icons.description,
                          suffixText: 'Optional',
                          maxLines: 3,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: vm.isUpdating ? null : () => vm.updateTask(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: vm.isUpdating
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  )
                                : Text(
                                    "Update Task",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
