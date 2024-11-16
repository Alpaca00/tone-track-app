import 'package:flutter/material.dart';
import '../models/entry.dart';
import '../services/database_service.dart';

class EntryViewModel extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final List<Entry> _entries = [];

  List<Entry> get entries => _entries;

  Future<void> fetchEntries() async {
    _entries.clear();
    final entriesFromDb = await _databaseService.getEntries();
    _entries.addAll(entriesFromDb);
    _sortEntriesByDate();
    notifyListeners();
  }

  void addEntry(Entry entry) async {
    await _databaseService.saveEntry(entry);
    _entries.add(entry);
    _sortEntriesByDate();
    notifyListeners();
  }

  void _sortEntriesByDate() {
    _entries.sort((a, b) => b.date.compareTo(a.date));
  }
}
