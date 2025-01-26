import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ui_state_controller.g.dart';

class UIState{
  bool solutionRevealed = false;
  UIState({required this.solutionRevealed});
}
// A shared state that can be accessed by multiple widgets at the same time.
@riverpod
class UIStateController extends _$UIStateController {

  @override
  UIState build() {
    return UIState(solutionRevealed: false);
  }

  void updateUIState(UIState newState){
    state = newState;
    ref.notifyListeners();
  }
}
