import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/view_models/task_view_model.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class TaskListWidget extends StatelessWidget {
  const TaskListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TaskViewModel>(context).tasks;

    if (tasks.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: tasks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: ListTile(
            title: Text(
              task.title,
              style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              task.description.isEmpty ? 'No description' : task.description,
              style: GoogleFonts.nunito(),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  task.timestamp?.toDate().toString().substring(0, 16) ?? '',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.indigo),
                  onPressed: () => _showAwesomeEditDialog(context, task),
                  tooltip: "Edit task",
                ),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.teal),
                  onPressed: () async {
                    final url = '/shared-task/${task.id}';
                    final uri = Uri.base.replace(path: url);
                    final message =
                        "Check out this shared task: ${uri.toString()}";

                    final whatsappUrl = Uri.parse(
                        "https://wa.me/?text=${Uri.encodeComponent(message)}");

                    if (await canLaunchUrl(whatsappUrl)) {
                      await launchUrl(whatsappUrl,
                          mode: LaunchMode.externalApplication);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Could not open WhatsApp")),
                      );
                    }
                  },
                  tooltip: "Share to WhatsApp",
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAwesomeEditDialog(BuildContext context, Task task) {
    final titleController = TextEditingController(text: task.title);
    final descController = TextEditingController(text: task.description);

    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.rightSlide,
      dismissOnTouchOutside: false,
      dialogBackgroundColor: Colors.white,
      width: kIsWeb && MediaQuery.of(context).size.width > 800 ? 500 : null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Edit Task',
            style:
                GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              labelStyle: GoogleFonts.nunito(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.indigo),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: descController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Description',
              labelStyle: GoogleFonts.nunito(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.indigo),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final updatedTask = Task(
                      id: task.id,
                      title: titleController.text.trim(),
                      description: descController.text.trim(),
                      sharedWith: task.sharedWith,
                      ownerId: task.ownerId,
                      timestamp: task.timestamp,
                    );
                    Provider.of<TaskViewModel>(context, listen: false)
                        .updateTask(updatedTask);
                    Navigator.of(context).pop(); 
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: GoogleFonts.nunito(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    ).show();
  }
}
