/// Centralised asset path constants.
///
/// Reference asset files through these constants instead of raw string
/// literals so that asset renames stay localised to one place.
class AppAssets {
  AppAssets._();

  // ── Top-level icons ─────────────────────────────────────────────────
  static const String filterIcon = 'Assets/filter.png';
  static const String heartIcon = 'Assets/heart.png';

  // ── Bottom navigation icons ─────────────────────────────────────────
  static const String navFans = 'Assets/fans.png';
  static const String navCities = 'Assets/cities.png';
  // `navFanPages` reuses the existing explore.png until a dedicated icon
  // ships — visually similar (compass / globe motif).
  static const String navFanPages = 'Assets/explore.png';
  static const String navLikes = 'Assets/heart.png';
  static const String navChats = 'Assets/chats.png';

  // ── User card icons ─────────────────────────────────────────────────
  static const String userCardBolt = 'Assets/User_Card/Tab 8.png';
  static const String userCardStar = 'Assets/User_Card/star_icon.png';
  static const String userCardVerified = 'Assets/User_Card/verified.png';
  static const String userCardRefresh = 'Assets/User_Card/refresh.png';
  static const String userCardLike = 'Assets/User_Card/like.png';
  static const String userCardSendMessage = 'Assets/User_Card/send_message.png';
  // ── Empty state illustrations ────────────────────────────────────────
  static const String chatEmptyState = 'Assets/chat_empty_state.png';
}
