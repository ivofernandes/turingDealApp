/// Class to create a ticker history with different arrays for different columns
/// This should improve performance
class TickerHistory{
  List<DateTime> dates = [];

  List<double> open = [];
  List<double> close = [];

  List<double> high = [];
  List<double> low = [];

  Map<String, List<double>> indicators = {};
}