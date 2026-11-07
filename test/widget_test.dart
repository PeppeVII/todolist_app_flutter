import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:todo_app/main.dart';

void main() {
  testWidgets('aggiunta, completamento ed eliminazione', (tester) async {
    await tester.pumpWidget(const TodoApp());
    expect(find.text('Nessuna attività'), findsOneWidget);
    expect(find.text('Completate: 0 / 0'), findsOneWidget);

    // Titolo mancante: errore, poi scompare quando si corregge.
    await tester.tap(find.text('Nuova attività'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aggiungi'));
    await tester.pump();
    expect(find.text('Il titolo è obbligatorio'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Studiare Flutter');
    await tester.pump();
    expect(find.text('Il titolo è obbligatorio'), findsNothing);

    await tester.tap(find.text('Aggiungi'));
    await tester.pumpAndSettle();
    expect(find.text('Studiare Flutter'), findsOneWidget);
    expect(find.text('Attività "Studiare Flutter" aggiunta'), findsOneWidget);
    expect(find.text('Completate: 0 / 1'), findsOneWidget);

    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(find.text('Completate: 1 / 1'), findsOneWidget);

    // Eliminazione: prima rinuncia, poi conferma.
    await tester.tap(find.byTooltip('Elimina'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Annulla'));
    await tester.pumpAndSettle();
    expect(find.text('Studiare Flutter'), findsOneWidget);

    await tester.tap(find.byTooltip('Elimina'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Elimina'));
    await tester.pumpAndSettle();
    expect(find.text('Nessuna attività'), findsOneWidget);
  });
}
