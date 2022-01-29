class VariationCount {
  final String intervalDescription;
  final int count;

  VariationCount(this.intervalDescription, this.count);

  @override
  String toString() {
    return '$intervalDescription = $count';
  }
}
