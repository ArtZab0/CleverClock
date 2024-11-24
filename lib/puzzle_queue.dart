// puzzle_queue.dart
import 'package:flutter/material.dart';


enum PuzzleType {
  MathPuzzle,
  SudokuPuzzle,
  MazePuzzle,
  SortingPuzzle,
}

class PuzzleQueue {
  static final PuzzleQueue _instance = PuzzleQueue._internal();

  factory PuzzleQueue() {
    return _instance;
  }

  PuzzleQueue._internal();

  final List<PuzzleType> _queue = [];

  List<PuzzleType> get queue => _queue;

  void addPuzzle(PuzzleType puzzle) {
    _queue.add(puzzle);
  }

  PuzzleType? popPuzzle() {
    if (_queue.isNotEmpty) {
      return _queue.removeAt(0);
    }
    return null;
  }

  void clearQueue() {
    _queue.clear();
  }

  bool get isEmpty => _queue.isEmpty;

  int get length => _queue.length;

}

