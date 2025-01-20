import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'components/switch_button.dart';

class ScaleEditor extends ConsumerStatefulWidget {
  const ScaleEditor({super.key});

  @override
  ConsumerState<ScaleEditor> createState() => _ScaleEditorState();
}

class _ScaleEditorState extends ConsumerState<ScaleEditor> {
  static const List<String> possibleNotes = [
    "1",
    "b2",
    "2",
    "b3",
    "3",
    "4",
    "b5",
    "5",
    "b6",
    "6",
    "7",
    "j7",
  ];
  late List<bool> selectedNotes = possibleNotes.map((e) => false).toList();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: selectedNotes.length,
        itemBuilder:
            (c, i) => SwitchButton(
              onChange: (o, n) => selectedNotes[i] = n,
              child: Text(possibleNotes[i]),
            ),
      ),
    );
  }
}
