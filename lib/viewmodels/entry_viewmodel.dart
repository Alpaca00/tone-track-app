import 'package:flutter/material.dart';
import '../models/entry.dart';
import '../services/database_service.dart';

class EntryViewModel extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final List<Entry> _entries = [];

  List<Entry> get entries => _entries;

  Future<void> fetchEntries() async {
    final entriesFromDb = await _databaseService.getEntries();
    _entries
      ..clear()
      ..addAll(entriesFromDb.where((newEntry) => !_entries.contains(newEntry)));
    _sortEntriesByDate();
    notifyListeners();
  }

  void addEntry(Entry entry) async {
    if (!_entries.contains(entry)) {
      await _databaseService.saveEntry(entry);
      await fetchEntries();
      _sortEntriesByDate();
      notifyListeners();
    }
  }

  void _sortEntriesByDate() {
    _entries.sort((a, b) => b.date.compareTo(a.date));
  }
}
