import 'package:flutter/material.dart';

class SwitchButton extends StatefulWidget {
  void Function(bool, bool) onChange;
  Widget child;

  SwitchButton({super.key, required this.onChange, required this.child});

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  bool active = true;

  void changeState() {
    setState(() {
      active = !active;
    });
    widget.onChange(!active, active);
  }

  @override
  Widget build(BuildContext context) {
    if (active) {
      return FilledButton(onPressed: changeState, child: widget.child);
    } else {
      return OutlinedButton(onPressed: changeState, child: widget.child);
    }
  }
}
