/// One entry in the circular sport-filter row at the top of the Cities
/// screen (Soccer, Baseball, Football, BasketBall, MMA, ...).
class SportFilter {
  const SportFilter({
    required this.id,
    required this.label,
    required this.imageUrl,
  });

  final String id;
  final String label;
  final String imageUrl;
}
