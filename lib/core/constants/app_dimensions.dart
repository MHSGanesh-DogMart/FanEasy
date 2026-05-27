/// Layout dimensions that don't depend on screen-util scaling.
class AppDimensions {
  AppDimensions._();

  /// Design size used by `flutter_screenutil` — the values returned by
  /// the `.w` / `.h` / `.sp` extensions are scaled relative to this size.
  static const double designWidth = 390;
  static const double designHeight = 844;

  /// Pixel offset that a user needs to drag a profile card before it is
  /// considered a swipe (otherwise the card snaps back to centre).
  static const double swipeThreshold = 90;

  /// Target X offset used to animate a card off-screen when a swipe is
  /// committed. Sign indicates direction (left = nope, right = like).
  static const double swipeOffscreenX = 600;
}
