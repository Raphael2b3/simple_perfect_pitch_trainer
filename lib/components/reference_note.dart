import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class ReferenceNote extends StatefulWidget {
  const ReferenceNote({super.key});

  @override
  State<ReferenceNote> createState() => _ReferenceNoteState();
}

class _ReferenceNoteState extends State<ReferenceNote> {
  late AudioPlayer player;

  @override
  void initState() {
    initPlayer().then((e) {
      setState(() {});
    });
    super.initState();
  }

  Future<void> playerMagic() async {
    if (player.state == PlayerState.playing) {
      await player.pause();
    } else {
      await player.seek(Duration.zero);
      await player.resume();
    }
  }

  Future<void> initPlayer() async {
    var newPlayer = AudioPlayer();
    await newPlayer.setPlayerMode(PlayerMode.mediaPlayer);
    await newPlayer.setSourceAsset("notes/A1.mp3");
    await newPlayer.setReleaseMode(ReleaseMode.stop);
    player = newPlayer;
  }

  @override
  void dispose() async {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom:20),
      child: OutlinedButton(
        onPressed: () => playerMagic(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [Text("(A1)"), Icon(Icons.music_note)],
        ),
      ),
    );
  }
}
