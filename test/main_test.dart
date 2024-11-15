import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/main.dart';
import 'package:untitled/set_alarm.dart';
import 'package:untitled/play_puzzle.dart';
import 'package:untitled/settings.dart';

void main() {
  group('Main Screen Tests', () {
    testWidgets('should display "No alarms set" when there are no alarms',
            (WidgetTester tester) async {
          await tester.pumpWidget(const MyApp());

          expect(find.text('No alarms set. Tap + to add a new alarm.'), findsOneWidget);
        });

    testWidgets('should navigate to Set Alarm screen when FAB is tapped',
            (WidgetTester tester) async {
          await tester.pumpWidget(const MyApp());

          // Tap the FAB
          await tester.tap(find.byType(FloatingActionButton));
          await tester.pumpAndSettle();

          // Verify navigation to SetAlarm screen
          expect(find.byType(SetAlarm), findsOneWidget);
        });

    testWidgets('should add a new alarm and display it in the list',
            (WidgetTester tester) async {
          await tester.pumpWidget(const MyApp());

          // Navigate to SetAlarm screen
          await tester.tap(find.byType(FloatingActionButton));
          await tester.pumpAndSettle();

          // Simulate entering alarm label
          await tester.enterText(find.byType(TextField), 'Wake Up');
          await tester.pump();

          // Simulate saving the alarm
          await tester.tap(find.text('Save Alarm'));
          await tester.pumpAndSettle();

          // Verify the alarm is added
          expect(find.text('Wake Up'), findsOneWidget);
        });

    testWidgets('should toggle alarm activation', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Navigate to SetAlarm screen
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Simulate entering alarm label
      await tester.enterText(find.byType(TextField), 'Wake Up');
      await tester.pump();

      // Simulate saving the alarm
      await tester.tap(find.text('Save Alarm'));
      await tester.pumpAndSettle();

      // Verify alarm is added
      expect(find.text('Wake Up'), findsOneWidget);

      // Toggle the alarm
      final toggle = find.byType(Switch).first;
      await tester.tap(toggle);
      await tester.pump();

      // Verify the alarm is toggled (Switch state changes)
      final alarmOffIcon = find.byIcon(Icons.alarm_off);
      expect(alarmOffIcon, findsOneWidget);
    });

    testWidgets('should delete an alarm when swiped', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Navigate to SetAlarm screen
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Simulate entering alarm label
      await tester.enterText(find.byType(TextField), 'Wake Up');
      await tester.pump();

      // Simulate saving the alarm
      await tester.tap(find.text('Save Alarm'));
      await tester.pumpAndSettle();

      // Verify alarm is added
      expect(find.text('Wake Up'), findsOneWidget);

      // Swipe to delete the alarm
      await tester.drag(find.byType(ListTile), const Offset(-500.0, 0.0));
      await tester.pumpAndSettle();

      // Verify the alarm is deleted
      expect(find.byType(ListTile), findsNothing);
    });

    testWidgets('should navigate to Settings screen', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Tap the settings icon
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Verify navigation
      expect(find.byType(Settings), findsOneWidget);
    });
  });
}
