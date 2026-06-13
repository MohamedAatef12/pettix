import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pettix/core/utils/date_formatter.dart';

void main() {
  testWidgets('DateFormatter.formatRelativeTime Arabic tests', (tester) async {
    late String resultJustNow;
    late String result1Min;
    late String result2Min;
    late String result5Min;
    late String result1Hour;
    late String result2Hours;
    late String result5Hours;
    late String result1Day;
    late String result2Days;
    late String result5Days;

    final now = DateTime.now();

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Builder(
          builder: (context) {
            // Test 1: Just now (less than 60s)
            resultJustNow = DateFormatter.formatRelativeTime(
              context,
              now.toUtc().toIso8601String(),
            );

            // Test 2: 1 minute ago
            result1Min = DateFormatter.formatRelativeTime(
              context,
              now.subtract(const Duration(minutes: 1)).toUtc().toIso8601String(),
            );

            // Test 3: 2 minutes ago
            result2Min = DateFormatter.formatRelativeTime(
              context,
              now.subtract(const Duration(minutes: 2)).toUtc().toIso8601String(),
            );

            // Test 4: 5 minutes ago
            result5Min = DateFormatter.formatRelativeTime(
              context,
              now.subtract(const Duration(minutes: 5)).toUtc().toIso8601String(),
            );

            // Test 5: 1 hour ago
            result1Hour = DateFormatter.formatRelativeTime(
              context,
              now.subtract(const Duration(hours: 1)).toUtc().toIso8601String(),
            );

            // Test 6: 2 hours ago
            result2Hours = DateFormatter.formatRelativeTime(
              context,
              now.subtract(const Duration(hours: 2)).toUtc().toIso8601String(),
            );

            // Test 7: 5 hours ago
            result5Hours = DateFormatter.formatRelativeTime(
              context,
              now.subtract(const Duration(hours: 5)).toUtc().toIso8601String(),
            );

            // Test 8: 1 day ago
            result1Day = DateFormatter.formatRelativeTime(
              context,
              now.subtract(const Duration(days: 1)).toUtc().toIso8601String(),
            );

            // Test 9: 2 days ago
            result2Days = DateFormatter.formatRelativeTime(
              context,
              now.subtract(const Duration(days: 2)).toUtc().toIso8601String(),
            );

            // Test 10: 5 days ago
            result5Days = DateFormatter.formatRelativeTime(
              context,
              now.subtract(const Duration(days: 5)).toUtc().toIso8601String(),
            );

            return const SizedBox();
          },
        ),
      ),
    );

    // Let's assert that the Arabic formatting matches Cairo grammatical rules
    expect(resultJustNow, isNotEmpty);
    expect(result1Min, equals('دقيقة واحدة مضت'));
    expect(result2Min, equals('دقيقتان مضتا'));
    expect(result5Min, equals('5 دقائق مضت'));
    expect(result1Hour, equals('ساعة واحدة مضت'));
    expect(result2Hours, equals('ساعتان مضتا'));
    expect(result5Hours, equals('5 ساعات مضت'));
    expect(result1Day, equals('يوم واحد مضى'));
    expect(result2Days, equals('يومان مضيا'));
    expect(result5Days, equals('5 أيام مضت'));
  });
}
