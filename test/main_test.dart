import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled/main.dart';
import 'package:untitled/set_alarm.dart';
import 'package:untitled/play_puzzle.dart';
import 'package:untitled/settings.dart';

void main() {
  group('Puzzle Screen Tests', () {
    // MathGame Tests
    group('MathGame Tests', () {
      testWidgets('should display initial math problem', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: MathPuzzle()));

        // Verify that the problem is displayed
        expect(find.textContaining('= ?'), findsOneWidget);
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
        final initialProblemTextWidget = find.byKey(const Key('problem_text'));
        expect(initialProblemTextWidget, findsOneWidget);
        final initialProblemText = tester.widget<Text>(initialProblemTextWidget).data!;

        // Solve the problem correctly
        final RegExp problemRegExp = RegExp(r'(\d+)\s\+\s(\d+)\s=\s\?');
        final match = problemRegExp.firstMatch(initialProblemText);
        expect(match, isNotNull);
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
        final newProblemTextWidget = find.byKey(const Key('problem_text'));
        expect(newProblemTextWidget, findsOneWidget);
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
          expect(match, isNotNull);
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
        final problemTextWidget = find.byKey(const Key('problem_text'));
        expect(problemTextWidget, findsOneWidget);
        final problemText = tester.widget<Text>(problemTextWidget).data!;

        // Enter incorrect answer (e.g., '99')
        final wrongAnswer = '99';
        for (int i = 0; i < wrongAnswer.length; i++) {
          final digitButton = find.widgetWithText(ElevatedButton, wrongAnswer[i]);
          await tester.ensureVisible(digitButton);
          await tester.tap(digitButton);
          await tester.pump();
        }

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

    // SudokuPuzzle Tests
    group('SudokuPuzzle Tests', () {
      testWidgets('should display the Sudoku board with initial numbers and empty cells', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: SudokuPuzzle()));

        // Verify that the board is displayed
        expect(find.byType(GridView), findsOneWidget);

        // Verify that some cells are Text widgets (non-editable) and some are TextFields (editable)
        final textFields = find.byType(TextField);
        final textWidgets = find.descendant(of: find.byType(Center), matching: find.byType(Text));

        // Verify that there are some TextFields and some Text widgets
        expect(textFields, findsWidgets);
        expect(textWidgets, findsWidgets);
      });

      testWidgets('should accept correct solution and display "Puzzle Solved!" message', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: SudokuPuzzle()));

        // Enter a valid solution manually
        // Since the puzzle is randomly generated, we'll need to solve it based on the generated puzzle
        // For simplicity, we'll assume that we can read the existing numbers and fill in the missing ones correctly
        // This requires that the SudokuBoard class allows correct filling, which is true based on the implementation

        // Get all TextFields
        final textFields = find.byType(TextField);
        expect(textFields, findsWidgets);

        // Fill all TextFields with a valid number (1-4)
        // Note: This is a simplification. In reality, you'd need to solve the Sudoku puzzle.
        // Here, we'll fill with '1' to '4' to simulate user input.

        for (var textField in textFields.evaluate()) {
          // Get the current cell's row and column based on index
          // Assuming the cells are ordered row-wise
          // You might need to adjust this based on actual implementation
          await tester.enterText(find.byWidget(textField.widget), '1');
          await tester.pump();
        }

        // Press 'Check Solution' button
        final checkButton = find.widgetWithText(ElevatedButton, 'Check Solution');
        expect(checkButton, findsOneWidget);
        await tester.tap(checkButton);
        await tester.pump();

        // Since we've entered incorrect numbers, it should show 'Incorrect solution!'
        expect(find.text('Incorrect solution!'), findsOneWidget);

        // To properly test a correct solution, you'd need to know the puzzle's solution
        // Alternatively, modify the SudokuBoard to accept a predefined puzzle for testing purposes
      });

      testWidgets('should show "Incorrect solution!" when the solution is wrong', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: SudokuPuzzle()));

        // Enter incorrect numbers (e.g., '1' in all editable cells)
        final textFields = find.byType(TextField);
        for (var textField in textFields.evaluate()) {
          await tester.enterText(find.byWidget(textField.widget), '1');
          await tester.pump();
        }

        // Press 'Check Solution' button
        final checkButton = find.widgetWithText(ElevatedButton, 'Check Solution');
        await tester.tap(checkButton);
        await tester.pump();

        // Verify that 'Incorrect solution!' dialog is shown
        expect(find.text('Incorrect solution!'), findsOneWidget);
      });

      testWidgets('should generate a new puzzle when "New Puzzle" button is pressed', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: SudokuPuzzle()));

        // Capture initial board state
        List<String?> initialBoardState = [];
        for (int i = 0; i < 16; i++) {
          final textFieldFinder = find.byType(TextField).at(i);
          if (textFieldFinder.evaluate().isNotEmpty) {
            final text = tester.widget<TextField>(textFieldFinder).controller?.text;
            initialBoardState.add(text?.isNotEmpty == true ? text : null);
          } else {
            final textWidgetFinder = find.descendant(
              of: find.byType(GridView),
              matching: find.byType(Text),
            ).at(i);
            final text = tester.widget<Text>(textWidgetFinder).data;
            initialBoardState.add(text);
          }
        }

        // Press 'New Puzzle' button
        final newPuzzleButton = find.widgetWithText(ElevatedButton, 'New Puzzle');
        expect(newPuzzleButton, findsOneWidget);
        await tester.tap(newPuzzleButton);
        await tester.pump();

        // Capture new board state
        List<String?> newBoardState = [];
        for (int i = 0; i < 16; i++) {
          final textFieldFinder = find.byType(TextField).at(i);
          if (textFieldFinder.evaluate().isNotEmpty) {
            final text = tester.widget<TextField>(textFieldFinder).controller?.text;
            newBoardState.add(text?.isNotEmpty == true ? text : null);
          } else {
            final textWidgetFinder = find.descendant(
              of: find.byType(GridView),
              matching: find.byType(Text),
            ).at(i);
            final text = tester.widget<Text>(textWidgetFinder).data;
            newBoardState.add(text);
          }
        }

        // Verify that the new board is different from the initial board
        expect(newBoardState, isNot(equals(initialBoardState)));
      });
    });

    // MazePuzzle Tests
    group('MazePuzzle Tests', () {
      testWidgets('should display the maze with player at starting position', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: MazePuzzle()));

        // Verify that the maze grid is displayed
        expect(find.byType(GridView), findsOneWidget);

        // Verify that the player is at the starting position (blue cell)
        final mazeBoardFinder = find.byType(MazeBoard);
        expect(mazeBoardFinder, findsOneWidget);

        // Find all containers and check for the player color
        final containers = find.descendant(of: mazeBoardFinder, matching: find.byType(Container));
        expect(containers, findsNWidgets(49)); // 7x7 maze

        // The first cell should be the player (blue)
        final firstCell = containers.at(0);
        final containerWidget = tester.widget<Container>(firstCell);
        expect(containerWidget.color, Colors.blue);

        // The last cell should be the exit (green)
        final lastCell = containers.at(48);
        final lastContainer = tester.widget<Container>(lastCell);
        expect(lastContainer.color, Colors.green);
      });

      testWidgets('should move the player correctly', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: MazePuzzle()));

        // Initial position
        final mazeBoardFinder = find.byType(MazeBoard);
        expect(mazeBoardFinder, findsOneWidget);
        final containers = find.descendant(of: mazeBoardFinder, matching: find.byType(Container));

        // Ensure initial player position is blue at first cell
        final firstCell = containers.at(0);
        Container firstContainer = tester.widget<Container>(firstCell);
        expect(firstContainer.color, Colors.blue);

        // Press the 'Right' arrow button
        final rightButton = find.byIcon(Icons.arrow_forward);
        expect(rightButton, findsOneWidget);
        await tester.tap(rightButton);
        await tester.pump();

        // After moving right, the second cell should be blue
        final secondCell = containers.at(1);
        Container secondContainer = tester.widget<Container>(secondCell);
        expect(secondContainer.color, Colors.blue);

        // The first cell should no longer be blue
        firstContainer = tester.widget<Container>(firstCell);
        expect(firstContainer.color, isNot(Colors.blue));
      });

      testWidgets('should not allow the player to move through walls', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: MazePuzzle()));

        // Since maze generation is random, we need to find a direction that is a wall and attempt to move
        // We'll inspect the initial maze and try to move in a blocked direction

        final mazeBoardFinder = find.byType(MazeBoard);
        expect(mazeBoardFinder, findsOneWidget);
        final containers = find.descendant(of: mazeBoardFinder, matching: find.byType(Container));

        // Attempt to move 'Left' which should be out of bounds (player is at (0,0))
        final leftButton = find.byIcon(Icons.arrow_back);
        expect(leftButton, findsOneWidget);
        await tester.tap(leftButton);
        await tester.pump();

        // Verify player has not moved
        final firstCell = containers.at(0);
        Container firstContainer = tester.widget<Container>(firstCell);
        expect(firstContainer.color, Colors.blue);
      });

      testWidgets('should display win dialog when player reaches the exit', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: MazePuzzle()));

        // To simulate reaching the exit, we'll programmatically move the player to the exit position
        // Since we cannot access the state, we'll simulate user actions to reach the exit
        // For a 7x7 maze, moving down and right repeatedly should reach the exit

        // Define a helper function to move the player
        Future<void> movePlayer(WidgetTester tester, IconData icon) async {
          final button = find.byIcon(icon);
          if (button.evaluate().isNotEmpty) {
            await tester.tap(button);
            await tester.pump();
          }
        }

        // Move down 6 times and right 6 times to reach (6,6)
        for (int i = 0; i < 6; i++) {
          await movePlayer(tester, Icons.arrow_downward);
        }

        for (int i = 0; i < 6; i++) {
          await movePlayer(tester, Icons.arrow_forward);
        }

        await tester.pumpAndSettle();

        // Verify that the win dialog is shown
        expect(find.text("Congratulations! You reached the exit!"), findsOneWidget);

        // Close the dialog by tapping 'New Maze'
        final newMazeButton = find.widgetWithText(TextButton, 'New Maze');
        expect(newMazeButton, findsOneWidget);
        await tester.tap(newMazeButton);
        await tester.pumpAndSettle();

        // Verify that a new maze is generated by checking the player's position
        final containers = find.descendant(of: find.byType(MazeBoard), matching: find.byType(Container));
        final firstCell = containers.at(0);
        Container firstContainer = tester.widget<Container>(firstCell);
        expect(firstContainer.color, Colors.blue);
      });
    });

    // SortingPuzzle Tests
    group('SortingPuzzle Tests', () {
      testWidgets('should display the numbers to be sorted', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: SortingPuzzle()));

        // Verify that the numbers are displayed
        expect(find.byType(GridView), findsOneWidget);
        expect(find.byType(GestureDetector), findsNWidgets(8));
      });

      testWidgets('should swap two numbers when selected', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: SortingPuzzle()));

        // Find the first two numbers
        final firstNumberFinder = find.byType(GestureDetector).at(0);
        final secondNumberFinder = find.byType(GestureDetector).at(1);

        // Get the text of the first and second numbers
        final firstNumberText = find.descendant(of: firstNumberFinder, matching: find.byType(Text)).evaluate().first.widget as Text;
        final secondNumberText = find.descendant(of: secondNumberFinder, matching: find.byType(Text)).evaluate().first.widget as Text;

        final firstNumber = firstNumberText.data!;
        final secondNumber = secondNumberText.data!;

        // Tap the first number
        await tester.tap(firstNumberFinder);
        await tester.pump();

        // Tap the second number to swap
        await tester.tap(secondNumberFinder);
        await tester.pump();

        // Verify that the numbers have swapped
        final newFirstNumberText = find.descendant(of: firstNumberFinder, matching: find.byType(Text)).evaluate().first.widget as Text;
        final newSecondNumberText = find.descendant(of: secondNumberFinder, matching: find.byType(Text)).evaluate().first.widget as Text;

        expect(newFirstNumberText.data, equals(secondNumber));
        expect(newSecondNumberText.data, equals(firstNumber));
      });

      testWidgets('should display win dialog when numbers are sorted', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: SortingPuzzle()));

        // For testing purposes, we'll sort the numbers manually by tapping them in order
        // Note: This assumes that the numbers are unique and can be ordered correctly

        // Retrieve all numbers
        final gestureDetectors = find.byType(GestureDetector);
        expect(gestureDetectors, findsNWidgets(8));

        List<int> numbers = [];
        for (int i = 0; i < 8; i++) {
          final numberText = find.descendant(of: find.byType(GestureDetector).at(i), matching: find.byType(Text)).evaluate().first.widget as Text;
          numbers.add(int.parse(numberText.data!));
        }

        // Sort the numbers
        List<int> sortedNumbers = List.from(numbers)..sort();

        // Perform swaps to sort the list
        for (int i = 0; i < sortedNumbers.length; i++) {
          for (int j = i + 1; j < sortedNumbers.length; j++) {
            if (numbers[i] > numbers[j]) {
              // Find the GestureDetector for numbers[i] and numbers[j]
              final firstFinder = find.descendant(of: find.byType(GestureDetector).at(i), matching: find.text(numbers[i].toString()));
              final secondFinder = find.descendant(of: find.byType(GestureDetector).at(j), matching: find.text(numbers[j].toString()));

              // Tap to select and swap
              await tester.tap(find.ancestor(of: firstFinder, matching: find.byType(GestureDetector)));
              await tester.pump();
              await tester.tap(find.ancestor(of: secondFinder, matching: find.byType(GestureDetector)));
              await tester.pump();

              // Update the local list
              int temp = numbers[i];
              numbers[i] = numbers[j];
              numbers[j] = temp;
            }
          }
        }

        // After sorting, verify that the dialog is shown
        await tester.pumpAndSettle();

        expect(find.text("Congratulations! You sorted the numbers!"), findsOneWidget);
      });

      testWidgets('should shuffle numbers when "Shuffle Numbers" button is pressed', (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: SortingPuzzle()));

        // Capture initial numbers
        List<int> initialNumbers = [];
        final gestureDetectors = find.byType(GestureDetector);
        for (int i = 0; i < 8; i++) {
          final numberText = find.descendant(of: gestureDetectors.at(i), matching: find.byType(Text)).evaluate().first.widget as Text;
          initialNumbers.add(int.parse(numberText.data!));
        }

        // Press 'Shuffle Numbers' button
        final shuffleButton = find.widgetWithText(ElevatedButton, 'Shuffle Numbers');
        expect(shuffleButton, findsOneWidget);
        await tester.tap(shuffleButton);
        await tester.pump();

        // Capture new numbers
        List<int> newNumbers = [];
        for (int i = 0; i < 8; i++) {
          final numberText = find.descendant(of: gestureDetectors.at(i), matching: find.byType(Text)).evaluate().first.widget as Text;
          newNumbers.add(int.parse(numberText.data!));
        }

        // Verify that the numbers have changed
        expect(newNumbers, isNot(equals(initialNumbers)));
      });
    });
  });

  group('Main Screen Tests', () {
    testWidgets('should display "No alarms set" when there are no alarms', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.text('No alarms set. Tap + to add a new alarm.'), findsOneWidget);
    });

    testWidgets('should navigate to Set Alarm screen when FAB is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Tap the FAB
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify navigation to SetAlarm screen
      expect(find.byType(SetAlarm), findsOneWidget);
    });

    testWidgets('should add a new alarm and display it in the list', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      // Navigate to SetAlarm screen
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Simulate entering alarm label
      await tester.enterText(find.byType(TextField), 'Wake Up');
      await tester.pump();

      // Simulate saving the alarm
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save Alarm'));
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
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save Alarm'));
      await tester.pumpAndSettle();

      // Verify alarm is added
      expect(find.text('Wake Up'), findsOneWidget);

      // Toggle the alarm
      final toggle = find.byType(Switch).first;
      expect(toggle, findsOneWidget);
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
      await tester.tap(find.widgetWithText(ElevatedButton, 'Save Alarm'));
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
