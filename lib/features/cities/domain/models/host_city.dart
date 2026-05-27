/// A city hosting matches — the central card in the Cities carousel.
class HostCity {
  const HostCity({
    required this.name,
    required this.flag,
    required this.coverUrl,
    required this.fansVisiting,
    required this.fanPages,
    required this.matches,
  });

  final String name;
  final String flag;
  final String coverUrl;

  /// Display string, e.g. `3.4K`.
  final String fansVisiting;
  final int fanPages;
  final int matches;
}
