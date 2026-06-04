import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pettix/core/constants/app_texts.dart';

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

  static String formatRelativeTime(BuildContext context, String rawDate) {
    try {
      String normalizedDate = rawDate.trim();
      if (!normalizedDate.endsWith('Z') &&
          !normalizedDate.contains(RegExp(r'[+-]\d{2}:?\d{2}$'))) {
        if (!normalizedDate.contains('T') && normalizedDate.contains(' ')) {
          normalizedDate = normalizedDate.replaceFirst(' ', 'T');
        }
        normalizedDate = '${normalizedDate}Z';
      }

      final dateTime = DateTime.parse(normalizedDate).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dateTime);

      final isArabic = Localizations.localeOf(context).languageCode == 'ar';

      if (diff.inSeconds < 60) {
        return AppText.justNow;
      }

      if (diff.inMinutes < 60) {
        final minutes = diff.inMinutes;
        if (isArabic) {
          if (minutes == 1) return "دقيقة واحدة مضت";
          if (minutes == 2) return "دقيقتان مضتا";
          if (minutes >= 3 && minutes <= 10) return "$minutes دقائق مضت";
          return "$minutes دقيقة مضت";
        } else {
          return AppText.minutesAgo(minutes);
        }
      }

      if (diff.inHours < 24) {
        final hours = diff.inHours;
        if (isArabic) {
          if (hours == 1) return "ساعة واحدة مضت";
          if (hours == 2) return "ساعتان مضتا";
          if (hours >= 3 && hours <= 10) return "$hours ساعات مضت";
          return "$hours ساعة مضت";
        } else {
          return AppText.hoursAgo(hours);
        }
      }

      if (diff.inDays < 7) {
        final days = diff.inDays;
        if (isArabic) {
          if (days == 1) return "يوم واحد مضى";
          if (days == 2) return "يومان مضيا";
          if (days >= 3 && days <= 10) return "$days أيام مضت";
          return "$days يوم مضى";
        } else {
          return AppText.daysAgo(days);
        }
      }

      return DateFormat('MMM d, yyyy').format(dateTime);
    } catch (_) {
      return rawDate;
    }
  }
}
