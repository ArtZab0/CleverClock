import 'package:flutter/material.dart';
<<<<<<< Updated upstream
=======
import 'package:untitled/ringtone_management.dart';
import 'puzzle_queue_management.dart'; // Import the PuzzleQueueManagementPage
import 'ringtone_page.dart';
>>>>>>> Stashed changes

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}


class _SettingsState extends State<Settings> {
  bool _parentControlEnabled = false;
  String _parentPassword = '';
  bool _snoozeEnabled = false;

  void _toggleParentControl(bool value) {
    if (value) {
      _showPasswordDialogToSet(); // Show password dialog when enabling
    } else {
      _showPasswordDialogToDisable(); // Show password dialog when disabling
    }
  }

  void _showPasswordDialogToSet() {
    // Show a dialog to create a password
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _passwordController = TextEditingController();

        return AlertDialog(
          title: Text("Create Parent Password"),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Enter Password",
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
                _toggleParentControl(false); // Disable parent control if cancelled
              },
            ),
            TextButton(
              child: Text("Set Password"),
              onPressed: () {
                setState(() {
                  _parentPassword = _passwordController.text;
                  _parentControlEnabled = true; // Enable parent control
                  Navigator.of(context).pop(); // Close dialog
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showPasswordDialogToDisable() {
    // Show a dialog to enter the password for disabling
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _passwordController = TextEditingController();

        return AlertDialog(
          title: Text("Enter Password to Disable"),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Enter Password",
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Submit"),
              onPressed: () {
                if (_passwordController.text == _parentPassword) {
                  setState(() {
                    _parentControlEnabled = false; // Disable parent control
                    _parentPassword = ''; // Clear password
                  });
                  Navigator.of(context).pop(); // Close dialog
                } else {
                  // Incorrect password feedback
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Incorrect Password")),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text("Enable Parent Control"),
              value: _parentControlEnabled,
              onChanged: (bool value) {
                _toggleParentControl(value);
              },
            ),
            if (_parentControlEnabled && _parentPassword.isNotEmpty)
              Text("Password set!"),
            Divider(),
            SwitchListTile(
              title: Text("Enable Snooze Button"),
              value: _snoozeEnabled,
              onChanged: (bool value) {
                setState(() {
                  _snoozeEnabled = value;
                });
              },
            ),
<<<<<<< Updated upstream
            Spacer(),
            // The button for setting alarms will be on the home page as specified
=======
            const Divider(),
            ListTile(
              title: const Text("Change Ringtone"),
              leading: const Icon(Icons.music_note),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PuzzleQueueManagementPage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text("Puzzle Queue"),
              subtitle: const Text("Manage your puzzle queue"),
              leading: const Icon(Icons.queue),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                      const PuzzleQueueManagementPage()),
                );
              },
            ),
            const Spacer(),
            // The button for setting alarms is on the home page
>>>>>>> Stashed changes
          ],
        ),
      ),
    );
  }
}
