import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

class SoundPage extends StatelessWidget {
  // final AudioPlayer _audioPlayer = AudioPlayer();
  final player = AudioPlayer();

  SoundPage({Key? key}) : super(key: key);

  Future<void> _playSound() async {
    print('Button pressed!');
    await player.setSource(AssetSource('ringtone.mp3'));
    await player.resume();
    // await _audioPlayer.play(AssetSource('ringtone.mp3')); // Adjust file path if necessary
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
