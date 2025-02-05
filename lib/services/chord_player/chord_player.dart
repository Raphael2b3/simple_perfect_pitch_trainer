import 'package:audioplayers/audioplayers.dart';

class ChordPlayer {
  List<AudioPlayer> playerList;
  bool oneShot = false;
  void Function()? onPlayerComplete;

  ChordPlayer(this.playerList, this.onPlayerComplete, this.oneShot) {
    for (var player in playerList) {
      player.onPlayerComplete.listen((event) async {
        if (!oneShot) {
          await player.seek(Duration.zero);
          await player.resume();
        } else {
          onPlayerComplete?.call();
        }
      });
    }
  }

  bool get isPlaying =>
      playerList.any((player) => player.state == PlayerState.playing);

  static Future<ChordPlayer> create(
    List<String> notesFilenames,
    void Function()? onPlayerComplete,
    bool oneShot,
  ) async {
    List<AudioPlayer> newPlayers = [];
    for (var filename in notesFilenames) {
      var newPlayer = AudioPlayer();
      await newPlayer.setSourceAsset(filename);
      await newPlayer.setReleaseMode(ReleaseMode.stop);
      newPlayers.add(newPlayer);
    }
    var player = ChordPlayer(newPlayers, onPlayerComplete, oneShot);
    await player.play();
    return player;
  }

  Future<void> play() async {
    for (var player in playerList) {
      await player.resume();
    }
  }

  Future<void> pause() async {
    for (var player in playerList) {
      await player.pause();
    }
  }

  Future<void> dispose() async {
    for (var player in playerList) {
      await player.dispose();
    }
  }
}
