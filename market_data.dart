import 'dart:convert';
import 'package:http/http.dart' as http;

class MarketDataService {
  Future<List<double>> fetchLiveData() async {
    final url = Uri.parse('https://api.quotex.io/live');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((e) => e.toDouble()).toList();
    } else {
      throw Exception('Failed to fetch market data');
    }
  }
}