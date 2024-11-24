// set_alarm.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import 'main.dart'; // To access the Alarm model

class SetAlarm extends StatefulWidget {
  const SetAlarm({super.key});

  @override
  State<SetAlarm> createState() => _SetAlarmState();
}

class _SetAlarmState extends State<SetAlarm> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  final TextEditingController _labelController = TextEditingController();

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Function to save the alarm
  void _saveAlarm() {
    final newAlarm = Alarm(
      time: _selectedTime,
      isActive: true,
      label: _labelController.text.trim(),
    );
    scheduleNotification(newAlarm);
    Navigator.pop(context, newAlarm);
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  void scheduleNotification(Alarm alarm) {
    // Generate a unique ID for each alarm
    int notificationId =
    DateTime.now().millisecondsSinceEpoch.remainder(100000);

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notificationId,
        channelKey: 'basic_channel',
        title: alarm.label.isNotEmpty ? alarm.label : 'Alarm',
        body: 'Clever Clock Alarm',
        category: NotificationCategory.Alarm,
        payload: {'page': 'alarm'},
      ),
      schedule: NotificationCalendar(
        timeZone: "America/New_York",
        hour: alarm.time.hour,
        minute: alarm.time.minute,
        second: 0,
        millisecond: 0,
        preciseAlarm: true,
        repeats: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Alarm'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Time Picker
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Alarm Time'),
              subtitle: Text(_formatTime(_selectedTime)),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: _pickTime,
              ),
            ),
            const SizedBox(height: 20),
            // Label Input
            TextField(
              controller: _labelController,
              decoration: const InputDecoration(
                labelText: 'Label',
                hintText: 'e.g., Wake Up',
                border: OutlineInputBorder(),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
              ],
            ),
            const Spacer(),
            // Save Button
            ElevatedButton(
              onPressed: _saveAlarm,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50), // Make button full width
              ),
              child: const Text('Save Alarm'),
            ),
          ],
        ),
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