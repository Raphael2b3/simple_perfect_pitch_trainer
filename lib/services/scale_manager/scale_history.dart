import 'dart:convert';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager/scale_storage.dart';

import '../number_of_extra_notes.dart';



class ScaleHistory{
  final List<List<int>> history = [];
  int historyIndex = 0; // higher value means further back in history

  List<int> getPreviousNotes() {
    var i = history.length - (historyIndex + 1);
    if (i < 0) {
      return history[0];
    }
    historyIndex++;
    return history[i];
  }


  List<int>? getNextNotes() {
    if (historyIndex <= 0) {
      return null;
    }
    var i = history.length - (historyIndex - 1);
    historyIndex--;
    return history[i];
  }

  void addNotes(List<int> notes) {
    history.add(notes);
    historyIndex = 0;
    history.add(notes);
    if (history.length > 50) {
      history.removeAt(0);
      print("Removed oldest history entry");
    }
  }
}
