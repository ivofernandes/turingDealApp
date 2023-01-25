class PortfolioAllocation {
  double endPrice;
  bool isSelected;
  int numberOfShares;

  PortfolioAllocation({
    required this.endPrice,
    this.isSelected = false,
    this.numberOfShares = 0,
  });

  @override
  String toString() =>
      'isSelected: $isSelected | shareOfPortfolio: $numberOfShares | endPrice: $endPrice';
}
