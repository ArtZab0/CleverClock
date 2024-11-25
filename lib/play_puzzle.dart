// play_puzzle.dart
import 'package:flutter/material.dart';
import 'dart:math'; // For generating random numbers

// NumberGenerator Interface
abstract class NumberGenerator {
  int nextInt(int max);
}

// RealNumberGenerator Implementation
class RealNumberGenerator implements NumberGenerator {
  final Random _random;

  RealNumberGenerator([int? seed]) : _random = seed != null ? Random(seed) : Random();

  @override
  int nextInt(int max) => _random.nextInt(max);
}

// MockNumberGenerator Implementation for Testing
class MockNumberGenerator implements NumberGenerator {
  final List<int> _values;
  int _index = 0;

  MockNumberGenerator(this._values);

  @override
  int nextInt(int max) {
    if (_index < _values.length) {
      return _values[_index++] % max;
    }
    // Optionally, throw an error or return a default value if out of predefined values
    return 0;
  }
}

//////////////////////////////
// Math Puzzle Implementation
//////////////////////////////

// Math Puzzle
class MathPuzzle extends StatelessWidget {
  final NumberGenerator? numberGenerator;
  final VoidCallback? onPuzzleCompleted;

  const MathPuzzle({super.key, this.numberGenerator, this.onPuzzleCompleted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Math Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MathGame(
          numberGenerator: numberGenerator,
          onPuzzleCompleted: onPuzzleCompleted,
        ),
      ),
    );
  }
}

class MathGame extends StatefulWidget {
  final NumberGenerator? numberGenerator;
  final VoidCallback? onPuzzleCompleted;

  const MathGame({super.key, this.numberGenerator, this.onPuzzleCompleted});

  @override
  _MathGameState createState() => _MathGameState();
}

class _MathGameState extends State<MathGame> {
  String _input = "";
  int _num1 = 0;
  int _num2 = 0;
  int _correctAnswer = 0;
  String _message = "Solve the problem:";
  late NumberGenerator _numberGenerator;
  int? _previousNum1;
  int? _previousNum2;

  @override
  void initState() {
    super.initState();
    _numberGenerator = widget.numberGenerator ?? RealNumberGenerator();
    _generateNewProblem(); // Generate the first problem
  }

  // This method generates a new addition problem
  void _generateNewProblem() {
    int newNum1, newNum2;
    // Ensure the new problem is different from the previous one
    do {
      newNum1 = _numberGenerator.nextInt(10) + 1; // Random number between 1 and 10
      newNum2 = _numberGenerator.nextInt(10) + 1; // Random number between 1 and 10
    } while (newNum1 == _previousNum1 && newNum2 == _previousNum2);

    _num1 = newNum1;
    _num2 = newNum2;
    _previousNum1 = _num1;
    _previousNum2 = _num2;
    _correctAnswer = _num1 + _num2;
    _input = ""; // Clear input for the new problem
    _message = "Solve the problem:"; // Reset message
    setState(() {});
  }

  // This method handles number presses
  void _onKeyPressed(String value) {
    setState(() {
      _input += value;
    });
  }

  // This method checks if the user's answer is correct
  void _checkAnswer() {
    if (_input.isNotEmpty && int.tryParse(_input) == _correctAnswer) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text("Correct!"),
          actions: [
            TextButton(
              key: const Key('ok_button'),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                if (widget.onPuzzleCompleted != null) {
                  widget.onPuzzleCompleted!();
                  Navigator.of(context).pop(); // Close the puzzle page
                } else {
                  _generateNewProblem(); // Continue with new problem
                }
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        _message = "Incorrect! Try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Display the problem
          Text(
            '$_num1 + $_num2 = ?',
            key: const Key('problem_text'),
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // Display the user's current input
          Text(
            _input,
            key: const Key('input_text'),
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // Display a message to guide the user
          Text(
            _message,
            key: const Key('message_text'),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 20),
          // Keypad grid layout
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics:
            const NeverScrollableScrollPhysics(), // Prevent GridView from scrolling separately
            children: <Widget>[
              ...List.generate(9, (index) {
                return KeypadButton(
                  label: '${index + 1}',
                  onPressed: () => _onKeyPressed('${index + 1}'),
                );
              }),
              KeypadButton(
                label: '0',
                onPressed: () => _onKeyPressed('0'),
              ),
              KeypadButton(
                label: 'Clear',
                onPressed: () {
                  setState(() {
                    _input = "";
                  });
                },
              ),
              KeypadButton(
                label: 'Enter',
                onPressed:
                _checkAnswer, // Check the answer when 'Enter' is pressed
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Reusable keypad button widget
class KeypadButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const KeypadButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Assign Keys to buttons with unique labels for testing
    final buttonKey = Key('keypad_button_$label');
    return Padding(
      padding: const EdgeInsets.all(4.0), // Adjusted padding for better fit
      child: ElevatedButton(
        key: buttonKey,
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}

//////////////////////////////
// Sudoku Puzzle Implementation
//////////////////////////////

// Sudoku Puzzle
class SudokuPuzzle extends StatelessWidget {
  final VoidCallback? onPuzzleCompleted;
  final List<List<int>>? predefinedSudoku; // Optional parameter for testing

  const SudokuPuzzle(
      {super.key, this.onPuzzleCompleted, this.predefinedSudoku});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SudokuBoard(
          predefinedSudoku: predefinedSudoku,
          onPuzzleCompleted: onPuzzleCompleted,
        ),
      ),
    );
  }
}

class SudokuBoard extends StatefulWidget {
  final List<List<int>>? predefinedSudoku; // Optional parameter for testing
  final VoidCallback? onPuzzleCompleted;

  const SudokuBoard(
      {super.key, this.predefinedSudoku, this.onPuzzleCompleted});

  @override
  _SudokuBoardState createState() => _SudokuBoardState();
}

class _SudokuBoardState extends State<SudokuBoard> {
  List<List<int?>> _board = List.generate(4, (_) => List<int?>.filled(4, null));
  List<List<int>> _solution = [];

  @override
  void initState() {
    super.initState();
    _generatePuzzle();
  }

  // Generates a new 4x4 Sudoku puzzle
  void _generatePuzzle() {
    if (widget.predefinedSudoku != null) {
      // Use predefined puzzle and solution
      _solution = List.generate(4, (i) => List<int>.from(widget.predefinedSudoku![i]));
      _board = List.generate(4, (i) => List<int?>.from(widget.predefinedSudoku![i]));
    } else {
      _solution = _generateValidSolution();
      _board = List.generate(4, (i) => List<int?>.from(_solution[i]));

      // Randomly remove some cells to create the puzzle
      for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
          if (Random().nextBool()) {
            _board[i][j] = null; // Set some cells to null for the puzzle
          }
        }
      }
    }
    setState(() {});
  }

  // Generates a valid 4x4 Sudoku solution by permuting numbers
  List<List<int>> _generateValidSolution() {
    List<int> base = [1, 2, 3, 4];
    base.shuffle(); // Shuffle base numbers

    return [
      [base[0], base[1], base[2], base[3]],
      [base[2], base[3], base[0], base[1]],
      [base[1], base[0], base[3], base[2]],
      [base[3], base[2], base[1], base[0]],
    ];
  }

  // Checks if the board matches the solution
  void _checkSolution() {
    bool correct = true;
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (_board[i][j] != _solution[i][j]) {
          correct = false;
          break;
        }
      }
      if (!correct) break;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(correct ? 'Puzzle Solved!' : 'Incorrect solution!'),
        actions: [
          TextButton(
            key: const Key('ok_button'),
            onPressed: () {
              Navigator.of(context).pop();
              if (correct && widget.onPuzzleCompleted != null) {
                widget.onPuzzleCompleted!();
                Navigator.of(context).pop(); // Close the puzzle page
              } else if (correct) {
                _generatePuzzle(); // Start new puzzle only if solved
              }
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Build the grid using Rows and Columns
        Expanded(
          child: Column(
            children: [
              for (int row = 0; row < 4; row++)
                Expanded(
                  child: Row(
                    children: [
                      for (int col = 0; col < 4; col++)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: _board[row][col] != null
                                ? Container(
                              key: Key('cell_${row}_$col'),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                color: Colors.grey[300],
                              ),
                              child: Center(
                                child: Text(
                                  '${_board[row][col]}',
                                  style: const TextStyle(fontSize: 24),
                                ),
                              ),
                            )
                                : TextField(
                              key: Key('input_cell_${row}_$col'),
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 24),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  // Allow the user to clear the value or enter a new number
                                  _board[row][col] = int.tryParse(value);
                                });
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          key: const Key('check_solution_button'),
          onPressed: _checkSolution,
          child: const Text('Check Solution'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          key: const Key('new_puzzle_button'),
          onPressed: _generatePuzzle,
          child: const Text('New Puzzle'),
        ),
      ],
    );
  }
}

//////////////////////////////
// Maze Puzzle Implementation
//////////////////////////////

// Maze Puzzle
class MazePuzzle extends StatelessWidget {
  final VoidCallback? onPuzzleCompleted;
  final List<List<int>>? predefinedMaze; // Optional parameter for testing

  const MazePuzzle(
      {super.key, this.onPuzzleCompleted, this.predefinedMaze});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maze Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MazeBoard(
          predefinedMaze: predefinedMaze,
          onPuzzleCompleted: onPuzzleCompleted,
        ),
      ),
    );
  }
}

class MazeBoard extends StatefulWidget {
  final List<List<int>>? predefinedMaze; // Optional parameter for testing
  final VoidCallback? onPuzzleCompleted;

  const MazeBoard(
      {super.key, this.predefinedMaze, this.onPuzzleCompleted});

  @override
  _MazeBoardState createState() => _MazeBoardState();
}

class _MazeBoardState extends State<MazeBoard> {
  static const int mazeSize = 7;
  List<List<int>> _maze = List.generate(mazeSize, (_) => List<int>.filled(mazeSize, 1));
  late int _playerX, _playerY;

  @override
  void initState() {
    super.initState();
    _generateMaze();
  }

  // Maze cell types: 0 = open path, 1 = wall, 2 = start, 3 = exit
  void _generateMaze() {
    if (widget.predefinedMaze != null) {
      // Use predefined maze
      _maze = List.generate(mazeSize, (i) => List<int>.from(widget.predefinedMaze![i]));
      _playerX = 0;
      _playerY = 0;
    } else {
      // Generate random maze
      _maze = List.generate(mazeSize, (_) => List<int>.filled(mazeSize, 1));
      _playerX = 0;
      _playerY = 0;
      _maze[0][0] = 2; // Start
      _maze[mazeSize - 1][mazeSize - 1] = 3; // Exit
      _carvePath(0, 0);
      _ensureExitAccessibility();
    }
    setState(() {});
  }

  // DFS-based path carving
  void _carvePath(int x, int y) {
    List<List<int>> directions = [
      [0, 1],
      [1, 0],
      [0, -1],
      [-1, 0]
    ];
    directions.shuffle();

    for (var direction in directions) {
      int nx = x + direction[0] * 2;
      int ny = y + direction[1] * 2;
      if (_isInBounds(nx, ny) && _maze[nx][ny] == 1) {
        _maze[x + direction[0]][y + direction[1]] = 0; // Open wall between cells
        _maze[nx][ny] = 0; // Open the new cell
        _carvePath(nx, ny);
      }
    }
  }

  bool _isInBounds(int x, int y) {
    return x >= 0 && y >= 0 && x < mazeSize && y < mazeSize;
  }

  // Ensure there's a clear path to the exit
  void _ensureExitAccessibility() {
    int exitX = mazeSize - 1;
    int exitY = mazeSize - 1;

    // If surrounded by walls, open a path either from above or from the left
    if (_maze[exitX - 1][exitY] == 1 && _maze[exitX][exitY - 1] == 1) {
      _maze[exitX - 1][exitY] = 0; // Clear path from above
    }
  }

  void _movePlayer(int dx, int dy) {
    int newX = _playerX + dx;
    int newY = _playerY + dy;

    if (_isInBounds(newX, newY) && _maze[newX][newY] != 1) {
      setState(() {
        _playerX = newX;
        _playerY = newY;
      });
      if (_maze[_playerX][_playerY] == 3) {
        if (widget.onPuzzleCompleted != null) {
          widget.onPuzzleCompleted!();
          Navigator.of(context).pop(); // Close the puzzle page
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: const Text("Congratulations! You reached the exit!"),
              actions: [
                TextButton(
                  key: const Key('new_maze_button'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _generateMaze(); // Start a new maze
                  },
                  child: const Text("New Maze"),
                ),
              ],
            ),
          );
        }
      }
    }
  }

  Color _getCellColor(int x, int y) {
    if (x == _playerX && y == _playerY) {
      return Colors.blue; // Player
    } else if (_maze[x][y] == 1) {
      return Colors.black; // Wall
    } else if (_maze[x][y] == 3) {
      return Colors.green; // Exit
    } else if (_maze[x][y] == 2) {
      return Colors.red; // Start
    } else {
      return Colors.white; // Path
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Maze grid built with Column and Row
        Expanded(
          child: Column(
            children: [
              for (int x = 0; x < mazeSize; x++)
                Expanded(
                  child: Row(
                    children: [
                      for (int y = 0; y < mazeSize; y++)
                        Expanded(
                          child: Container(
                            key: Key('maze_cell_${x}_$y'),
                            margin: const EdgeInsets.all(2.0),
                            color: _getCellColor(x, y),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Movement buttons with Keys
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              key: const Key('move_up_button'),
              onPressed: () => _movePlayer(-1, 0),
              child: const Icon(Icons.arrow_upward),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              key: const Key('move_left_button'),
              onPressed: () => _movePlayer(0, -1),
              child: const Icon(Icons.arrow_back),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              key: const Key('move_right_button'),
              onPressed: () => _movePlayer(0, 1),
              child: const Icon(Icons.arrow_forward),
            ),

          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              key: const Key('move_down_button'),
              onPressed: () => _movePlayer(1, 0),
              child: const Icon(Icons.arrow_downward),
            ),
          ],
        ),
      ],
    );
  }
}

//////////////////////////////
// Sorting Puzzle Implementation
//////////////////////////////

// Sorting Puzzle
class SortingPuzzle extends StatelessWidget {
  final VoidCallback? onPuzzleCompleted;

  const SortingPuzzle({super.key, this.onPuzzleCompleted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sorting Puzzle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SortingGame(
          onPuzzleCompleted: onPuzzleCompleted,
        ),
      ),
    );
  }
}

class SortingGame extends StatefulWidget {
  final VoidCallback? onPuzzleCompleted;

  const SortingGame({super.key, this.onPuzzleCompleted});

  @override
  _SortingPuzzleState createState() => _SortingPuzzleState();
}

class _SortingPuzzleState extends State<SortingGame> {
  List<int> _numbers = [];
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _generateNumbers();
  }

  // Generate a random sequence of numbers
  void _generateNumbers() {
    final random = Random();
    _numbers = List.generate(8, (index) => random.nextInt(100) + 1);
    _selectedIndex = null;
    setState(() {});
  }

  // Swap two numbers when the player selects them
  void _swapNumbers(int index) {
    if (_selectedIndex == null) {
      // First selection
      setState(() {
        _selectedIndex = index;
      });
    } else {
      if (_selectedIndex == index) {
        // Deselect if same button is pressed
        setState(() {
          _selectedIndex = null;
        });
        return;
      }
      // Second selection, perform swap
      setState(() {
        int temp = _numbers[_selectedIndex!];
        _numbers[_selectedIndex!] = _numbers[index];
        _numbers[index] = temp;
        _selectedIndex = null;
      });

      // Check if the game is won
      if (_isSorted()) {
        _showWinDialog();
      }
    }
  }

  // Check if the list is sorted in ascending order
  bool _isSorted() {
    for (int i = 0; i < _numbers.length - 1; i++) {
      if (_numbers[i] > _numbers[i + 1]) return false;
    }
    return true;
  }

  // Show a dialog when the player wins
  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("Congratulations! You sorted the numbers!"),
        actions: [
          TextButton(
            key: const Key('play_again_button'),
            onPressed: () {
              Navigator.of(context).pop();
              if (widget.onPuzzleCompleted != null) {
                widget.onPuzzleCompleted!();
                Navigator.of(context).pop(); // Close the puzzle page
              } else {
                _generateNumbers(); // Generate a new puzzle
              }
            },
            child: const Text("Play Again"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Sort the numbers in ascending order",
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 20),
        // Display the numbers
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // Display numbers in a grid
            childAspectRatio: 2.0,
          ),
          itemCount: _numbers.length,
          itemBuilder: (context, index) {
            final isSelected = index == _selectedIndex;
            return GestureDetector(
              key: Key('number_$index'),
              onTap: () => _swapNumbers(index),
              child: Container(
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.grey[300],
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    _numbers[index].toString(),
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          key: const Key('shuffle_numbers_button'),
          onPressed: _generateNumbers,
          child: const Text("Shuffle Numbers"),
        ),
      ],
    );
  }

}