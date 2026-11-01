import 'package:flutter/material.dart';
import 'package:note_app/database/note_database.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/widgets/note_form_widgets.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;

  const AddEditNotePage({super.key, this.note});

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;
  bool isUpdateForm = false;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 1;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
    isUpdateForm = widget.note != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isUpdateForm ? 'Edit Note' : 'Add'),
        actions: [buildButtonSave()],
      ),
      body: Form(
        key: _formKey,
        child: NoteFormWidget(
          isImportant: isImportant,
          number: number,
          title: title,
          description: description,
          onChangeIsImportant: (value) => setState(() => isImportant = value),
          onChangeNumber: (value) => setState(() => number = value),
          onChangeTitle: (value) => title = value,
          onChangeDescription: (value) => description = value,
        ),
      ),
    );
  }

  Widget buildButtonSave() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton.icon(
        icon: isSaving
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.check),
        label: const Text('Save'),
        style: ElevatedButton.styleFrom(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: isSaving
            ? null
            : () async {
                final isValid = _formKey.currentState!.validate();
                if (isValid) {
                  setState(() => isSaving = true);
                  if (isUpdateForm) {
                    await updateNote();
                  } else {
                    await addNote();
                  }
                  if (mounted) {
                    Navigator.pop(context);
                  }
                }
              },
      ),
    );
  }

  Future addNote() async {
    final note = Note(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
      createdTime: DateTime.now(),
    );
    await NoteDatabase.instance.create(note);
  }

  Future updateNote() async {
    final updatedNote = widget.note?.copy(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
      createdTime: DateTime.now(),
    );
    if (updatedNote != null) {
      await NoteDatabase.instance.updateNote(updatedNote);
    }
  }
}
