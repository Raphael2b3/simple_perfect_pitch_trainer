import 'package:audioplayers/audioplayers.dart';

class ChordPlayer {

  ChordPlayer(this.playerList);

  bool get isPlaying =>
      playerList.any((player) => player.state == PlayerState.playing);

  static Future<ChordPlayer> create(List<String> filenames) async {
    List<AudioPlayer> newPlayers = [];
    for (var filename in filenames) {
      var newPlayer = AudioPlayer();
      await newPlayer.setPlayerMode(PlayerMode.lowLatency);
      await newPlayer.setSourceAsset(filename);
      await newPlayer.setReleaseMode(ReleaseMode.loop);
      newPlayers.add(newPlayer);
    }
    return ChordPlayer(newPlayers);
  }


  List<AudioPlayer> playerList;
  Future dispose() async {
    print("Disposing ChordPlayer");
    for (var player in playerList) {
      await player.dispose();
      // E: Concurrent modification during iteration: Instance(length:2) of '_GrowableList'.
    }
  }
}
