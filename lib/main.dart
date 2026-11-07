import 'package:flutter/material.dart';

import 'screens/task_list_screen.dart';

/// Punto di ingresso: `runApp` monta il widget radice e avvia il rendering.
void main() {
  // `const`: istanza creata a compile-time, Flutter può evitare di ricostruirla.
  runApp(const TodoApp());
}

/// Widget radice: stateless perché configura solo tema e schermata iniziale.
class TodoApp extends StatelessWidget {
  // `super.key` (super parameter) inoltra la chiave alla superclasse.
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Fornisce Navigator, tema e ScaffoldMessenger a tutte le schermate.
    return MaterialApp(
      title: 'Le mie attività',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Genera l'intera palette Material 3 da un solo colore "seme".
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const TaskListScreen(),
    );
  }
}
