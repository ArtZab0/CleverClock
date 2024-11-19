import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/main.dart';
import 'package:untitled/set_alarm.dart';
import 'package:untitled/play_puzzle.dart';
import 'package:untitled/settings.dart';

void main() {
  group('Puzzle Screen Tests', () {
    testWidgets('should display initial math problem', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MathPuzzle()));

      // Verify that the problem is displayed
      expect(find.textContaining('= ?'), findsOneWidget);
    });

    testWidgets('should accept correct answer and generate new problem', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MathPuzzle()));

      // Get the initial problem
      final problemText = tester.widget<Text>(find.byKey(const Key('problem_text'))).data!;
      final RegExp problemRegExp = RegExp(r'(\d+)\s\+\s(\d+)\s=\s\?');
      final match = problemRegExp.firstMatch(problemText);
      expect(match, isNotNull);
      final num1 = int.parse(match!.group(1)!);
      final num2 = int.parse(match.group(2)!);
      final correctAnswer = num1 + num2;

      // Simulate entering the correct answer
      final answerString = correctAnswer.toString();
      for (int i = 0; i < answerString.length; i++) {
        final digitButton = find.widgetWithText(ElevatedButton, answerString[i]);
        await tester.ensureVisible(digitButton);
        await tester.tap(digitButton);
        await tester.pump();
      }

      // Press 'Enter'
      final enterButton = find.widgetWithText(ElevatedButton, 'Enter');
      await tester.ensureVisible(enterButton);
      await tester.tap(enterButton);
      await tester.pumpAndSettle();

      // Verify that the correct message is shown
      expect(find.text('Correct! Next problem:'), findsOneWidget);

      // Verify that a new problem is generated
      final newProblemText = tester.widget<Text>(find.byKey(const Key('problem_text'))).data!;
      expect(newProblemText, isNot(equals(problemText)));
    });

    testWidgets('should show incorrect message for wrong answer', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MathPuzzle()));

      // Get the initial problem
      final problemText = tester.widget<Text>(find.byKey(const Key('problem_text'))).data!;
      final RegExp problemRegExp = RegExp(r'(\d+)\s\+\s(\d+)\s=\s\?');
      final match = problemRegExp.firstMatch(problemText);
      expect(match, isNotNull);
      final num1 = int.parse(match!.group(1)!);
      final num2 = int.parse(match.group(2)!);
      final correctAnswer = num1 + num2;

      // Enter an incorrect answer
      final wrongAnswer = correctAnswer + 1;
      final answerString = wrongAnswer.toString();
      for (int i = 0; i < answerString.length; i++) {
        final digitButton = find.widgetWithText(ElevatedButton, answerString[i]);
        await tester.ensureVisible(digitButton);
        await tester.tap(digitButton);
        await tester.pump();
      }

      // Press 'Enter'
      final enterButton = find.widgetWithText(ElevatedButton, 'Enter');
      await tester.ensureVisible(enterButton);
      await tester.tap(enterButton);
      await tester.pump();

      // Verify that the incorrect message is shown
      expect(find.text('Incorrect! Try again.'), findsOneWidget);

      // Verify that the problem stays the same
      final currentProblemText = tester.widget<Text>(find.byKey(const Key('problem_text'))).data!;
      expect(currentProblemText, equals(problemText));
    });

    testWidgets('should clear input when Clear button is pressed', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MathPuzzle()));

      // Simulate entering some digits
      final oneButton = find.widgetWithText(ElevatedButton, '1');
      await tester.ensureVisible(oneButton);
      await tester.tap(oneButton);
      await tester.pump();

      final twoButton = find.widgetWithText(ElevatedButton, '2');
      await tester.ensureVisible(twoButton);
      await tester.tap(twoButton);
      await tester.pump();

      // Verify input shows '12'
      expect(find.text('12'), findsOneWidget);

      // Press 'Clear'
      final clearButton = find.widgetWithText(ElevatedButton, 'Clear');
      await tester.ensureVisible(clearButton);
      await tester.tap(clearButton);
      await tester.pump();

      // Verify input is cleared
      expect(find.text(''), findsOneWidget);
    });

    testWidgets('should accept multiple digit answers', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MathPuzzle()));

      // Simulate entering a multi-digit number
      final oneButton = find.widgetWithText(ElevatedButton, '1');
      await tester.ensureVisible(oneButton);
      await tester.tap(oneButton);
      await tester.pump();

      final zeroButton = find.widgetWithText(ElevatedButton, '0');
      await tester.ensureVisible(zeroButton);
      await tester.tap(zeroButton);
      await tester.pump();

      // Verify input shows '10'
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('should generate new problem after correct answer', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MathPuzzle()));

      // Get the initial problem
      final initialProblemText = tester.widget<Text>(find.byKey(const Key('problem_text'))).data!;

      // Solve the problem correctly
      final RegExp problemRegExp = RegExp(r'(\d+)\s\+\s(\d+)\s=\s\?');
      final match = problemRegExp.firstMatch(initialProblemText);
      final num1 = int.parse(match!.group(1)!);
      final num2 = int.parse(match.group(2)!);
      final correctAnswer = num1 + num2;

      final answerString = correctAnswer.toString();
      for (int i = 0; i < answerString.length; i++) {
        final digitButton = find.widgetWithText(ElevatedButton, answerString[i]);
        await tester.ensureVisible(digitButton);
        await tester.tap(digitButton);
        await tester.pump();
      }

      // Press 'Enter'
      final enterButton = find.widgetWithText(ElevatedButton, 'Enter');
      await tester.ensureVisible(enterButton);
      await tester.tap(enterButton);
      await tester.pumpAndSettle();

      // Verify that a new problem is displayed
      final newProblemText = tester.widget<Text>(find.byKey(const Key('problem_text'))).data!;
      expect(newProblemText, isNot(equals(initialProblemText)));
    });

    testWidgets('should handle rapid correct answers', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MathPuzzle()));

      for (int i = 0; i < 5; i++) {
        // Get the current problem
        final problemText = tester.widget<Text>(find.byKey(const Key('problem_text'))).data!;
        final RegExp problemRegExp = RegExp(r'(\d+)\s\+\s(\d+)\s=\s\?');
        final match = problemRegExp.firstMatch(problemText);
        final num1 = int.parse(match!.group(1)!);
        final num2 = int.parse(match.group(2)!);
        final correctAnswer = num1 + num2;

        // Enter correct answer
        final answerString = correctAnswer.toString();
        for (int j = 0; j < answerString.length; j++) {
          final digitButton = find.widgetWithText(ElevatedButton, answerString[j]);
          await tester.ensureVisible(digitButton);
          await tester.tap(digitButton);
          await tester.pump();
        }

        // Press 'Enter'
        final enterButton = find.widgetWithText(ElevatedButton, 'Enter');
        await tester.ensureVisible(enterButton);
        await tester.tap(enterButton);
        await tester.pumpAndSettle();

        // Verify correct message
        expect(find.text('Correct! Next problem:'), findsOneWidget);
      }
    });

    testWidgets('should not advance to next problem on incorrect answer', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MathPuzzle()));

      // Get the current problem
      final problemText = tester.widget<Text>(find.byKey(const Key('problem_text'))).data!;

      // Enter incorrect answer
      final nineButton = find.widgetWithText(ElevatedButton, '9');
      await tester.ensureVisible(nineButton);
      await tester.tap(nineButton);
      await tester.pump();

      final nineButton2 = find.widgetWithText(ElevatedButton, '9');
      await tester.ensureVisible(nineButton2);
      await tester.tap(nineButton2);
      await tester.pump();

      // Press 'Enter'
      final enterButton = find.widgetWithText(ElevatedButton, 'Enter');
      await tester.ensureVisible(enterButton);
      await tester.tap(enterButton);
      await tester.pump();

      // Verify incorrect message
      expect(find.text('Incorrect! Try again.'), findsOneWidget);

      // Verify problem remains the same
      final currentProblemText = tester.widget<Text>(find.byKey(const Key('problem_text'))).data!;
      expect(currentProblemText, equals(problemText));
    });
  });

  // ... rest of your tests remain the same
}
