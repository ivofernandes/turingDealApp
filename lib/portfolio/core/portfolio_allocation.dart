class PortfolioAllocation {
  double endPrice;
  bool isSelected;
  int numberOfShares;
  double percentageOfPortfolio;

  PortfolioAllocation({
    required this.endPrice,
    this.isSelected = false,
    this.numberOfShares = 0,
    this.percentageOfPortfolio = 0,
  });

  @override
  String toString() =>
      'isSelected: $isSelected | numberOfShares: $numberOfShares | percentageOfPortfolio: $percentageOfPortfolio | endPrice: $endPrice';
}
