import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager/scale_manager.dart';

class ScaleItem extends ConsumerStatefulWidget {
  final String name;

  const ScaleItem({super.key, required this.name});

  @override
  ConsumerState<ScaleItem> createState() => _ScaleItemState();
}

class _ScaleItemState extends ConsumerState<ScaleItem> {
  bool active = false;
  late bool isCustom;

  @override
  void initState() {
    super.initState();
    var manager = ref.read(scaleManagerProvider.notifier);
    active = manager.isActive(widget.name);
    isCustom = manager.isCustom(widget.name);
  }

  @override
  Widget build(BuildContext context) {
    var manager = ref.watch(scaleManagerProvider.notifier);
    active = manager.isActive(widget.name);
    return Row(
      children: [
        Checkbox(
          value: active,
          onChanged: (v) {
            manager.activate(widget.name, v ?? false);
            setState(() {
              active = v ?? false;
            });
          },
        ),
        Expanded(child: Text(widget.name)),
        if (isCustom) ...[
          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
          IconButton(onPressed: () {manager.deleteConfig(widget.name);}, icon: Icon(Icons.delete)),
        ],
      ],
    );
  }
}
