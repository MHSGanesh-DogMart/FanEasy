/// Immutable view-model representing a single profile shown in the Fans
/// swipe deck.
class FanProfile {
  const FanProfile({
    required this.name,
    required this.age,
    required this.country,
    required this.flag,
    required this.sports,
    required this.activities,
    required this.matchPercent,
    required this.imageUrl,
    this.verified = false,
    this.online = false,
  });

  final String name;
  final String country;
  final String flag;
  final String imageUrl;
  final int age;
  final int matchPercent;
  final List<String> sports;
  final List<String> activities;
  final bool verified;
  final bool online;
}
