// alarm_page.dart
import 'package:flutter/material.dart';
import 'play_puzzle.dart';
import 'puzzle_queue.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  final PuzzleQueue _puzzleQueue = PuzzleQueue();
  bool _isProcessing = false; // To prevent multiple concurrent puzzle starts

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startNextPuzzle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alarm"),
      ),
      body: Center(
        child: _puzzleQueue.isEmpty && !_isProcessing
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "⏰ Time to wake up!\nNo puzzles in the queue.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Dismiss the alarm page
                Navigator.pop(context);
              },

              child: const Text(
                "Dismiss",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
              ),
            ),
          ],
        )
            : const CircularProgressIndicator(),
      ),
    );
  }

  void _startNextPuzzle() async {
    if (_isProcessing) return; // Prevent re-entry
    if (_puzzleQueue.isEmpty) {
      // No puzzles left, dismiss the alarm page
      Navigator.pop(context);
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    final nextPuzzle = _puzzleQueue.popPuzzle();

    late Widget puzzleWidget;

    switch (nextPuzzle) {
      case PuzzleType.MathPuzzle:
        puzzleWidget = MathPuzzle(
          onPuzzleCompleted: _onPuzzleCompleted,
        );
        break;
      case PuzzleType.SudokuPuzzle:
        puzzleWidget = SudokuPuzzle(
          onPuzzleCompleted: _onPuzzleCompleted,
        );
        break;
      case PuzzleType.MazePuzzle:
        puzzleWidget = MazePuzzle(
          onPuzzleCompleted: _onPuzzleCompleted,
        );
        break;
      case PuzzleType.SortingPuzzle:
        puzzleWidget = SortingPuzzle(
          onPuzzleCompleted: _onPuzzleCompleted,
        );
        break;
      default:
      // Handle unknown puzzle types if any
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unknown Puzzle Type')),
        );
        setState(() {
          _isProcessing = false;
        });
        return; // Exit the method early
    }

    // Navigate to the puzzle and wait for it to complete
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => puzzleWidget),
    );

    // After returning from the puzzle, start the next one
    setState(() {
      _isProcessing = false;
    });
    _startNextPuzzle();
  }

  void _onPuzzleCompleted() {
    // This callback is now redundant since we're handling navigation via await
    // But kept here for potential future use
  }

}

