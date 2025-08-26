import 'package:flutter/material.dart';
import 'market_data.dart';
import 'signal_generator.dart';
import 'notifications.dart';
import 'backtest.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationsService().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quotex Algorithm Bot',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<double> marketData = [];
  String signal = "Waiting...";

  @override
  void initState() {
    super.initState();
    fetchAndAnalyze();
  }

  void fetchAndAnalyze() async {
    marketData = await MarketDataService().fetchLiveData();
    signal = SignalGenerator().generateSignal(marketData);
    NotificationsService().showNotification(signal);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quotex Algorithm Bot")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Market Data: ${marketData.toString()}"),
            SizedBox(height: 20),
            Text("Signal: $signal", style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: fetchAndAnalyze,
              child: Text("Refresh Data"),
            ),
          ],
        ),
      ),
    );
  }
}