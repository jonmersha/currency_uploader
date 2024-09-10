import 'dart:convert';
import 'package:forex_aploader/constants.dart';
import 'package:http/http.dart' as http;



Future<List<dynamic>> fetchData() async {
  final response =
  await http.get(Uri.parse('${address}/forex/data/0')); // Replace with your API URL
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> rates = data['Data'];
    return rates;
  } else {
    throw Exception('Failed to load data');
  }
}
Future<List<dynamic>> fetchCurrencyData() async {
  final response =
  await http.get(Uri.parse('${address}/forex/data/2')); // Replace with your API URL
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> rates = data['Data'];
    return rates;
  } else {
    throw Exception('Failed to load data');
  }
}


Future<List<dynamic>> getBankList() async {
  const String url =
      '${address}/forex/data/0';
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final parsedJson = jsonDecode(response.body);
      return parsedJson;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (error) {
   throw Exception('Error Getting bank list');
  }
}
