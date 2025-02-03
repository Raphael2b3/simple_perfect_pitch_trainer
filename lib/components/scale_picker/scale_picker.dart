import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_perfect_pitch_trainer/components/scale_picker/scale_item.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager/scale_config.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager/scale_manager.dart';
import 'package:simple_perfect_pitch_trainer/components/scale_editor.dart';
import 'package:simple_perfect_pitch_trainer/services/ui_state_controller.dart';

class ScalePicker extends ConsumerWidget {
  const ScalePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var uiState = ref.watch(uiStateControllerProvider);

    if (uiState.scaleEditorActivated) {
      return ScaleEditor();
    }
    if (uiState.scaleListRevealed) {
      var scales = ref.watch(scaleManagerProvider);
      return Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed:
                      () => ref.read(scaleManagerProvider.notifier).selectAll(),
                  child: const Text("Select All"),
                ),
                TextButton(
                  onPressed:
                      () => ref.read(scaleManagerProvider.notifier).deselectAll(),
                  child: const Text("Deselect All"),
                ),
                TextButton(
                  onPressed: () => ref.read(uiStateControllerProvider.notifier).scaleEditorActivated = true,
                  child: const Text("Add New"),
                ),
                FilledButton(
                  onPressed: () {
                    print("test");
                    ref.read(uiStateControllerProvider.notifier).scaleListRevealed = false;
                            print(ref.read(uiStateControllerProvider).scaleEditorActivated);
                  },
                  child: const Text("Save"),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: scales.value!.length,
                itemBuilder:
                    (context, index) =>
                        ScaleItem(config: scales.value!.values.elementAt(index)),
              ),
            ),
          ],
        ),
      );
    }

    return FilledButton(
      onPressed: () => ref.read(uiStateControllerProvider.notifier).scaleListRevealed = true,
      child: Text("Select Scales"),
    );
  }
}
