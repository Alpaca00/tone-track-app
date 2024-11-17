import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'package:tone_track/models/entry.dart';
import 'package:tone_track/pages/home_page.dart';
import 'package:tone_track/viewmodels/entry_viewmodel.dart';

class MockEntryViewModel extends Mock implements EntryViewModel {}

void main() {
  late MockEntryViewModel mockEntryViewModel;

  setUp(() {
    mockEntryViewModel = MockEntryViewModel();
  });

  testWidgets('Should display loading indicator when entries are empty',
      (tester) async {
    when(mockEntryViewModel.entries).thenReturn(<Entry>[]);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: mockEntryViewModel,
        child: const HomePage(),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
