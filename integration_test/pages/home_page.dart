import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_constants.dart';

class HomeEntryPage {
  final WidgetTester tester;

  HomeEntryPage(this.tester);

  Finder get addButton => find.byIcon(Icons.add);

  Finder get entryText => find.textContaining('Note: My first');

  Finder get emptyStateText => find.text(TestConstants.emptyStateText);

  Finder get expectedAddedModalText =>
      find.textContaining(TestConstants.addedModalText);

  Future<void> tapAddButton() async {
    await tester.tap(addButton);
    await tester.pumpAndSettle();
  }

  Future<void> tapEntryItem() async {
    await tester.tap(entryText);
    await tester.pumpAndSettle();
  }

  Future<void> verifyHomePageInitialState() async {
    expect(emptyStateText, findsOneWidget);
    expect(addButton, findsOneWidget);
  }

  Future<void> verifyAddedEntryItemText() async {
    expect(entryText, findsOneWidget);
  }

  Future<void> verifyModalMessageText() async {
    expect(expectedAddedModalText, findsOneWidget);
  }
}
