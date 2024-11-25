// settings.dart
import 'package:flutter/material.dart';
import 'puzzle_queue_management.dart'; // Import the PuzzleQueueManagementPage

class Settings extends StatefulWidget {
  const Settings({super.key}); // Added const constructor

  @override
  _SettingsState createState() => _SettingsState();
}


class SettingsState {
  static bool isParentControlEnabled = false;
  static String parentPassword = '';
}


class _SettingsState extends State<Settings> {
  bool _parentControlEnabled = false;
  String _parentPassword = '';
  bool _snoozeEnabled = false;

  void _toggleParentControl(bool value) {
    if (value) {

      // If enabling parental control, show the Create Password dialog
      if (_parentPassword.isEmpty) {
        _showPasswordDialogToSet(); // Only show if no password is set
      } else {
        setState(() {
          _parentControlEnabled = true;
          SettingsState.isParentControlEnabled = true;
        });
      }
    } else {
      // If disabling parental control, show Enter Password dialog
      _showPasswordDialogToDisable();

    }
  }

  void _showPasswordDialogToSet() {
    // Show a dialog to create a password
    showDialog(
      context: context,
      builder: (BuildContext context) {

        TextEditingController passwordController = TextEditingController();


        return AlertDialog(
          title: const Text("Create Parent Password"),
          content: TextField(

            controller: passwordController,

            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Enter Password",
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();

                setState(() {
                  // Ensure it doesn't toggle on if cancelled
                  _parentControlEnabled = false;
                });

              },
            ),
            TextButton(
              child: const Text("Set Password"),
              onPressed: () {

                if (passwordController.text.trim().isEmpty) {

                  // Prevent setting empty password
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Password cannot be empty")),
                  );
                  return;
                }
                setState(() {

                  _parentPassword = passwordController.text;
                  _parentControlEnabled = true;
                  SettingsState.isParentControlEnabled = true;
                  SettingsState.parentPassword = passwordController.text;
                });
                Navigator.of(context).pop(); // Close the dialog

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

        TextEditingController passwordController = TextEditingController();


        return AlertDialog(
          title: const Text("Enter Password to Disable"),
          content: TextField(

            controller: passwordController,

            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Enter Password",
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Submit"),
              onPressed: () {

                if (passwordController.text == _parentPassword) {
                  setState(() {
                    _parentControlEnabled = false;
                    SettingsState.isParentControlEnabled = false;
                    SettingsState.parentPassword = '';
                  });
                  Navigator.of(context).pop(); // Close dialog after disabling

                } else {
                  // Incorrect password feedback
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Incorrect Password")),
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
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text("Enable Parent Control"),
              value: _parentControlEnabled,
              onChanged: (bool value) {
                _toggleParentControl(value);
              },
            ),
            if (_parentControlEnabled && _parentPassword.isNotEmpty)
              const Text("Password set!"),
            const Divider(),
            SwitchListTile(
              title: const Text("Enable Snooze Button"),
              value: _snoozeEnabled,
              onChanged: (bool value) {
                setState(() {
                  _snoozeEnabled = value;
                });
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

          ],
        ),
      ),
    );
  }
}