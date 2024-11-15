import 'package:flutter/material.dart';
import 'play_puzzle.dart';
import 'settings.dart';
import 'set_alarm.dart';
import 'package:awesome_notifications/awesome_notifications.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(channelKey: 'basic_channel', channelName: 'Basic notifications', channelDescription: 'Notification channel for basic tests', defaultColor: Color(0xFF9D50DD), ledColor: Colors.white)
    ],
    debug: true,
  );
  runApp(const MyApp());
}

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alarm App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Alarms'),
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
  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    super.initState();
  }
  
  List<Alarm> _alarms = [];

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
    setState(() {
      _alarms[index].isActive = value ?? false;
    });
  }

  // Function to delete an alarm
  void _deleteAlarm(int index) {
    setState(() {
      _alarms.removeAt(index);
    });
  }

  // Navigate to SetAlarm page and await the new alarm
  Future<void> _navigateToSetAlarm() async {
    final newAlarm = await Navigator.push<Alarm>(
      context,
      MaterialPageRoute(builder: (context) => const SetAlarm()),
    );

    if (newAlarm != null) {
      _addAlarm(newAlarm);
    }
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
                MaterialPageRoute(builder: (context) => Settings()),
              );
            },
          ),

          /*
          IconButton(
            icon: const Icon(Icons.videogame_asset),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PlayPuzzle()),
              );
            },
          ),
          */

          ElevatedButton(
              onPressed: () {
                // Navigate to the new page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  const MathPuzzle()),
                );
              },
              child: const Text("Math"),
            ),

              ElevatedButton(
              onPressed: () {
                // Navigate to the new page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  const SudokuPuzzle()),
                );
              },
              child: const Text("Sudoku"),
            ),

            ElevatedButton(
              onPressed: () {
                // Navigate to the new page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  const MazePuzzle()),
                );
              },
              child: const Text("Maze"),
            ),

            ElevatedButton(
              onPressed: () {
                // Navigate to the new page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  const SortingPuzzle()),
                );
              },
              child: const Text("Sorting"),
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
                  color:
                  alarm.isActive ? Colors.black : Colors.grey.shade600,
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
              onTap: () {
              },
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
