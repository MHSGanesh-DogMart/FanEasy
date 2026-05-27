import 'package:flutter/foundation.dart';

import '../../data/mock_fan_profiles.dart';
import '../../domain/models/fan_profile.dart';

/// Which segment (Single / Group) is active inside the Fans tab.
enum FansSegment { single, group }

/// Holds Fans-tab state: profile deck, active segment, and whether the
/// action panel is expanded to show the full 5-button layout.
///
/// All non-animation state lives here so the screen widget can stay
/// thin; transient drag offsets remain in the screen because they need
/// `TickerProviderStateMixin`.
class FansProvider extends ChangeNotifier {
  FansProvider() : _deck = List<FanProfile>.from(kMockFanProfiles);

  List<FanProfile> _deck;
  FansSegment _segment = FansSegment.single;
  bool _expanded = false;

  List<FanProfile> get deck => List.unmodifiable(_deck);
  FansSegment get segment => _segment;
  bool get expanded => _expanded;
  bool get isEmpty => _deck.isEmpty;

  /// Pop the top card after a committed swipe.
  void popTop() {
    if (_deck.isEmpty) return;
    _deck = _deck.sublist(1);
    _expanded = false;
    notifyListeners();
  }

  /// Push the previously discarded card back onto the deck.
  /// No-op when the deck is already full.
  void replayLast() {
    if (_deck.length >= kMockFanProfiles.length) return;
    final restored = kMockFanProfiles[kMockFanProfiles.length - _deck.length - 1];
    _deck = [restored, ..._deck];
    notifyListeners();
  }

  /// Reset the deck to its original state.
  void reset() {
    _deck = List<FanProfile>.from(kMockFanProfiles);
    _expanded = false;
    notifyListeners();
  }

  void setSegment(FansSegment value) {
    if (_segment == value) return;
    _segment = value;
    notifyListeners();
  }

  void toggleExpanded() {
    _expanded = !_expanded;
    notifyListeners();
  }

  void collapse() {
    if (!_expanded) return;
    _expanded = false;
    notifyListeners();
  }
}
