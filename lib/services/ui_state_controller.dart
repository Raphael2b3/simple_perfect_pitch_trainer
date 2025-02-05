import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_perfect_pitch_trainer/services/scale_manager/scale_config.dart';

part 'ui_state_controller.g.dart';

class UIState {
  bool solutionRevealed = false;
  bool scaleListRevealed = false;
  bool scaleEditorActivated = false;
  bool solutionExpanded = true;
  ScaleConfig? scaleToEdit;
}

// A shared state that can be accessed by multiple widgets at the same time.
@riverpod
class UiStateController extends _$UiStateController {
  set solutionRevealed(bool value) {
    state.solutionRevealed = value;
    if (value) {
      state.scaleListRevealed = false;
      state.scaleEditorActivated = false;
    }
    ref.notifyListeners();
  }

  set scaleToEdit(ScaleConfig? value) {
    state.scaleToEdit = value;
  }

  set scaleListRevealed(bool value) {
    state.scaleListRevealed = value;
    if (value) {
      state.solutionRevealed = false;
      state.scaleEditorActivated = false;
      state.solutionExpanded = false;
    } else {
      state.solutionExpanded = true;
    }
    ref.notifyListeners();
  }

  set scaleEditorActivated(bool value) {
    state.scaleEditorActivated = value;
    if (value) {
      state.solutionExpanded = false;
    }
    ref.notifyListeners();
  }

  set solutionExpanded(bool value) {
    state.solutionExpanded = value;
    if (value) {
      state.solutionRevealed = true;
      state.scaleListRevealed = false;
      state.scaleEditorActivated = false;
    }
    ref.notifyListeners();
  }

  @override
  UIState build() {
    return UIState();
  }
}
