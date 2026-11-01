import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_app/database/note_database.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/pages/add_edit_note_page.dart';
import 'package:note_app/pages/note_detail_page.dart';
import 'package:note_app/widgets/note_card_widgets.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late List<Note> notes;
  bool isLoading = false;
  String searchQuery = '';
  bool filterImportantOnly = false;

  @override
  void initState() {
    super.initState();
    notes = [];
    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    notes = await NoteDatabase.instance.getAllNotes();
    setState(() => isLoading = false);
  }

  List<Note> get filteredNotes {
    return notes.where((note) {
      final matchesQuery = searchQuery.isEmpty ||
          note.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          note.description.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesFilter = !filterImportantOnly || note.isImportant;
      return matchesQuery && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final displayNotes = filteredNotes;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text(
              'Notes',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${displayNotes.length}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search & Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => searchQuery = ''),
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) => setState(() => searchQuery = val),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('All Notes'),
                  selected: !filterImportantOnly,
                  onSelected: (val) {
                    if (val) setState(() => filterImportantOnly = false);
                  },
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      SizedBox(width: 4),
                      Text('Important'),
                    ],
                  ),
                  selected: filterImportantOnly,
                  onSelected: (val) {
                    setState(() => filterImportantOnly = val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Grid View or Empty State
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : displayNotes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.note_alt_outlined,
                              size: 72,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              searchQuery.isNotEmpty ? 'No notes matched' : 'Notes Kosong',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Tap + button to create a new note',
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      )
                    : MasonryGridView.count(
                        padding: const EdgeInsets.all(12),
                        crossAxisCount: 2,
                        itemCount: displayNotes.length,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        itemBuilder: (context, index) {
                          final note = displayNotes[index];
                          return GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NoteDetailPage(id: note.id!),
                                ),
                              );
                              refreshNotes();
                            },
                            child: NoteCardWidget(note: note, index: index),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditNotePage()),
          );
          refreshNotes();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
