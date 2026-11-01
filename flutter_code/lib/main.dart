import 'package:flutter/material.dart';
import 'package:note_app/pages/note_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NoteApp());
}

class NoteApp extends StatelessWidget {
  const NoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF8FAFC),
          elevation: 0,
          scrolledUnderElevation: 2,
        ),
      ),
      home: const NotePage(),
    );
  }
}
