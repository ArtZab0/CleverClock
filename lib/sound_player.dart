// import 'package:flutter_sound/flutter_sound.dart';
//
// class SoundPlayer {
//   // Private constructor
//   SoundPlayer._privateConstructor();
//
//   // Create the single instance
//   static final SoundPlayer instance = SoundPlayer._privateConstructor();
//
//   // FlutterSoundPlayer instance
//   final FlutterSoundPlayer player = FlutterSoundPlayer();
//
//   // Start playing sound
//   Future<void> startPlayer(String uri) async {
//     await player.startPlayer(
//       fromURI: uri,
//       codec: Codec.mp3,
//       whenFinished: () {
//         // Optionally, loop the sound if necessary
//         startPlayer(uri);
//       },
//     );
//   }
//
//   // Stop playing sound
//   Future<void> stopPlayer() async {
//     await player.stopPlayer();
//   }
// }
