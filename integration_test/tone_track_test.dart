import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tone_track/main.dart' as app;

import 'pages/add_entry_page.dart';
import 'pages/home_page.dart';
import 'test_constants.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('E2E happy flow test: Navigation and adding an entry',
      (tester) async {
    app.main();
    await tester.pumpAndSettle();

    final homePage = HomePage(tester);
    await homePage.verifyHomePageInitialState();

    await homePage.tapAddButton();

    final addEntryPage = AddEntryPage(tester);
    await addEntryPage.verifyAddEntryPage();

    await addEntryPage.enterTextIntoTextField(TestConstants.expectedTextEntry);
    await addEntryPage.tapSaveButton();
    expect(
        find.textContaining(TestConstants.expectedAddedLabel), findsOneWidget);

    await homePage.verifyAddedEntry();
    await tester.tap(homePage.entryText);
    await tester.pumpAndSettle();

    expect(
        find.textContaining(TestConstants.expectedTextEntry), findsOneWidget);

    await homePage.tapDeleteButton();
    await homePage.verifyDeleteConfirmation();
    await tester.tap(find.textContaining(TestConstants.deleteConfirmationYes));
    await tester.pumpAndSettle();

    // todo: fix this logics
    // await homePage.verifyHomePageInitialState();
  });
}
