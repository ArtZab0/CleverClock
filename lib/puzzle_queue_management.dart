// puzzle_queue_management.dart
import 'package:flutter/material.dart';
import 'puzzle_queue.dart';

class PuzzleQueueManagementPage extends StatefulWidget {
  const PuzzleQueueManagementPage({super.key});

  @override
  _PuzzleQueueManagementPageState createState() =>
      _PuzzleQueueManagementPageState();
}

class _PuzzleQueueManagementPageState
    extends State<PuzzleQueueManagementPage> {
  final PuzzleQueue _puzzleQueue = PuzzleQueue();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Puzzle Queue"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: PuzzleType.values.map((puzzle) {
                return ListTile(
                  title: Text(_getPuzzleName(puzzle)),
                  trailing: const Icon(Icons.add),
                  onTap: () {
                    setState(() {
                      _puzzleQueue.addPuzzle(puzzle);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              '${_getPuzzleName(puzzle)} added to the queue')),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Current Queue:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: _puzzleQueue.queue.isEmpty
                ? const Center(child: Text('Queue is empty'))
                : ReorderableListView(
              shrinkWrap: true,
              onReorder: _onReorder,
              children: List.generate(_puzzleQueue.queue.length, (index) {
                final puzzle = _puzzleQueue.queue[index];
                return ListTile(
                  key: ValueKey('$puzzle$index'),
                  title: Text(_getPuzzleName(puzzle)),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _puzzleQueue.queue.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                '${_getPuzzleName(puzzle)} removed from the queue')),
                      );
                    },
                  ),
                );
              }),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _puzzleQueue.clearQueue();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Queue cleared')),
              );
            },
            child: const Text('Clear Queue'),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final puzzle = _puzzleQueue.queue.removeAt(oldIndex);
      _puzzleQueue.queue.insert(newIndex, puzzle);
    });
  }

  String _getPuzzleName(PuzzleType puzzle) {
    switch (puzzle) {
      case PuzzleType.MathPuzzle:
        return 'Math Puzzle';
      case PuzzleType.SudokuPuzzle:
        return 'Sudoku Puzzle';
      case PuzzleType.MazePuzzle:
        return 'Maze Puzzle';
      case PuzzleType.SortingPuzzle:
        return 'Sorting Puzzle';
      default:
        return 'Unknown Puzzle';
    }
  }

}

