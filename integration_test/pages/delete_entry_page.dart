import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_constants.dart';

class DeleteEntryPage {
  final WidgetTester tester;

  DeleteEntryPage(this.tester);

  Finder get deleteConfirmationYes =>
      find.textContaining(TestConstants.deleteConfirmationYes);

  Finder get deleteConfirmationNo =>
      find.textContaining(TestConstants.deleteConfirmationNo);

  Finder get deleteIconButton => find.byIcon(Icons.delete);

  Finder get expectedTextEntry =>
      find.textContaining(TestConstants.expectedEntryText);

  Future<void> tapConfirmationButton(String buttonName) async {
    Finder confirmation;
    if (buttonName == 'Yes') {
      confirmation = deleteConfirmationYes;
    } else {
      confirmation = deleteConfirmationNo;
    }
    await tester.tap(confirmation);
    await tester.pumpAndSettle();
  }

  Future<void> tapDeleteButton() async {
    await tester.tap(deleteIconButton);
    await tester.pump();
  }

  Future<void> verifyEntryNoteText() async {
    expect(expectedTextEntry, findsOneWidget);
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
