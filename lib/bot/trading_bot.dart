import 'package:flutter/material.dart';
import 'dart:math';

class TradingBot extends ChangeNotifier {
  String lastSignal = "None";

  void generateSignal() {
    // Mock RSI + MACD logic
    final random = Random();
    final rsi = random.nextInt(100);
    final macd = random.nextInt(2) == 0 ? "Bullish" : "Bearish";

    if (rsi < 30 && macd == "Bullish") {
      lastSignal = "BUY 📈 (RSI=$rsi, $macd)";
    } else if (rsi > 70 && macd == "Bearish") {
      lastSignal = "SELL 📉 (RSI=$rsi, $macd)";
    } else {
      lastSignal = "HOLD ⏸ (RSI=$rsi, $macd)";
    }

    notifyListeners();
  }
}
