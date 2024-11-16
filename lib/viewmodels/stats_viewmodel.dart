import 'package:flutter/material.dart';
import '../models/entry.dart';

class StatsViewModel extends ChangeNotifier {
  final Map<String, int> _moodStats = {};

  Map<String, int> get moodStats => _moodStats;

  void calculateStats(List<Entry> entries) {
    // todo: add statistics logic
    notifyListeners();
  }
}
