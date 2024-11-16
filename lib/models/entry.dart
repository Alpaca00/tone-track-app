import 'mood.dart';

class Entry {
  final String id;
  final String note;
  final DateTime date;
  final Mood mood;

  Entry({required this.id, required this.note, required this.date, required this.mood});
}
