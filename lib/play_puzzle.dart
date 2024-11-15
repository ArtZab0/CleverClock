import 'package:flutter/material.dart';
import 'dart:math'; // For generating random numbers


class MathPuzzle extends StatelessWidget {
  const MathPuzzle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Math Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MathGame(),
      ),
    );
  }
}


class MathGame extends StatefulWidget {
  const MathGame({super.key});

  @override
  _MathGameState createState() => _MathGameState();
}

class _MathGameState extends State<MathGame> {
  String _input = "";
  int _num1 = 0;
  int _num2 = 0;
  int _correctAnswer = 0;
  String _message = "Solve the problem:";

  @override
  void initState() {
    super.initState();
    _generateNewProblem(); // Generate the first problem
  }

  // This method generates a new addition problem
  void _generateNewProblem() {
    setState(() {
      _num1 = Random().nextInt(10) + 1; // Random number between 1 and 10
      _num2 = Random().nextInt(10) + 1; // Random number between 1 and 10
      _correctAnswer = _num1 + _num2;
      _input = ""; // Clear input for the new problem
      _message = "Solve the problem:";
    });
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
      setState(() {
        _message = "Correct! Next problem:";
        _generateNewProblem(); // Generate a new problem
      });
    } else {
      setState(() {
        _message = "Incorrect! Try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Display the problem
        Text(
          '$_num1 + $_num2 = ?',
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        // Display the user's current input
        Text(
          _input,
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        // Display a message to guide the user
        Text(
          _message,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 20),
        // Keypad grid layout
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
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
              onPressed: _checkAnswer, // Check the answer when 'Enter' is pressed
            ),
          ],
        ),
      ],
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}



// Sudoku game added

class SudokuPuzzle extends StatelessWidget {
  const SudokuPuzzle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SudokuBoard(),
      ),
    );
  }
}

class SudokuBoard extends StatefulWidget {
  const SudokuBoard({super.key});

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
        }
      }
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(correct ? 'Puzzle Solved!' : 'Incorrect solution!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1.0,
          ),
          itemCount: 16,
          itemBuilder: (context, index) {
            int row = index ~/ 4;
            int col = index % 4;
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: _board[row][col] != null
                  ? Center(child: Text('${_board[row][col]}', style: const TextStyle(fontSize: 24)))
                  : TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24),
                      controller: TextEditingController(
                        text: _board[row][col]?.toString() ?? '',
                      ),
                      onChanged: (value) {
                        setState(() {
                          // Allow the user to clear the value or enter a new number
                          _board[row][col] = int.tryParse(value);
                        });
                      },
                    ),
            );
          },
        ),
        ElevatedButton(
          onPressed: _checkSolution,
          child: const Text('Check Solution'),
        ),
        ElevatedButton(
          onPressed: _generatePuzzle,
          child: const Text('New Puzzle'),
        ),
      ],
    );
  }
}



// Maze Game added

class MazePuzzle extends StatelessWidget {
  const MazePuzzle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maze Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MazeBoard(),
      ),
    );
  }
}

class MazeBoard extends StatefulWidget {
  const MazeBoard({super.key});

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
    _maze = List.generate(mazeSize, (_) => List<int>.filled(mazeSize, 1));
    _playerX = 0;
    _playerY = 0;
    _maze[0][0] = 2; // Start
    _maze[mazeSize - 1][mazeSize - 1] = 3; // Exit
    _carvePath(0, 0);
    _ensureExitAccessibility();
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
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: const Text("Congratulations! You reached the exit!"),
            actions: [
              TextButton(
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: mazeSize,
              childAspectRatio: 1.0,
            ),
            itemCount: mazeSize * mazeSize,
            itemBuilder: (context, index) {
              int x = index ~/ mazeSize;
              int y = index % mazeSize;
              Color color;
              if (x == _playerX && y == _playerY) {
                color = Colors.blue; // Player
              } else if (_maze[x][y] == 1) {
                color = Colors.black; // Wall
              } else if (_maze[x][y] == 3) {
                color = Colors.green; // Exit
              } else if (_maze[x][y] == 2) {
                color = Colors.red; // Start
              } else {
                color = Colors.white; // Path
              }
              return Container(
                margin: const EdgeInsets.all(2.0),
                color: color,
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_upward),
              onPressed: () => _movePlayer(-1, 0),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => _movePlayer(0, -1),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => _movePlayer(0, 1),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.arrow_downward),
              onPressed: () => _movePlayer(1, 0),
            ),
          ],
        ),
      ],
    );
  }
}



class SortingPuzzle extends StatelessWidget {
  const SortingPuzzle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sorting Puzzle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SortingGame(),
      ),
    );
  }
}

class SortingGame extends StatefulWidget {
  const SortingGame({super.key});

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
            onPressed: () {
              Navigator.of(context).pop();
              _generateNumbers(); // Generate a new puzzle
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
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _generateNumbers,
          child: const Text("Shuffle Numbers"),
        ),
      ],
    );
  }
}

