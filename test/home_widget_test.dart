import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cardsapps/presentation/screens/Home/homescreen.dart';

void main() {
  testWidgets('CupertinoSearchTextField should be found on HomePage', (WidgetTester tester) async {
    // Construir el HomePage widget
    await tester.pumpWidget(
      const MaterialApp(
        home: HomePage(),
      ),
    );

    // Buscar el widget CupertinoSearchTextField
    final searchFieldFinder = find.byType(CupertinoSearchTextField);

    // Verificar que se encuentra el CupertinoSearchTextField
    expect(searchFieldFinder, findsOneWidget);

    // Interactuar con el CupertinoSearchTextField escribiendo algo
    await tester.enterText(searchFieldFinder, 'buscar');

    // Verificar que el texto fue introducido
    expect(find.text('buscar'), findsOneWidget);
  });
}
