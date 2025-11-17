abstract class TickerUtils {
  static String processSymbol(String symbol) {
    String result = symbol.split(' ').map((String s) => s.trim()).toList().join(', ');

    result = result.replaceAll(',,', ',');

    return result;
  }

  /// If is something like "AAPL-0.5, MSFT-0.5" or "^NDX-0.75, HOOD-0.25"
  /// returns true
  static bool isWeightedSymbol(String oldSymbol) {
    final List<String> parts = oldSymbol.split(',');
    for (final String part in parts) {
      final String trimmed = part.trim();
      final List<String> subParts = trimmed.split('-');
      if (subParts.length > 1) {
        final double? w = double.tryParse(subParts[1]);
        if (w != null) {
          return true;
        }
      }
    }
    return false;
  }
}
