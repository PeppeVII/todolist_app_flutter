import 'package:flutter/material.dart';

import '../models/task.dart';

/// Schermata di creazione di una nuova attività (S1).
/// Non tocca la lista: restituisce il `Task` al chiamante con `pop`.
class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  // Dà accesso al testo del campo.
  final _titleController = TextEditingController();
  bool _important = false;
  // Diventa true al primo tentativo di conferma: solo da lì si mostra l'errore.
  bool _submitted = false;

  // Libera il controller quando la schermata viene chiusa (evita memory leak).
  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  // Getter calcolato: vero se il titolo, senza spazi, è vuoto.
  bool get _titleIsEmpty => _titleController.text.trim().isEmpty;

  void _confirm() {
    if (_titleIsEmpty) {
      setState(() => _submitted = true);
      return;
    }
    // Chiude la schermata restituendo il nuovo Task a `_addTask`.
    Navigator.of(context)
        .pop(Task(title: _titleController.text.trim(), important: _important));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuova attività')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Titolo',
                border: const OutlineInputBorder(),
                // null nasconde l'errore; compare solo dopo il primo tentativo.
                errorText: _submitted && _titleIsEmpty
                    ? 'Il titolo è obbligatorio'
                    : null,
              ),
              // Ricostruisce a ogni modifica, così l'errore sparisce appena corretto.
              onChanged: (_) => setState(() {}),
              // "Invio" sulla tastiera equivale a "Aggiungi".
              onSubmitted: (_) => _confirm(),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(
                _important ? Icons.star : Icons.star_border,
                color: _important ? Colors.amber : null,
              ),
              title: const Text('Importante'),
              // Il valore viene sempre dallo stato; onChanged restituisce il nuovo.
              trailing: Switch(
                value: _important,
                onChanged: (value) => setState(() => _important = value),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _confirm, child: const Text('Aggiungi')),
          ],
        ),
      ),
    );
  }
}
