import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_constants.dart';

class HomePage {
  final WidgetTester tester;

  HomePage(this.tester);

  Finder get addButton => find.byIcon(Icons.add);

  Finder get entryText => find.textContaining('Note: My first');

  Finder get deleteIconButton => find.byIcon(Icons.delete);

  Finder get emptyStateText => find.text(TestConstants.expectedEmptyStateText);

  Future<void> tapAddButton() async {
    await tester.tap(addButton);
    await tester.pumpAndSettle();
  }

  Future<void> tapDeleteButton() async {
    await tester.tap(deleteIconButton);
    await tester.pump();
  }

  Future<void> verifyHomePageInitialState() async {
    expect(emptyStateText, findsOneWidget);
    expect(addButton, findsOneWidget);
  }

  Future<void> verifyAddedEntry() async {
    expect(entryText, findsOneWidget);
  }

  Future<void> verifyDeleteConfirmation() async {
    expect(find.textContaining(TestConstants.deleteConfirmationText),
        findsOneWidget);
    expect(
        find.textContaining(TestConstants.deleteConfirmationNo), findsWidgets);
    expect(
        find.textContaining(TestConstants.deleteConfirmationYes), findsWidgets);
  }
}
