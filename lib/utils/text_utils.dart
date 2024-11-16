
class CustomTextRenderingUtils {
  static String formatHomeListItem(dynamic entry) {
    return entry.note.length > 16 ? '${entry.note.substring(0, 16)}...' : entry
        .note;
  }
}