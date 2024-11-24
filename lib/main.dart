// main.dart
import 'package:flutter/material.dart';
import 'dart:math'; // For generating random numbers
import 'play_puzzle.dart';
import 'settings.dart';
import 'set_alarm.dart';
import 'alarm_page.dart';
import 'puzzle_queue.dart';
import 'puzzle_queue_management.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

// Alarm model
class Alarm {
  TimeOfDay time;
  bool isActive;
  String label;

  Alarm({
    required this.time,
    this.isActive = true,
    this.label = '',
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true),
    ],
    debug: true,
  );

  // Set notification listeners
  AwesomeNotifications().setListeners(
    onActionReceivedMethod: onActionReceivedMethod,
    // You can also set other listeners like onNotificationCreatedMethod, onNotificationDisplayedMethod, etc.
  );

  runApp(const MyApp());
}

// Define the method to handle notification actions
Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
  if (receivedAction.payload != null && receivedAction.payload!['page'] == 'alarm') {
    MyApp.navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => const AlarmPage()),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // Request notification permissions on app start
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: MyApp.navigatorKey,
      title: 'Alarm App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Alarms'),
      routes: {
        '/game_selection': (context) => const GameSelectionPage(),
        '/math_puzzle': (context) => const MathPuzzle(),
        '/sudoku_puzzle': (context) => const SudokuPuzzle(),
        '/maze_puzzle': (context) => const MazePuzzle(),
        '/sorting_puzzle': (context) => const SortingPuzzle(),
        '/settings': (context) => const Settings(),
        '/alarm': (context) => const AlarmPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Alarm> _alarms = [];

  // Function to add a new alarm
  void _addAlarm(Alarm alarm) {
    setState(() {
      _alarms.add(alarm);
      _alarms.sort((a, b) {
        final aMinutes = a.time.hour * 60 + a.time.minute;
        final bMinutes = b.time.hour * 60 + b.time.minute;
        return aMinutes.compareTo(bMinutes);
      });
    });
  }

  // Function to toggle alarm activation
  void _toggleAlarm(int index, bool? value) {
  if (SettingsState.isParentControlEnabled) { // Static method to access state
    _showPasswordDialog(index, value);
  } else {
    _updateAlarmToggle(index, value);
  }
}


void _updateAlarmToggle(int index, bool? value) {
  setState(() {
    _alarms[index].isActive = value ?? false;
  });
}

void _showPasswordDialog(int index, bool? value) {
  TextEditingController passwordController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Enter Parent Password"),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: "Password",
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
              if (passwordController.text ==
                  SettingsState.parentPassword) { // Check password
                Navigator.of(context).pop();
                _updateAlarmToggle(index, value);
              } else {
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


  // Function to delete an alarm
  void _deleteAlarm(int index) {
    setState(() {
      _alarms.removeAt(index);
    });
  }

  // Navigate to SetAlarm page and await the new alarm
  Future<void> _navigateToSetAlarm() async {
    if (SettingsState.isParentControlEnabled) {
      // If parent control is enabled, prompt for password before opening SetAlarm page
      bool? isPasswordCorrect = await _showPasswordPrompt();
      if (isPasswordCorrect == true) {
        // Navigate to SetAlarm if password is correct
        final newAlarm = await Navigator.push<Alarm>(
          context,
          MaterialPageRoute(builder: (context) => const SetAlarm()),
        );

        if (newAlarm != null) {
          _addAlarm(newAlarm);
        }
      }
    } else {
      // If no parent control, directly navigate to SetAlarm page
      final newAlarm = await Navigator.push<Alarm>(
        context,
        MaterialPageRoute(builder: (context) => const SetAlarm()),
      );

      if (newAlarm != null) {
        _addAlarm(newAlarm);
      }
    }
  }

  // Method to show the password prompt for parent control
  Future<bool?> _showPasswordPrompt() async {
    TextEditingController passwordController = TextEditingController();
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter Parent Password"),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Password",
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false); // Return false on cancel
              },
            ),
            TextButton(
              child: const Text("Submit"),
              onPressed: () {
                if (passwordController.text == SettingsState.parentPassword) {
                  Navigator.of(context).pop(true); // Return true if password is correct
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Incorrect Password")),
                  );
                  Navigator.of(context).pop(false); // Return false on incorrect password
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Navigate to Game Selection Page
  void _navigateToGameSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GameSelectionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Settings()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.videogame_asset),
            onPressed: _navigateToGameSelection,
          ),
        ],
      ),
      body: _alarms.isEmpty
          ? const Center(
        child: Text(
          'No alarms set. Tap + to add a new alarm.',
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: _alarms.length,
        itemBuilder: (context, index) {
          final alarm = _alarms[index];
          return Dismissible(
            key: UniqueKey(),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _deleteAlarm(index);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Alarm deleted')),
              );
            },
            child: ListTile(
              leading: Icon(
                alarm.isActive ? Icons.alarm : Icons.alarm_off,
                color: alarm.isActive ? Colors.blue : Colors.grey,
              ),
              title: Text(
                _formatTime(alarm.time),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: alarm.isActive
                      ? Colors.black
                      : Colors.grey.shade600,
                ),
              ),
              subtitle: alarm.label.isNotEmpty
                  ? Text(
                alarm.label,
                style: TextStyle(
                  color: alarm.isActive
                      ? Colors.black
                      : Colors.grey.shade600,
                ),
              )
                  : null,
              trailing: Switch(
                value: alarm.isActive,
                onChanged: (value) {
                  _toggleAlarm(index, value);
                },
              ),
              onTap: () {},
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToSetAlarm,
        tooltip: 'Add Alarm',
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }
}

// GameSelectionPage remains the same as before

// GameSelectionPage
class GameSelectionPage extends StatelessWidget {
  const GameSelectionPage({super.key});

  // You can customize the list of games here
  final List<_GameItem> _games = const [
    _GameItem(
        title: 'Math Puzzle',
        icon: Icons.calculate,
        routeName: '/math_puzzle'),
    _GameItem(
        title: 'Sudoku', icon: Icons.grid_on, routeName: '/sudoku_puzzle'),
    _GameItem(
        title: 'Maze', icon: Icons.terrain, routeName: '/maze_puzzle'),
    _GameItem(
        title: 'Sorting Puzzle',
        icon: Icons.sort,
        routeName: '/sorting_puzzle'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Game'),
      ),
      body: ListView.builder(
        itemCount: _games.length,
        itemBuilder: (context, index) {
          final game = _games[index];
          return ListTile(
            leading:
            Icon(game.icon, color: Theme.of(context).colorScheme.primary),
            title: Text(
              game.title,
              style: const TextStyle(fontSize: 18),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  switch (game.routeName) {
                    case '/math_puzzle':
                      return MathPuzzle(
                        onPuzzleCompleted: () {},
                      );
                    case '/sudoku_puzzle':
                      return SudokuPuzzle(
                        onPuzzleCompleted: () {},
                      );
                    case '/maze_puzzle':
                      return MazePuzzle(
                        onPuzzleCompleted: () {},
                      );
                    case '/sorting_puzzle':
                      return SortingPuzzle(
                        onPuzzleCompleted: () {},
                      );
                    default:
                      return const Scaffold(
                        body: Center(child: Text('Game not found')),
                      );
                  }
                }),
              );
              // Alternatively, using named routes:
              // Navigator.pushNamed(context, game.routeName);
            },
          );
        },
      ),
    );
  }
}

// Helper class to represent a game item
class _GameItem {
  final String title;
  final IconData icon;
  final String routeName;

  const _GameItem({
    required this.title,
    required this.icon,
    required this.routeName,
  });
}         