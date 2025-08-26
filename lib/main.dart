import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'bot/trading_bot.dart';

void main() {
  runApp(const QuotexApp());
}

class QuotexApp extends StatelessWidget {
  const QuotexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TradingBot(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quotex Bot V3.1',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bot = Provider.of<TradingBot>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Quotex Bot V3.1")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("📊 RSI + MACD Bot Active"),
            const SizedBox(height: 20),
            Text("Last Signal: ${bot.lastSignal}"),
            ElevatedButton(
              onPressed: () => bot.generateSignal(),
              child: const Text("Generate Signal"),
            ),
          ],
        ),
      ),
    );
  }
}
