import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_perfect_pitch_trainer/components/scale_item.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager/scale_config.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager/scale_manager.dart';
import 'package:simple_perfect_pitch_trainer/scale_editor.dart';

class ScalePicker extends ConsumerStatefulWidget {
  const ScalePicker({super.key});

  @override
  ConsumerState<ScalePicker> createState() => _ScalePickerState();
}

class _ScalePickerState extends ConsumerState<ScalePicker> {
  ScaleManager getManager() => ref.read(scaleManagerProvider.notifier);

  bool expanded = false;
  bool editorActive = false;

  void onSelectAll() => getManager().selectAll();

  void onDeselectAll() => getManager().deselectAll();

  void onAddNew() => setState(() {
    editorActive = true;
  });

  void onSave() {
    setState(() {
      expanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (editorActive) {
      return ScaleEditor(
        onSave: (String name, List<String> scale) {},
        onCancel: () {},
      );
    }
    if (expanded) {
      var scales = ref.watch(scaleManagerProvider);
      if (scales.isLoading || scales.isRefreshing || scales.isReloading || !scales.value!.isNotEmpty) {
        return Text("Loading...");
      }

      return Expanded(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: onSelectAll,
                  child: const Text("Select All"),
                ),
                TextButton(
                  onPressed: onDeselectAll,
                  child: const Text("Deselect All"),
                ),
                TextButton(onPressed: onAddNew, child: const Text("Add New")),
                FilledButton(
                  onPressed:
                      () => setState(() {
                        expanded = false;
                      }),
                  child: const Text("Save"),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: scales.value!.length,
                itemBuilder:
                    (context, index) => ScaleItem(
                      config:
                          scales.value!.values.elementAt(index) ??
                          ScaleConfig(
                            name: 'Fallback',
                            isActive: true,
                            isCustom: true,
                            values: [],
                          ),
                    ),
              ),
            ),
          ],
        ),
      );
    }
    return FilledButton(
      onPressed: () {
        setState(() {
          expanded = true;
        });
      },
      child: Text("Select Scales"),
    );
  }
}
