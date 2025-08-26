class AIPrediction {
  double predictNextCandle(List<double> data) {
    if (data.length < 3) return data.last;

    double avgChange = 0;
    for (int i = 1; i < data.length; i++) {
      avgChange += data[i] - data[i - 1];
    }
    avgChange /= (data.length - 1);

    return data.last + avgChange;
  }
}