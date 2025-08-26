import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math';

// Mock candlestick data generator (replace with Quotex feed later)
class MarketProvider with ChangeNotifier {
  List<double> prices = [];
  String signal = "WAIT";

  MarketProvider() {
    Timer.periodic(Duration(seconds: 3), (_) => fetchData());
  }

  void fetchData() {
    // Simulate random candle prices
    double price = 100 + Random().nextDouble() * 10;
    prices.add(price);
    if (prices.length > 100) prices.removeAt(0);

    // Run indicators
    calculateSignal();
    notifyListeners();
  }

  void calculateSignal() {
    if (prices.length < 30) return;

    // RSI (14)
    double rsi = calculateRSI(prices, 14);

    // MACD (12, 26, 9)
    String macd = calculateMACD(prices);

    if (rsi < 30 && macd == "BULLISH") {
      signal = "BUY";
    } else if (rsi > 70 && macd == "BEARISH") {
      signal = "SELL";
    } else {
      signal = "WAIT";
    }
  }

  double calculateRSI(List<double> prices, int period) {
    if (prices.length < period + 1) return 50.0;
    double gains = 0, losses = 0;
    for (int i = prices.length - period; i < prices.length - 1; i++) {
      double change = prices[i + 1] - prices[i];
      if (change > 0) gains += change;
      else losses -= change;
    }
    double rs = gains / (losses == 0 ? 1 : losses);
    return 100 - (100 / (1 + rs));
  }

  String calculateMACD(List<double> prices) {
    double ema12 = ema(prices, 12);
    double ema26 = ema(prices, 26);
    double macdLine = ema12 - ema26;
    double signalLine = ema(prices, 9);
    return macdLine > signalLine ? "BULLISH" : "BEARISH";
  }

  double ema(List<double> prices, int period) {
    if (prices.length < period) return prices.last;
    double k = 2 / (period + 1);
    double ema = prices[prices.length - period];
    for (int i = prices.length - period + 1; i < prices.length; i++) {
      ema = prices[i] * k + ema * (1 - k);
    }
    return ema;
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => MarketProvider(),
      child: QuotexApp(),
    ),
  );
}

class QuotexApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotex Algorithm V3.1',
      theme: ThemeData.dark(),
      home: DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final market = Provider.of<MarketProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Quotex Bot V3.1"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Latest Signal:",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            market.signal,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: market.signal == "BUY"
                  ? Colors.green
                  : market.signal == "SELL"
                      ? Colors.red
                      : Colors.grey,
            ),
          ),
          SizedBox(height: 20),
          Text("Price Data: ${market.prices.takeLast(5)}"),
        ],
      ),
    );
  }
}

extension ListExtension<T> on List<T> {
  List<T> takeLast(int n) =>
      length <= n ? this : sublist(length - n, length);
}
