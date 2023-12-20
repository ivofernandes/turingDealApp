abstract class TickerUtils {
  static String processSymbol(String symbol) {

    String result = symbol.split(' ').map((String s) => s.trim()).toList().join(', ');

    result = result.replaceAll(',,', ',');

    return result;
  }
}
