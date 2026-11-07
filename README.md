# Le mie attività – To-do list in Flutter

Semplice app Flutter per gestire una lista di attività (to-do list), realizzata come compito individuale per prendere familiarità con i concetti base di Flutter: composizione di widget, gestione dello stato, input dell'utente e navigazione tra schermate.

## Funzionalità

Ogni **attività** ha:

- **titolo** – testo obbligatorio;
- **stato** – *da fare* o *completata* (una nuova attività è *da fare*);
- **importanza** – importante o no (per default no).

| Requisito | Scenario | Come si usa |
|---|---|---|
| R1 – Aggiungere attività | S1 | Pulsante **"Nuova attività"** → inserire titolo, attivare eventualmente **Importante** → **Aggiungi**. Compare uno SnackBar di conferma. |
| R2 – Consultare le attività | S2 | L'elenco mostra titolo, stato (*Da fare* / *Completata*, testo barrato) e importanza (titolo in grassetto + stella). Nella barra in alto: **Completate: X / N**. |
| R3 – Aggiornare lo stato | S3 | Toccare l'attività o la sua checkbox per segnarla completata o riportarla a "da fare". Il conteggio si aggiorna subito. |
| R4 – Eliminare attività | S4 | Icona del cestino → dialogo di conferma (**Elimina** / **Annulla**). |

Varianti gestite:

- **Titolo mancante (S1):** premendo *Aggiungi* con titolo vuoto compare l'errore *"Il titolo è obbligatorio"*, che sparisce appena si scrive il titolo.
- **Rinuncia alla creazione (S1):** tornando indietro (freccia o tasto Indietro del dispositivo) non viene creata nessuna attività e non compare alcun messaggio.
- **Nessuna attività (S2):** viene mostrata un'indicazione su come aggiungerne una.
- **Rinuncia all'eliminazione (S4):** con *Annulla* (o toccando fuori dal dialogo) l'attività resta invariata.

> Le attività sono mantenute solo in memoria: alla chiusura dell'app vengono perse.

## Screenshot

| Elenco con conteggio (S2) | Errore titolo mancante (S1) |
|---|---|
| ![Elenco attività](screenshots/elenco.png) | ![Errore titolo mancante](screenshots/errore_titolo.png) |

## Struttura del progetto

```
lib/
├── main.dart                     # Punto di ingresso, MaterialApp e tema
├── models/
│   └── task.dart                 # Modello dati Task
└── screens/
    ├── task_list_screen.dart     # Elenco, conteggio, completamento, eliminazione
    └── add_task_screen.dart      # Creazione attività con validazione del titolo
test/
└── widget_test.dart              # Test di widget sui flussi principali
```

### Scelte principali

- `TaskListScreen` è uno `StatefulWidget` che contiene la lista delle attività (unica fonte di verità); il numero di completate è calcolato a partire dalla lista.
- `AddTaskScreen` non modifica la lista: restituisce il nuovo `Task` con `Navigator.pop`, e l'elenco lo riceve dal `Future` di `Navigator.push`. Se l'utente torna indietro il risultato è `null` e non succede nulla.
- La conferma di eliminazione usa `showDialog<bool>`.
- Il messaggio temporaneo di conferma usa `ScaffoldMessenger` + `SnackBar`.

## Esecuzione

Requisiti: [Flutter SDK](https://docs.flutter.dev/get-started/install) installato.

```bash
git clone https://github.com/PeppeVII/todo_app_flutter.git
cd todo_app_flutter
flutter pub get
flutter run          # su emulatore o dispositivo collegato
```

Test:

```bash
flutter test
```
