import 'package:audioplayers/audioplayers.dart';

class ChordPlayer {
  List<AudioPlayer> playerList;

  ChordPlayer(this.playerList);

  get isPlaying =>
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


  Future dispose() async {
    for (var player in playerList) {
      await player.dispose();
    }
  }
}
