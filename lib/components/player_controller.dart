import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_perfect_pitch_trainer/services/chord_player.dart';
import 'package:simple_perfect_pitch_trainer/services/settings_provider.dart';

import '../scale_picker.dart';

class PlayerController extends ConsumerStatefulWidget {
  const PlayerController({super.key});

  @override
  ConsumerState<PlayerController> createState() => _PlayerControllerState();
}

class _PlayerControllerState extends ConsumerState<PlayerController> {
  @override
  Widget build(BuildContext context) {
    var player = ref.read(chordPlayerProvider.notifier);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed:
              () async =>
          await ref.read(chordPlayerProvider.notifier).pause(),
          child: const Text("Previous"),
        ),
        if (player.isPlaying)
          OutlinedButton(
            onPressed:
                () async =>
            await ref.read(chordPlayerProvider.notifier)
                .pause(),
            child: const Text("Pause"),
          )
        else
          FilledButton(
            onPressed:
                () async =>
            await ref.read(chordPlayerProvider.notifier)
                .resume(),
            child: const Text("Play"),
          ),
        TextButton(
          onPressed:
              () async =>
          await ref.read(chordPlayerProvider.notifier).forward(ref.read(settingsProviderProvider)),
          child: const Text("Next"),
        ),
      ]
      ,
    );
  }
}
