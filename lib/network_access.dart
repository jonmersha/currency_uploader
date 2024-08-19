import 'dart:convert';
import 'package:http/http.dart' as http;



Future<List<dynamic>> fetchData() async {
  final response =
  await http.get(Uri.parse('https://service.besheger.com/forex/data/0')); // Replace with your API URL
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> rates = data['Data'];

    //Sort the entire list first by bank_id and then by currency_id
    //sourtingBank(rates);
    // Group by bank
    //Map<String, List<Map<String, dynamic>>> groupedData = grouping(rates,groupingKey);
    return rates;
  } else {
    throw Exception('Failed to load data');
  }
}




// Map<String, List<Map<String, dynamic>>> grouping(List<dynamic> rates,String key) {
//   final Map<String, List<Map<String, dynamic>>> groupedData = {};
//   for (var item in rates) {
//     final name = item[key];
//     if (groupedData.containsKey(name)) {
//       groupedData[name]!.add(item as Map<String, dynamic>);
//     } else {
//       groupedData[name] = [item as Map<String, dynamic>];
//     }
//   }
//   return groupedData;
// }

// void sourtingBank(List<dynamic> rates) {
//   rates.sort((a, b) {
//     int bankComparison = a['bank_id'].compareTo(b['bank_id']);
//     if (bankComparison != 0) return bankComparison;
//     return a['currency_id'].compareTo(b['currency_id']);
//   });
// }


Future<List<dynamic>> getBankList() async {
  final String url =
      'https://service.besheger.com/forex/data/0'; // Replace with your server URL

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final parsedJson = jsonDecode(response.body);
      //print(parsedJson);
      return parsedJson;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (error) {
   throw Exception('Error Getting bank list');
  }
}
