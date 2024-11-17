import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tone_track/main.dart' as app;

import 'pages/add_entry_page.dart';
import 'pages/delete_entry_page.dart';
import 'pages/home_page.dart';
import 'test_constants.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('E2E happy flow test: Navigation and adding an entry',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();

    final homePage = HomeEntryPage(tester);
    final addEntryPage = AddEntryPage(tester);
    final deleteEntryPage = DeleteEntryPage(tester);

    await homePage.verifyHomePageInitialState();

    await homePage.tapAddButton();

    await addEntryPage.verifyAddEntryPage();

    await addEntryPage.enterEntryTextField(TestConstants.expectedEntryText);
    await addEntryPage.tapSaveButton();

    await homePage.verifyModalMessageText();

    await homePage.verifyAddedEntryItemText();
    await homePage.tapEntryItem();

    await deleteEntryPage.verifyEntryNoteText();

    await deleteEntryPage.tapDeleteButton();
    await deleteEntryPage.verifyDeleteConfirmation();

    await deleteEntryPage.tapConfirmationButton('Yes');

    await homePage.verifyHomePageInitialState();
  });
}
