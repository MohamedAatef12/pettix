import 'package:intl/intl.dart';

class DateFormatter {
  static String format(DateTime dateTime, {String pattern = 'yyyy-MM-dd'}) {
    return DateFormat(pattern).format(dateTime);
  }

  static String formatWithTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  static String formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays >= 365) return '${(diff.inDays / 365).floor()}y ago';
    if (diff.inDays >= 30) return '${(diff.inDays / 30).floor()}mo ago';
    if (diff.inDays >= 7) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays >= 1) return '${diff.inDays}d ago';
    if (diff.inHours >= 1) return '${diff.inHours}h ago';
    if (diff.inMinutes >= 1) return '${diff.inMinutes}m ago';
    return 'now';
  }
}
