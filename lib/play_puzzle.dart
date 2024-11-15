import 'package:flutter/material.dart';
import 'dart:math'; // For generating random numbers

class PlayPuzzle extends StatelessWidget {
  const PlayPuzzle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Math Puzzle Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MathGame(),
      ),
    );
  }
}

class MathGame extends StatefulWidget {
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
