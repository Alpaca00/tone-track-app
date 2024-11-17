import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_constants.dart';

class AddEntryPage {
  final WidgetTester tester;

  AddEntryPage(this.tester);

  Finder get label => find.text(TestConstants.label);

  Finder get saveButton => find.text(TestConstants.saveButtonLabel);

  Future<void> enterTextIntoTextField(String text) async {
    await tester.enterText(find.byType(TextField), text);
  }

  Future<void> tapSaveButton() async {
    await tester.tap(saveButton);
    await tester.pump();
    await tester.pumpAndSettle();
  }

  Future<void> verifyAddEntryPage() async {
    expect(label, findsOneWidget);
    expect(saveButton, findsOneWidget);
  }
}
