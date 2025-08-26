import 'ai_prediction.dart';

class SignalGenerator {
  String generateSignal(List<double> data) {
    if (data.isEmpty) return "No data";

    double prediction = AIPrediction().predictNextCandle(data);

    if (prediction > data.last) {
      return "BUY";
    } else if (prediction < data.last) {
      return "SELL";
    } else {
      return "HOLD";
    }
  }
}