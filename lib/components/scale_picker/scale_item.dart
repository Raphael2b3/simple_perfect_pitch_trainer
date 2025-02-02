import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager/scale_config.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager/scale_manager.dart';

class ScaleItem extends ConsumerWidget {
  final ScaleConfig config;

  const ScaleItem({super.key, required this.config});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Row(
      children: [
        Checkbox(
          value: config.isActive,
          onChanged: (v) {
            config.isActive = v ?? false;
            ref.read(scaleManagerProvider.notifier).updateScale(config);
          },
        ),
        Expanded(child: Text(config.name)),
        if (config.isCustom) ...[
          IconButton(
            onPressed: () {
              //TODO show dialog to edit scale

            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              ref.read(scaleManagerProvider.notifier).deleteScale(config.name);
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ],
    );
  }
}
