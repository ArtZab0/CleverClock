import 'package:flutter/material.dart';
import 'play_puzzle.dart';

class AlarmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alarm"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
          children: [
            Text(
              "⏰ Time to wake up!\nSolve the puzzle to turn off the alarm.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
                height: 1.5, // Line height for better readability
              ),
            ),
            SizedBox(height: 40), // Add some space between the text and button
            ElevatedButton(
              onPressed: () {
                // Navigate to the new page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MathPuzzle()),
                );
              },              child: Text(
                "Start", // Text on the button
                style: TextStyle(
                  fontSize: 24, // Larger font for the button text
                  fontWeight: FontWeight.bold, // Make the text bold
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Increase padding for larger button
                foregroundColor: Colors.blueAccent, // Button background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                elevation: 8, // Shadow effect for the button
              ),
            ),
          ],
        ),
      ),
    );
  }
}
