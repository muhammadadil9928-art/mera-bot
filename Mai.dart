import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'config.dart';

void main() {
  runApp(const QuotexBotApp());
}

class QuotexBotApp extends StatelessWidget {
  const QuotexBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotex Bot V3.1',
      theme: ThemeData.dark(),
      home: const BotDashboard(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BotDashboard extends StatefulWidget {
  const BotDashboard({super.key});

  @override
  State<BotDashboard> createState() => _BotDashboardState();
}

class _BotDashboardState extends State<BotDashboard> {
  List<Map<String, dynamic>> signals = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    fetchData();
    timer = Timer.periodic(const Duration(seconds: 30), (t) => fetchData());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      // 🔗 Example API call to get candles
      final url = Uri.parse("https://api.quotex.com/v1/candles?interval=${Config.candleInterval}");
      final res = await http.get(url, headers: {
        "Authorization": "Bearer ${Config.quotexToken}"
      });

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final candles = (data["candles"] as List).map((c) => double.parse(c["close"].toString())).toList();

        final rsi = _calculateRSI(candles);
        final macd = _calculateMACD(candles);

        String signal = "WAIT";
        if (rsi < 30 && macd > 0) {
          signal = "BUY";
        } else if (rsi > 70 && macd < 0) {
          signal = "SELL";
        }

        setState(() {
          signals.insert(0, {
            "time": DateFormat("HH:mm:ss").format(DateTime.now()),
            "signal": signal,
            "rsi": rsi.toStringAsFixed(2),
            "macd": macd.toStringAsFixed(2),
          });
        });
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  double _calculateRSI(List<double> closes, {int period = 14}) {
    if (closes.length < period + 1) return 50;
    double gains = 0, losses = 0;
    for (int i = closes.length - period; i < closes.length - 1; i++) {
      final diff = closes[i + 1] - closes[i];
      if (diff >= 0) {
        gains += diff;
      } else {
        losses -= diff;
      }
    }
    if (losses == 0) return 100;
    final rs = gains / losses;
    return 100 - (100 / (1 + rs));
  }

  double _calculateMACD(List<double> closes, {int shortPeriod = 12, int longPeriod = 26}) {
    if (closes.length < longPeriod) return 0;
    double shortEMA = _ema(closes, shortPeriod);
    double longEMA = _ema(closes, longPeriod);
    return shortEMA - longEMA;
  }

  double _ema(List<double> closes, int period) {
    double k = 2 / (period + 1);
    double ema = closes.first;
    for (int i = 1; i < closes.length; i++) {
      ema = closes[i] * k + ema * (1 - k);
    }
    return ema;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quotex Bot V3.1")),
      body: ListView.builder(
        itemCount: signals.length,
        itemBuilder: (context, index) {
          final s = signals[index];
          return Card(
            color: s["signal"] == "BUY"
                ? Colors.green
                : s["signal"] == "SELL"
                    ? Colors.red
                    : Colors.grey[800],
            child: ListTile(
              title: Text("Signal: ${s["signal"]}"),
              subtitle: Text("RSI: ${s["rsi"]} | MACD: ${s["macd"]}"),
              trailing: Text(s["time"]),
            ),
          );
        },
      ),
    );
  }
}
