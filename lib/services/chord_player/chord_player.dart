import 'package:audioplayers/audioplayers.dart';

class ChordPlayer {
  List<AudioPlayer> playerList;
  List<AudioPlayer> solutionList;
  bool oneShot = false;

  ChordPlayer(this.playerList, this.solutionList) {
    for (var player in playerList) {
      player.onPlayerComplete.listen((event)async {
        if (!oneShot) {
          await player.seek(Duration.zero);
          print("Seeking to zero");
          await player.resume();
        }
      });
      player.onPlayerStateChanged.listen((PlayerState event) {
        print("Player state changed to ${event}");
      });
    }
  }

  bool get isPlaying =>
      playerList.any((player) => player.state == PlayerState.playing);

  static Future<ChordPlayer> create(
    List<String> notesFilenames,
    List<String> solutionFilenames,
  ) async {
    List<AudioPlayer> newPlayers = [];

    for (var filename in notesFilenames) {
      var newPlayer = AudioPlayer();
      await newPlayer.setPlayerMode(PlayerMode.mediaPlayer);
      await newPlayer.setSourceAsset(filename);
      await newPlayer.setReleaseMode(ReleaseMode.stop);
      newPlayers.add(newPlayer);
    }

    List<AudioPlayer> solutionPlayers = [];
    for (var filename in solutionFilenames) {
      var newPlayer = AudioPlayer();
      await newPlayer.setPlayerMode(PlayerMode.lowLatency);
      await newPlayer.setSourceAsset(filename);
      await newPlayer.setReleaseMode(ReleaseMode.loop);
      solutionPlayers.add(newPlayer);
    }
    var player = ChordPlayer(newPlayers, solutionPlayers);
    return player;
  }

  Future<void> play() async {
    print("Chordplayer Play");
    for (var player in playerList) {
      await player.resume();
    }
  }

  Future<void> callSolution() async {
    print("Chordplayer Play");

    for (var player in playerList) {
      await player.resume();
    }
  }

  Future<void> pause() async {
    print("Chordplayer Pause");
    for (var player in playerList) {
      await player.pause();
    }
  }

  Future<void> dispose() async {
    print("Disposing ChordPlayer");
    for (var player in playerList) {
      await player.dispose();
    }
  }
}
