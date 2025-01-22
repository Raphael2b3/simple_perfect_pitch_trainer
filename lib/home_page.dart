import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:simple_perfect_pitch_trainer/components/player_controller.dart';
import 'package:simple_perfect_pitch_trainer/components/settings.dart';
import 'package:simple_perfect_pitch_trainer/scale_picker.dart';

import 'services/chord_player.dart';
import 'components/solution.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Solution(),
            Settings(),
            PlayerController(),
          ],
        ),
      ),
    );
  }
}
