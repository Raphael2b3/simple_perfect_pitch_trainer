import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager.dart';

class ScaleEditor extends ConsumerStatefulWidget {
  final void Function(String name, List<String> scale) onSave;
  final void Function() onCancel;

  const ScaleEditor({super.key, required this.onSave, required this.onCancel});

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
  late Set<String> selection1 = {"1"};
  late Set<String> selection2 = {};
  late Set<String> selection3 = {};
  final _formKey = GlobalKey<FormState>();
  String name = "";
  @override
  Widget build(BuildContext context) {
    return Placeholder();
    return Expanded(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SegmentedButton(
              multiSelectionEnabled: true,
              selectedIcon: Icon(Icons.check),
              segments: [
                ButtonSegment<String>(
                  value: "1",
                  label: Text("1"),
                  enabled: false,
                ),
                ButtonSegment<String>(value: "b2", label: Text("b2")),
                ButtonSegment<String>(value: "2", label: Text("2")),
                ButtonSegment<String>(value: "b3", label: Text("b3")),
                ButtonSegment<String>(value: "3", label: Text("3")),
              ],
              selected: selection1,
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  selection1 = newSelection;
                });
              },
            ),
            SegmentedButton(
              emptySelectionAllowed: true,
              multiSelectionEnabled: true,
              selectedIcon: Icon(Icons.check),
              segments: [
                ButtonSegment<String>(value: "4", label: Text("4")),
                ButtonSegment<String>(value: "b5", label: Text("b5")),
                ButtonSegment<String>(value: "5", label: Text("5")),
              ],
              selected: selection2,
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  selection2 = newSelection;
                });
              },
            ),
            SegmentedButton(
              emptySelectionAllowed: true,
              multiSelectionEnabled: true,
              selectedIcon: Icon(Icons.check),
              segments: [
                ButtonSegment<String>(value: "b6", label: Text("b6")),
                ButtonSegment<String>(value: "6", label: Text("6")),
                ButtonSegment<String>(value: "7", label: Text("7")),
                ButtonSegment<String>(value: "j7", label: Text("j7")),
              ],
              selected: selection3,
              onSelectionChanged: (Set<String> newSelection) {
                setState(() {
                  selection3 = newSelection;
                });
              },
            ),
            Row(
              children: [
                TextFormField(
                  validator: (value) {
                    var manager = ref.read(scaleManagerProvider.notifier);
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    if (manager.isNameTaken(value)) {
                      return "Name already taken. Please choose another one.";
                    }
                    return null;
                  },
                  onSaved: (s) {
                    widget.onSave(s!, [...selection1, ...selection2, ...selection3]);
                  },
                  autovalidateMode: AutovalidateMode.always,
                  maxLines: 1,
                  maxLength: 30,
                  maxLengthEnforcement: MaxLengthEnforcement.none,
                  onChanged: (text) {
                    name = text;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Scale Name",
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                    }
                    widget.onSave(name, [...selection1, ...selection2, ...selection3]);
                  },
                  icon: Icon(Icons.save),
                ),
                IconButton(
                  onPressed: widget.onCancel,
                  icon: Icon(Icons.cancel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
