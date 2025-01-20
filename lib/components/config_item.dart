import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_perfect_pitch_trainer/scale_config.dart';

class ConfigItem extends ConsumerStatefulWidget {
  final String name;

  const ConfigItem({super.key, required this.name});

  @override
  ConsumerState<ConfigItem> createState() => _ConfigItemState();
}

class _ConfigItemState extends ConsumerState<ConfigItem> {
  bool active = false;
  late bool isCustom;

  @override
  void initState() {
    super.initState();
    var manager = ref.read(scaleConfigManagerProvider.notifier);
    active = manager.isActive(widget.name);
    isCustom = manager.customConfigs.keys.contains(widget.name);
  }

  @override
  Widget build(BuildContext context) {
    var manager = ref.read(scaleConfigManagerProvider.notifier);
    return Row(
      children: [
        Checkbox(
          value: active,
          onChanged: (v) {
            manager.setActivate(widget.name, v ?? false);
            setState(() {
              active = v ?? false;
            });
          },
        ),
        Expanded(child: Text(widget.name)),
        if (isCustom) ...[
          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
          IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
        ],
      ],
    );
  }
}
