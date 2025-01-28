
import 'package:intl/intl.dart';

class CustomDateUtils {
  static String formatDate(dynamic entry) {
    return 'Date: ${DateFormat('dd MMMM yyyy, HH:mm:ss').format(entry.date)}';
  }
}
