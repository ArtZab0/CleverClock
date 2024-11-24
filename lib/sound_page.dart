import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundPage extends StatelessWidget {
  final AudioPlayer _audioPlayer = AudioPlayer();

  SoundPage({Key? key}) : super(key: key);

  Future<void> _playSound() async {
    await _audioPlayer.play(AssetSource('sound.mp3')); // Adjust file path if necessary
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Play Sound'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _playSound,
          child: Text('Play Sound'),
        ),
      ),
    );
  }
}
