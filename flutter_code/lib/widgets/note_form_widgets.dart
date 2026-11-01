import 'package:flutter/material.dart';

class NoteFormWidget extends StatelessWidget {
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final ValueChanged<bool> onChangeIsImportant;
  final ValueChanged<int> onChangeNumber;
  final ValueChanged<String> onChangeTitle;
  final ValueChanged<String> onChangeDescription;

  const NoteFormWidget({
    super.key,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.onChangeIsImportant,
    required this.onChangeNumber,
    required this.onChangeTitle,
    required this.onChangeDescription,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Importance & Priority Settings Card
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: isImportant ? Colors.amber : Colors.grey,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Mark as Important',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              isImportant ? 'Pinned note' : 'Standard note',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: isImportant,
                        activeColor: Colors.amber.shade700,
                        onChanged: onChangeIsImportant,
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Priority Level (0 - 5)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Level $number',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: number.toDouble(),
                    min: 0,
                    max: 5,
                    divisions: 5,
                    label: '$number',
                    onChanged: (value) => onChangeNumber(value.toInt()),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          buildTitleField(),
          const SizedBox(height: 16),
          buildDescriptionField(),
        ],
      ),
    );
  }

  Widget buildTitleField() => TextFormField(
        maxLines: 1,
        initialValue: title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          labelText: 'Title',
          hintText: 'Note title...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.withOpacity(0.04),
        ),
        validator: (title) =>
            title != null && title.trim().isEmpty ? 'The title cannot be empty' : null,
        onChanged: onChangeTitle,
      );

  Widget buildDescriptionField() => TextFormField(
        maxLines: 10,
        initialValue: description,
        style: const TextStyle(fontSize: 16, height: 1.4),
        decoration: InputDecoration(
          labelText: 'Description',
          hintText: 'Type something...',
          alignLabelWithHint: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.withOpacity(0.04),
        ),
        validator: (desc) =>
            desc != null && desc.trim().isEmpty ? 'The desc cannot be empty' : null,
        onChanged: onChangeDescription,
      );
}
