// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
//
// class RingtonePage extends StatefulWidget {
//   @override
//   _RingtonePageState createState() => _RingtonePageState();
//
// }
//
// class _RingtonePageState extends State<RingtonePage> {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   final List<Map<String, String>> ringtones = [
//     {"name": "Ringtone 1", "path": "assets/ringtone1.mp3"},
//     {"name": "Ringtone 2", "path": "assets/ringtone2.mp3"},
//     {"name": "Ringtone 3", "path": "assets/ringtone3.mp3"},
//   ];
//
//   void _playRingtone(String path) async {
//     await _audioPlayer.stop(); // Stop any currently playing audio
//     await _audioPlayer.play(AssetSource("assets/ringtone3.mp3"));
//   }
//
//   @override
//   void dispose() {
//     _audioPlayer.dispose(); // Clean up the audio player
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Ringtones'),
//       ),
//       body: ListView.builder(
//         itemCount: ringtones.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(ringtones[index]["name"]!),
//             onTap: () => _playRingtone(ringtones[index]["path"]!),
//             trailing: Icon(Icons.play_arrow),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
//
// // void main() {
// //   runApp(SoundButtonApp());
// // }
//
// class SoundButtonApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Sound Button',
//       home: SoundButtonScreen(),
//     );
//   }
// }
//
// class SoundButtonScreen extends StatelessWidget {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//
//   // Method to play sound
//   void _playSound() async {
//     // await _audioPlayer.play(AssetSource('ringtone1.mp3')); // Ensure this file exists in assets
//     final player = AudioPlayer();
//     player.play(AssetSource('ringtone1.wav'));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sound Button Example'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: _playSound,
//           child: Text('Play Sound'),
//         ),
//       ),
//     );
//   }
// }
