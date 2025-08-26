class BackTest {
  List<String> runTest(List<double> historicalData) {
    List<String> signals = [];
    for (int i = 2; i < historicalData.length; i++) {
      double prev = historicalData[i - 1];
      double curr = historicalData[i];
      if (curr > prev) {
        signals.add("BUY");
      } else if (curr < prev) {
        signals.add("SELL");
      } else {
        signals.add("HOLD");
      }
    }
    return signals;
  }
}