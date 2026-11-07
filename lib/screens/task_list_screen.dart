import 'package:flutter/material.dart';

import '../models/task.dart';
import 'add_task_screen.dart';

/// Schermata principale: elenco delle attività (S2, S3, S4).
/// Il widget è immutabile; i dati persistenti vivono nel suo `State`.
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

// Il prefisso `_` rende la classe privata al file.
class _TaskListScreenState extends State<TaskListScreen> {
  // Unica fonte di verità; solo in memoria, si perde alla chiusura dell'app.
  final List<Task> _tasks = [];

  // Stato derivato: ricalcolato ogni volta, non può andare fuori sincrono.
  int get _completedCount => _tasks.where((t) => t.completed).length;

  // S1: apre la schermata di creazione e attende il risultato.
  // `push` restituisce un Future che si completa con il valore di `pop`.
  Future<void> _addTask() async {
    final task = await Navigator.of(context)
        .push<Task>(MaterialPageRoute(builder: (_) => const AddTaskScreen()));
    // null = l'utente è tornato indietro; `mounted` va ricontrollato dopo un await.
    if (task == null || !mounted) return;
    // `setState` notifica il cambiamento e fa richiamare `build`.
    setState(() => _tasks.add(task));
    // Cascade `..`: più chiamate sullo stesso oggetto.
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('Attività "${task.title}" aggiunta')),
      );
  }

  // S3: segna come completata o riporta a "da fare".
  void _toggleTask(Task task) {
    setState(() => task.completed = !task.completed);
  }

  // S4: elimina dopo conferma.
  Future<void> _deleteTask(Task task) async {
    // Come `push`: il Future restituisce il valore passato a `pop`.
    final confirmed = await showDialog<bool>(
      context: context,
      // Questo `context` appartiene al dialogo: il `pop` chiude solo quello.
      builder: (context) => AlertDialog(
        // Doppi apici: l'apostrofo non va "escapato".
        title: const Text("Eliminare l'attività?"),
        content: Text('"${task.title}" verrà eliminata definitivamente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annulla'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );
    // `bool?`: null se si tocca fuori dal dialogo, quindi `== true`.
    // `mounted` va ricontrollato anche qui, perché c'è stato un await.
    if (confirmed == true && mounted) {
      setState(() => _tasks.remove(task));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Le mie attività'),
        // `bottom` richiede un widget con altezza dichiarata (PreferredSize).
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Completate: $_completedCount / ${_tasks.length}',
              // Legge lo stile dal tema definito in MaterialApp.
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ),
      ),
      body: _tasks.isEmpty ? _buildEmptyState(context) : _buildList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTask,
        icon: const Icon(Icons.add),
        label: const Text('Nuova attività'),
      ),
    );
  }

  // S2, variante nessuna attività.
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          // Si restringe al contenuto, così `Center` la centra in verticale.
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.checklist, size: 72, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'Nessuna attività',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tocca "Nuova attività" in basso per aggiungerne una.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    // Costruzione lazy: crea solo gli elementi visibili.
    return ListView.builder(
      // Spazio in fondo per non coprire l'ultima voce con il pulsante flottante.
      padding: const EdgeInsets.only(bottom: 96),
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return ListTile(
          onTap: () => _toggleTask(task),
          leading: Checkbox(
            value: task.completed,
            onChanged: (_) => _toggleTask(task),
          ),
          title: Text(
            task.title,
            // `null` = nessuna personalizzazione, si usa il valore del tema.
            style: TextStyle(
              fontWeight: task.important ? FontWeight.bold : null,
              decoration: task.completed ? TextDecoration.lineThrough : null,
              color: task.completed ? Colors.grey : null,
            ),
          ),
          subtitle: Text(task.completed ? 'Completata' : 'Da fare'),
          // Senza `min` la Row si espanderebbe causando un errore di layout.
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Collection if: il widget è incluso solo se la condizione è vera.
              if (task.important) const Icon(Icons.star, color: Colors.amber),
              IconButton(
                // Usato anche da VoiceOver e dai test (`find.byTooltip`).
                tooltip: 'Elimina',
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _deleteTask(task),
              ),
            ],
          ),
        );
      },
    );
  }
}
