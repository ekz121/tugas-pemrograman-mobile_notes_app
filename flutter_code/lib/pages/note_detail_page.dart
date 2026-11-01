import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/database/note_database.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/pages/add_edit_note_page.dart';

class NoteDetailPage extends StatefulWidget {
  final int id;

  const NoteDetailPage({super.key, required this.id});

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);
    note = await NoteDatabase.instance.getNoteById(widget.id);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page'),
        actions: [
          if (!isLoading) ...[
            editButton(),
            deleteButton(),
          ]
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Top Meta: Important tag and Priority Level
                Row(
                  children: [
                    if (note.isImportant)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.amber.shade400),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, size: 14, color: Colors.amber),
                            SizedBox(width: 4),
                            Text(
                              'Important',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Text(
                        'Priority Level: ${note.number}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  note.title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),

                // Formatted Creation Time
                Row(
                  children: [
                    Icon(Icons.schedule, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat.yMMMd().add_jms().format(note.createdTime),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),

                // Description
                Text(
                  note.description,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.5,
                  ),
                ),
              ],
            ),
    );
  }

  Widget editButton() => IconButton(
        icon: const Icon(Icons.edit_outlined),
        tooltip: 'Edit Note',
        onPressed: () async {
          if (isLoading) return;
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditNotePage(note: note),
            ),
          );
          refreshNote();
        },
      );

  Widget deleteButton() => IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        tooltip: 'Delete Note',
        onPressed: () async {
          if (isLoading) return;

          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Note'),
              content: Text('Are you sure you want to delete "${note.title}"?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );

          if (confirm == true) {
            await NoteDatabase.instance.deleteNoteById(widget.id);
            if (mounted) {
              Navigator.pop(context);
            }
          }
        },
      );
}
