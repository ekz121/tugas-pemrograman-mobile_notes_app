import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/models/note.dart';

final _lightColors = [
  const Color(0xFFFEF3C7), // Amber
  const Color(0xFFE0F2FE), // Sky Blue
  const Color(0xFFDCFCE7), // Mint Green
  const Color(0xFFFFEDD5), // Soft Orange
  const Color(0xFFFCE7F3), // Soft Pink
  const Color(0xFFCCFBF1), // Teal
];

final _borderColors = [
  const Color(0xFFF59E0B),
  const Color(0xFF0284C7),
  const Color(0xFF10B981),
  const Color(0xFFF97316),
  const Color(0xFFEC4899),
  const Color(0xFF14B8A6),
];

class NoteCardWidget extends StatelessWidget {
  final Note note;
  final int index;

  const NoteCardWidget({
    super.key,
    required this.note,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final time = DateFormat.yMMMd().add_jm().format(note.createdTime);
    final color = _lightColors[index % _lightColors.length];
    final borderColor = _borderColors[index % _borderColors.length];
    final minHeight = getMinHeight(index);

    return Card(
      color: color,
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedCornerShape(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor.withOpacity(0.35), width: 1.2),
      ),
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Date and Importance
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    time,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey.shade800.withOpacity(0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (note.isImportant)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.star,
                      size: 13,
                      color: Colors.amber,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // Title
            Text(
              note.title,
              style: const TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 17,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            if (note.description.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                note.description,
                style: TextStyle(
                  color: const Color(0xFF334155).withOpacity(0.85),
                  fontSize: 13,
                  height: 1.35,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            const SizedBox(height: 10),

            // Footer: Priority Tag
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: borderColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Priority ${note.number}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: borderColor.shadeDarker(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double getMinHeight(int index) {
    switch (index % 4) {
      case 0:
        return 110;
      case 1:
        return 145;
      case 2:
        return 145;
      case 3:
        return 110;
      default:
        return 110;
    }
  }
}

extension ColorShade on Color {
  Color shadeDarker() {
    return Color.fromARGB(
      alpha,
      (red * 0.7).round(),
      (green * 0.7).round(),
      (blue * 0.7).round(),
    );
  }
}

RoundedCornerShape({required BorderRadius borderRadius, required BorderSide side}) =>
    RoundedRectangleBorder(borderRadius: borderRadius, side: side);
