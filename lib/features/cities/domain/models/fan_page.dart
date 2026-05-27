/// A community / supporters fan page surfaced in the "Miami FanPages"
/// horizontal carousel.
class FanPage {
  const FanPage({
    required this.name,
    required this.subtitle,
    required this.coverUrl,
    required this.fansLabel,
    this.verified = false,
  });

  final String name;
  final String subtitle;
  final String coverUrl;

  /// Pre-formatted display string, e.g. `54K fans`.
  final String fansLabel;
  final bool verified;
}
