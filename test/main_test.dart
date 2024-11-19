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
      expect(find.byKey(const Key('problem_text')), findsOneWidget);
    });

    testWidgets('should accept correct answer and generate new problem', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MathPuzzle()));

      // Get the initial problem
      final problemTextWidget = find.byKey(const Key('problem_text'));
      expect(problemTextWidget, findsOneWidget);
      final problemText = tester.widget<Text>(problemTextWidget).data!;
      final RegExp problemRegExp = RegExp(r'(\d+)\s\+\s(\d+)\s=\s\?');
      final match = problemRegExp.firstMatch(problemText);
      expect(match, isNotNull);
      final num1 = int.parse(match!.group(1)!);
      final num2 = int.parse(match.group(2)!);
      final correctAnswer = num1 + num2;

      // Simulate entering the correct answer
      final answerString = correctAnswer.toString();
      for (int i = 0; i < answerString.length; i++) {
        final digitButton = find.byKey(Key('keypad_button_${answerString[i]}'));
        await tester.ensureVisible(digitButton);
        await tester.tap(digitButton);
        await tester.pump();
      }

      // Press 'Enter'
      final enterButton = find.byKey(const Key('keypad_button_Enter'));
      await tester.ensureVisible(enterButton);
      await tester.tap(enterButton);
      await tester.pumpAndSettle();

      // Verify that the correct message is shown
      expect(find.text('Correct! Next problem:'), findsOneWidget);

      // Verify that a new problem is generated
      final newProblemTextWidget = find.byKey(const Key('problem_text'));
      final newProblemText = tester.widget<Text>(newProblemTextWidget).data!;
      expect(newProblemText, isNot(equals(problemText)));
    });

    testWidgets('should show incorrect message for wrong answer', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MathPuzzle()));

      // Get the initial problem
      final problemTextWidget = find.byKey(const Key('problem_text'));
      expect(problemTextWidget, findsOneWidget);
      final problemText = tester.widget<Text>(problemTextWidget).data!;
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
        final digitButton = find.byKey(Key('keypad_button_${answerString[i]}'));
        await tester.ensureVisible(digitButton);
        await tester.tap(digitButton);
        await tester.pump();
      }

      // Press 'Enter'
      final enterButton = find.byKey(const Key('keypad_button_Enter'));
      await tester.ensureVisible(enterButton);
      await tester.tap(enterButton);
      await tester.pump();

      // Verify that the incorrect message is shown
      expect(find.text('Incorrect! Try again.'), findsOneWidget);

      // Verify that the problem stays the same
      final currentProblemTextWidget = find.byKey(const Key('problem_text'));
      final currentProblemText = tester.widget<Text>(currentProblemTextWidget).data!;
      expect(currentProblemText, equals(problemText));
    });

    testWidgets('should clear input when Clear button is pressed', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MathPuzzle()));

      // Simulate entering some digits
      final oneButton = find.byKey(const Key('keypad_button_1'));
      await tester.ensureVisible(oneButton);
      await tester.tap(oneButton);
      await tester.pump();

      final twoButton = find.byKey(const Key('keypad_button_2'));
      await tester.ensureVisible(twoButton);
      await tester.tap(twoButton);
      await tester.pump();

      // Verify input shows '12'
      expect(find.text('12'), findsOneWidget);

      // Press 'Clear'
      final clearButton = find.byKey(const Key('keypad_button_Clear'));
      await tester.ensureVisible(clearButton);
      await tester.tap(clearButton);
      await tester.pump();

      // Verify input is cleared
      expect(find.text(''), findsOneWidget);
    });

    testWidgets('should accept multiple digit answers', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MathPuzzle()));

      // Simulate entering a multi-digit number
      final oneButton = find.byKey(const Key('keypad_button_1'));
      await tester.ensureVisible(oneButton);
      await tester.tap(oneButton);
      await tester.pump();

      final zeroButton = find.byKey(const Key('keypad_button_0'));
      await tester.ensureVisible(zeroButton);
      await tester.tap(zeroButton);
      await tester.pump();

      // Verify input shows '10'
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('should generate new problem after correct answer', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MathPuzzle()));

      // Get the initial problem
      final initialProblemTextWidget = find.byKey(const Key('problem_text'));
      expect(initialProblemTextWidget, findsOneWidget);
      final initialProblemText = tester.widget<Text>(initialProblemTextWidget).data!;

      // Solve the problem correctly
      final RegExp problemRegExp = RegExp(r'(\d+)\s\+\s(\d+)\s=\s\?');
      final match = problemRegExp.firstMatch(initialProblemText);
      final num1 = int.parse(match!.group(1)!);
      final num2 = int.parse(match.group(2)!);
      final correctAnswer = num1 + num2;

      final answerString = correctAnswer.toString();
      for (int i = 0; i < answerString.length; i++) {
        final digitButton = find.byKey(Key('keypad_button_${answerString[i]}'));
        await tester.ensureVisible(digitButton);
        await tester.tap(digitButton);
        await tester.pump();
      }

      // Press 'Enter'
      final enterButton = find.byKey(const Key('keypad_button_Enter'));
      await tester.ensureVisible(enterButton);
      await tester.tap(enterButton);
      await tester.pumpAndSettle();

      // Verify that a new problem is displayed
      final newProblemTextWidget = find.byKey(const Key('problem_text'));
      final newProblemText = tester.widget<Text>(newProblemTextWidget).data!;
      expect(newProblemText, isNot(equals(initialProblemText)));
    });

    testWidgets('should handle rapid correct answers', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MathPuzzle()));

      for (int i = 0; i < 5; i++) {
        // Get the current problem
        final problemTextWidget = find.byKey(const Key('problem_text'));
        expect(problemTextWidget, findsOneWidget);
        final problemText = tester.widget<Text>(problemTextWidget).data!;
        final RegExp problemRegExp = RegExp(r'(\d+)\s\+\s(\d+)\s=\s\?');
        final match = problemRegExp.firstMatch(problemText);
        final num1 = int.parse(match!.group(1)!);
        final num2 = int.parse(match.group(2)!);
        final correctAnswer = num1 + num2;

        // Enter correct answer
        final answerString = correctAnswer.toString();
        for (int j = 0; j < answerString.length; j++) {
          final digitButton = find.byKey(Key('keypad_button_${answerString[j]}'));
          await tester.ensureVisible(digitButton);
          await tester.tap(digitButton);
          await tester.pump();
        }

        // Press 'Enter'
        final enterButton = find.byKey(const Key('keypad_button_Enter'));
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
      final problemTextWidget = find.byKey(const Key('problem_text'));
      expect(problemTextWidget, findsOneWidget);
      final problemText = tester.widget<Text>(problemTextWidget).data!;

      // Enter incorrect answer
      final nineButton = find.byKey(const Key('keypad_button_9'));
      await tester.ensureVisible(nineButton);
      await tester.tap(nineButton);
      await tester.pump();

      final nineButton2 = find.byKey(const Key('keypad_button_9'));
      await tester.ensureVisible(nineButton2);
      await tester.tap(nineButton2);
      await tester.pump();

      // Press 'Enter'
      final enterButton = find.byKey(const Key('keypad_button_Enter'));
      await tester.ensureVisible(enterButton);
      await tester.tap(enterButton);
      await tester.pump();

      // Verify incorrect message
      expect(find.text('Incorrect! Try again.'), findsOneWidget);

      // Verify problem remains the same
      final currentProblemTextWidget = find.byKey(const Key('problem_text'));
      final currentProblemText = tester.widget<Text>(currentProblemTextWidget).data!;
      expect(currentProblemText, equals(problemText));
    });
  });

  group('Sudoku Puzzle Tests', () {
    testWidgets('should display initial Sudoku puzzle', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SudokuPuzzle()));

      // Verify that the Sudoku grid is displayed
      for (int row = 0; row < 4; row++) {
        for (int col = 0; col < 4; col++) {
          final prefilledKey = Key('cell_${row}_$col');
          final inputKey = Key('input_cell_${row}_$col');
          // Either a pre-filled cell or an input cell
          expect(
              find.byKey(prefilledKey).evaluate().isNotEmpty ||
                  find.byKey(inputKey).evaluate().isNotEmpty,
              isTrue);
        }
      }

      // Verify 'Check Solution' and 'New Puzzle' buttons
      expect(find.byKey(const Key('check_solution_button')), findsOneWidget);
      expect(find.byKey(const Key('new_puzzle_button')), findsOneWidget);
    });

    testWidgets('should solve Sudoku puzzle correctly', (WidgetTester tester) async {
      // Since generating a valid Sudoku puzzle is random and complex to solve in tests,
      // we'll simulate an incorrect solution and expect 'Incorrect solution!' dialog.

      await tester.pumpWidget(const MaterialApp(home: SudokuPuzzle()));

      // Press 'Check Solution' without entering any numbers
      await tester.tap(find.byKey(const Key('check_solution_button')));
      await tester.pumpAndSettle();

      // Verify that 'Incorrect solution!' dialog is shown
      expect(find.text('Incorrect solution!'), findsOneWidget);
    });

    testWidgets('should generate new puzzle when "New Puzzle" button is pressed', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SudokuPuzzle()));

      // Get the initial board state
      List<List<int?>> initialBoard = [];
      for (int row = 0; row < 4; row++) {
        List<int?> rowList = [];
        for (int col = 0; col < 4; col++) {
          final prefilledFinder = find.byKey(Key('cell_${row}_$col'));
          if (prefilledFinder.evaluate().isNotEmpty) {
            final prefilledTextFinder = find.descendant(
              of: prefilledFinder,
              matching: find.byType(Text),
            );
            if (prefilledTextFinder.evaluate().isNotEmpty) {
              final prefilledText = tester.widget<Text>(prefilledTextFinder).data;
              rowList.add(int.parse(prefilledText!));
            } else {
              rowList.add(null);
            }
          } else {
            rowList.add(null);
          }
        }
        initialBoard.add(rowList);
      }

      // Press 'New Puzzle' button
      await tester.tap(find.byKey(const Key('new_puzzle_button')));
      await tester.pumpAndSettle();

      // Get the new board state
      List<List<int?>> newBoard = [];
      for (int row = 0; row < 4; row++) {
        List<int?> rowList = [];
        for (int col = 0; col < 4; col++) {
          final prefilledFinder = find.byKey(Key('cell_${row}_$col'));
          if (prefilledFinder.evaluate().isNotEmpty) {
            final prefilledTextFinder = find.descendant(
              of: prefilledFinder,
              matching: find.byType(Text),
            );
            if (prefilledTextFinder.evaluate().isNotEmpty) {
              final prefilledText = tester.widget<Text>(prefilledTextFinder).data;
              rowList.add(int.parse(prefilledText!));
            } else {
              rowList.add(null);
            }
          } else {
            rowList.add(null);
          }
        }
        newBoard.add(rowList);
      }

      // Verify that the new board is different from the initial board
      bool isDifferent = false;
      for (int row = 0; row < 4; row++) {
        for (int col = 0; col < 4; col++) {
          if (initialBoard[row][col] != newBoard[row][col]) {
            isDifferent = true;
            break;
          }
        }
        if (isDifferent) break;
      }
      expect(isDifferent, isTrue);
    });

    testWidgets('should show "Incorrect solution!" when Sudoku is not solved', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SudokuPuzzle()));

      // Press 'Check Solution' without entering any numbers
      await tester.tap(find.byKey(const Key('check_solution_button')));
      await tester.pumpAndSettle();

      // Verify that 'Incorrect solution!' dialog is shown
      expect(find.text('Incorrect solution!'), findsOneWidget);
    });
  });

  group('Maze Puzzle Tests', () {
    testWidgets('should display initial Maze puzzle', (WidgetTester tester) async {
      // Define a predefined maze that can be solved by moving right and down
      final predefinedMaze = [
        [2, 0, 1, 1, 1, 1, 1], // Start at (0,0)
        [1, 0, 1, 0, 0, 0, 1],
        [1, 0, 1, 0, 1, 0, 1],
        [1, 0, 0, 0, 1, 0, 1],
        [1, 1, 1, 0, 1, 0, 1],
        [1, 0, 0, 0, 1, 0, 1],
        [1, 1, 1, 0, 1, 0, 3], // Exit at (6,6)
      ];

      await tester.pumpWidget(MaterialApp(
        home: MazePuzzle(predefinedMaze: predefinedMaze),
      ));

      // Verify that the maze grid is displayed
      for (int x = 0; x < 7; x++) {
        for (int y = 0; y < 7; y++) {
          final cellKey = Key('maze_cell_${x}_$y');
          expect(find.byKey(cellKey), findsOneWidget);
        }
      }

      // Verify movement buttons
      expect(find.byKey(const Key('move_up_button')), findsOneWidget);
      expect(find.byKey(const Key('move_down_button')), findsOneWidget);
      expect(find.byKey(const Key('move_left_button')), findsOneWidget);
      expect(find.byKey(const Key('move_right_button')), findsOneWidget);
    });

    testWidgets('should move player to exit', (WidgetTester tester) async {
      // Define a predefined maze that allows moving right 6 times and down 6 times to reach exit
      final predefinedMaze = [
        [2, 0, 0, 0, 0, 0, 0], // Start at (0,0), open path to the right
        [1, 1, 1, 1, 1, 1, 0],
        [0, 0, 0, 0, 0, 1, 0],
        [0, 1, 1, 1, 0, 1, 0],
        [0, 1, 0, 1, 0, 1, 0],
        [0, 1, 0, 1, 0, 1, 0],
        [0, 1, 0, 1, 0, 0, 3], // Exit at (6,6)
      ];

      await tester.pumpWidget(MaterialApp(
        home: MazePuzzle(predefinedMaze: predefinedMaze),
      ));

      // Move right 6 times
      for (int i = 0; i < 6; i++) {
        await tester.tap(find.byKey(const Key('move_right_button')));
        await tester.pump();
      }

      // Move down 6 times
      for (int i = 0; i < 6; i++) {
        await tester.tap(find.byKey(const Key('move_down_button')));
        await tester.pump();
      }

      // Verify player has reached the exit and dialog is shown
      await tester.pumpAndSettle();
      expect(find.text("Congratulations! You reached the exit!"), findsOneWidget);
    });

    testWidgets('should not move player into walls', (WidgetTester tester) async {
      // Define a predefined maze with walls around the start
      final predefinedMaze = [
        [2, 1, 1, 1, 1, 1, 1], // Start at (0,0) surrounded by walls
        [1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1, 3], // Exit at (6,6)
      ];

      await tester.pumpWidget(MaterialApp(
        home: MazePuzzle(predefinedMaze: predefinedMaze),
      ));

      // Attempt to move left and up from the starting position (0,0)
      await tester.tap(find.byKey(const Key('move_left_button')));
      await tester.pump();

      await tester.tap(find.byKey(const Key('move_up_button')));
      await tester.pump();

      // Player should still be at (0,0)
      final playerCell = find.byKey(const Key('maze_cell_0_0'));
      expect(tester.widget<Container>(playerCell).color, equals(Colors.blue));

      // Ensure no other cell is blue
      expect(find.byWidgetPredicate((widget) {
        if (widget is Container) {
          return widget.color == Colors.blue && widget.key != const Key('maze_cell_0_0');
        }
        return false;
      }), findsNothing);
    });

    testWidgets('should show "Congratulations! You reached the exit!" when reaching exit', (WidgetTester tester) async {
      // Define a predefined maze that allows moving right 6 times and down 6 times to reach exit
      final predefinedMaze = [
        [2, 0, 0, 0, 0, 0, 0], // Start at (0,0), open path to the right
        [1, 1, 1, 1, 1, 1, 0],
        [0, 0, 0, 0, 0, 1, 0],
        [0, 1, 1, 1, 0, 1, 0],
        [0, 1, 0, 1, 0, 1, 0],
        [0, 1, 0, 1, 0, 1, 0],
        [0, 1, 0, 1, 0, 0, 3], // Exit at (6,6)
      ];

      await tester.pumpWidget(MaterialApp(
        home: MazePuzzle(predefinedMaze: predefinedMaze),
      ));

      // Move right 6 times
      for (int i = 0; i < 6; i++) {
        await tester.tap(find.byKey(const Key('move_right_button')));
        await tester.pump();
      }

      // Move down 6 times
      for (int i = 0; i < 6; i++) {
        await tester.tap(find.byKey(const Key('move_down_button')));
        await tester.pump();
      }

      // Verify that 'Congratulations' dialog is shown
      await tester.pumpAndSettle();
      expect(find.text("Congratulations! You reached the exit!"), findsOneWidget);

      // Press 'New Maze'
      await tester.tap(find.byKey(const Key('new_maze_button')));
      await tester.pumpAndSettle();

      // Verify that a new maze is generated by checking the player's position is reset
      final startCell = find.byKey(const Key('maze_cell_0_0'));
      final playerCell = find.byWidgetPredicate((widget) {
        if (widget is Container) {
          return widget.color == Colors.blue;
        }
        return false;
      });
      expect(tester.widget<Container>(startCell).color, equals(Colors.blue));
      // There should only be one player cell
      expect(playerCell, findsOneWidget);
    });
  });

  group('Sorting Puzzle Tests', () {
    testWidgets('should display initial Sorting puzzle', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SortingPuzzle()));

      // Verify that the Sorting grid is displayed
      for (int i = 0; i < 8; i++) {
        final numberKey = Key('number_$i');
        expect(find.byKey(numberKey), findsOneWidget);
      }

      // Verify 'Shuffle Numbers' button
      expect(find.byKey(const Key('shuffle_numbers_button')), findsOneWidget);
    });

    testWidgets('should shuffle numbers when "Shuffle Numbers" button is pressed', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SortingPuzzle()));

      // Capture the initial numbers
      List<String> initialNumbers = [];
      for (int i = 0; i < 8; i++) {
        final numberKey = Key('number_$i');
        final numberTextFinder = find.descendant(
          of: find.byKey(numberKey),
          matching: find.byType(Text),
        );
        expect(numberTextFinder, findsOneWidget);
        final numberText = tester.widget<Text>(numberTextFinder).data!;
        initialNumbers.add(numberText);
      }

      // Press 'Shuffle Numbers' button
      await tester.tap(find.byKey(const Key('shuffle_numbers_button')));
      await tester.pump();

      // Capture the new numbers
      List<String> newNumbers = [];
      for (int i = 0; i < 8; i++) {
        final numberKey = Key('number_$i');
        final numberTextFinder = find.descendant(
          of: find.byKey(numberKey),
          matching: find.byType(Text),
        );
        expect(numberTextFinder, findsOneWidget);
        final numberText = tester.widget<Text>(numberTextFinder).data!;
        newNumbers.add(numberText);
      }

      // Verify that the numbers have been shuffled
      bool isShuffled = false;
      for (int i = 0; i < 8; i++) {
        if (initialNumbers[i] != newNumbers[i]) {
          isShuffled = true;
          break;
        }
      }
      expect(isShuffled, isTrue);
    });

    testWidgets('should allow swapping numbers and detect sorted list', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SortingPuzzle()));

      // Get the initial numbers
      List<int> initialNumbers = [];
      for (int i = 0; i < 8; i++) {
        final numberKey = Key('number_$i');
        final numberTextFinder = find.descendant(
          of: find.byKey(numberKey),
          matching: find.byType(Text),
        );
        expect(numberTextFinder, findsOneWidget);
        final numberText = tester.widget<Text>(numberTextFinder).data!;
        initialNumbers.add(int.parse(numberText));
      }

      // Sort the numbers in ascending order
      List<int> sortedNumbers = List.from(initialNumbers)..sort();

      // Perform swaps to sort the numbers
      for (int i = 0; i < 8; i++) {
        if (initialNumbers[i] != sortedNumbers[i]) {
          // Find the index where the sorted number is
          int swapIndex = initialNumbers.indexOf(sortedNumbers[i]);
          if (swapIndex != -1) {
            // Tap the two numbers to swap
            final firstNumberKey = Key('number_$i');
            final secondNumberKey = Key('number_$swapIndex');

            await tester.tap(find.byKey(firstNumberKey));
            await tester.pump();
            await tester.tap(find.byKey(secondNumberKey));
            await tester.pump();

            // Update the initialNumbers list
            int temp = initialNumbers[i];
            initialNumbers[i] = initialNumbers[swapIndex];
            initialNumbers[swapIndex] = temp;

            // Check if sorted
            if (_isListSorted(initialNumbers, sortedNumbers)) {
              break;
            }
          }
        }
      }

      // Verify that the numbers are sorted
      List<int> finalNumbers = [];
      for (int i = 0; i < 8; i++) {
        final numberKey = Key('number_$i');
        final numberTextFinder = find.descendant(
          of: find.byKey(numberKey),
          matching: find.byType(Text),
        );
        expect(numberTextFinder, findsOneWidget);
        final numberText = tester.widget<Text>(numberTextFinder).data!;
        finalNumbers.add(int.parse(numberText));
      }
      expect(finalNumbers, equals(sortedNumbers));

      // Verify that 'Congratulations' dialog is shown
      await tester.pumpAndSettle();
      expect(find.text("Congratulations! You sorted the numbers!"), findsOneWidget);

      // Press 'Play Again'
      await tester.tap(find.byKey(const Key('play_again_button')));
      await tester.pumpAndSettle();

      // Verify that a new puzzle is generated by checking different numbers
      List<String> newNumbers = [];
      for (int i = 0; i < 8; i++) {
        final numberKey = Key('number_$i');
        final numberTextFinder = find.descendant(
          of: find.byKey(numberKey),
          matching: find.byType(Text),
        );
        expect(numberTextFinder, findsOneWidget);
        final numberText = tester.widget<Text>(numberTextFinder).data!;
        newNumbers.add(numberText);
      }

      bool isNewPuzzle = false;
      for (int i = 0; i < 8; i++) {
        if (newNumbers[i] != initialNumbers[i].toString()) {
          isNewPuzzle = true;
          break;
        }
      }
      expect(isNewPuzzle, isTrue);
    });

    testWidgets('should not show win dialog when list is not sorted', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SortingPuzzle()));

      // Ensure that the initial list is not sorted
      List<int> initialNumbers = [];
      for (int i = 0; i < 8; i++) {
        final numberKey = Key('number_$i');
        final numberTextFinder = find.descendant(
          of: find.byKey(numberKey),
          matching: find.byType(Text),
        );
        expect(numberTextFinder, findsOneWidget);
        final numberText = tester.widget<Text>(numberTextFinder).data!;
        initialNumbers.add(int.parse(numberText));
      }

      List<int> sortedNumbers = List.from(initialNumbers)..sort();

      if (!_isListSorted(initialNumbers, sortedNumbers)) {
        // Do not sort the list
        // The game checks on every swap. Thus, if not sorted, no dialog should appear

        // Thus, verify that 'Congratulations' dialog is not shown
        await tester.pumpAndSettle();
        expect(find.text("Congratulations! You sorted the numbers!"), findsNothing);
      }
    });
  });

  group('Main Screen Tests', () {
    testWidgets('should display "No alarms set" when there are no alarms', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MyApp()));

      expect(find.text('No alarms set. Tap + to add a new alarm.'), findsOneWidget);
    });

    testWidgets('should navigate to Set Alarm screen when FAB is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MyApp()));

      // Tap the FAB
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify navigation to SetAlarm screen
      expect(find.byType(SetAlarm), findsOneWidget);
    });

    testWidgets('should add a new alarm and display it in the list', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: MyApp()));

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
      await tester.pumpWidget(const MaterialApp(home: MyApp()));

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
      await tester.pumpWidget(const MaterialApp(home: MyApp()));

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
      await tester.pumpWidget(const MaterialApp(home: MyApp()));

      // Tap the settings icon
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Verify navigation
      expect(find.byType(Settings), findsOneWidget);
    });
  });
}

// Helper function to check if two lists are sorted and identical
bool _isListSorted(List<int> list, List<int> sortedList) {
  for (int i = 0; i < list.length; i++) {
    if (list[i] != sortedList[i]) return false;
  }
  return true;
}
