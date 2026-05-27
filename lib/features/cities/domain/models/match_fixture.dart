/// A scheduled match displayed in the "Miami Matches" carousel.
class MatchFixture {
  const MatchFixture({
    required this.competition,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeLogoUrl,
    required this.awayLogoUrl,
    required this.dateLabel,
    required this.venue,
    required this.accent,
  });

  final String competition;
  final String homeTeam;
  final String awayTeam;
  final String homeLogoUrl;
  final String awayLogoUrl;

  /// Pre-formatted date string, e.g. `Sat, Jun 15, 2026 • 1:30 AM IST`.
  final String dateLabel;
  final String venue;

  /// Background gradient seed colour for the card.
  final int accent;
}
