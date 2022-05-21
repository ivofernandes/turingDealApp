class JoinPricesTextAux {
  static void addTimestampForTesting(List<Map<String, dynamic>> list) {
    for (int i = 0; i < list.length; i++) {
      list[i]['datetime'] =
          DateTime.fromMillisecondsSinceEpoch(list[i]['date'] * 1000);
    }
  }

  static void validateSizeAndContinuity(List result, int expectedSize) {
    assert(result.length == expectedSize);

    for (int i = 0; i < expectedSize - 1; i++) {
      assert(result[i]['date'] > result[i + 1]['date']);
    }
  }
}
