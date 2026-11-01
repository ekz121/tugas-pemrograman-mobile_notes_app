# Note App (Flutter)

A complete Flutter implementation of the **Note App – Database** assignment with an upgraded modern Material 3 design, pastel card system, priority slider, importance badges, and SQLite database storage.

## Folder Structure
```
lib/
├── database/
│   └── note_database.dart       # SQLite Database helper (notes.db)
├── models/
│   └── note.dart                # Note model and fields
├── pages/
│   ├── add_edit_note_page.dart  # Form to create or update notes
│   ├── note_detail_page.dart    # Full detail view with edit/delete
│   └── note_page.dart           # Home view with search, filter & Staggered Grid
├── widgets/
│   ├── note_card_widgets.dart   # Polished pastel note cards with badges
│   └── note_form_widgets.dart   # Importance switch, priority slider, & inputs
└── main.dart                    # Application entry point
```

## Features
- **Database (`sqflite`)**: Creates `notes.db` with table `notes` containing `_id`, `isImportant`, `number`, `title`, `description`, `time`.
- **Card Staggered Grid (`flutter_staggered_grid_view`)**: 2-column masonry layout with pastel cards and dynamic heights.
- **Search & Filters**: Instant note title/description searching + Quick "Important" filter chip.
- **Priority Rating Slider**: 0 to 5 level rating with real-time feedback.
- **Importance Toggle**: Star indicator with pinned styling.
- **Detail & Actions**: Dedicated detail page with formatted date (`intl`), Edit form, and safe Delete dialog.

## How to Run in Flutter
1. Ensure Flutter SDK `>= 3.2.0` is installed.
2. In terminal run:
   ```bash
   flutter pub get
   flutter run
   ```
