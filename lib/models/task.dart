/// Un'attività della to-do list (modello dati, indipendente dalla UI).
class Task {
  // Parametri nominali: `required` per il titolo, default per gli altri.
  Task({required this.title, this.important = false, this.completed = false});

  final String title;
  final bool important;

  // Mutabile per semplicità; in alternativa: classe immutabile + `copyWith`.
  bool completed;
}
