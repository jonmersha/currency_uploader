import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class CSVJSON extends StatefulWidget {
  @override
  _CSVJSONState createState() => _CSVJSONState();
}

class _CSVJSONState extends State<CSVJSON> {
  String serverResponse = '';
  List<Map<String, dynamic>> currecy = [
    {"id": 1, "name": "USD", "description": "US Dollar", "logo": "usa.png"},
    {"id": 2, "name": "GBP", "description": "Pound Sterling", "logo": "uk.png"},
    {"id": 3, "name": "SAR", "description": "SAUDI Rial", "logo": "sar.png"},
    {"id": 4, "name": "EUR", "description": "euro", "logo": "uro.png"},
    {"id": 5, "name": "AED", "description": "UAE-Drham", "logo": "drm.png"},
    {"id": 6, "name": "CAD", "description": "Canada Dollar", "logo": "cad.png"},
    {"id": 7, "name": "CHF", "description": "Swis Frank", "logo": "chf.png"},
    {
      "id": 8,
      "name": "SEK",
      "description": "SWEDISH KRONER",
      "logo": "chf.png"
    },
    {
      "id": 9,
      "name": "NOK",
      "description": "NORWEGIAN KRONER",
      "logo": "chf.png"
    },
    {
      "id": 10,
      "name": "DKK",
      "description": "DANISH KRONER",
      "logo": "DKK.png"
    },
    {
      "id": 11,
      "name": "DJF",
      "description": "DJIBOUTI FRANC",
      "logo": "DJF.png"
    },
    {
      "id": 13,
      "name": "ZAR",
      "description": "SOUTH AFRICAN RAND",
      "logo": "zar.png"
    },
    {
      "id": 14,
      "name": "AUD",
      "description": "AUSTRALIAN DOLLAR",
      "logo": "aud.png"
    },
    {
      "id": 15,
      "name": "KES",
      "description": "KENNYAN SHILLING",
      "logo": "KES.png"
    },
    {"id": 18, "name": "CNY", "description": "CHINESE YUAN", "logo": "cyn.png"},
    {
      "id": 19,
      "name": "KWD",
      "description": "KUWAITI DINAR",
      "logo": "KWD.png"
    },
    {"id": 20, "name": "INR", "description": "Indina Rupe", "logo": "inr.png"},
    {"id": 21, "name": "JPY", "description": "japanes Yen", "logo": "jpy.png"}
  ];

  List<dynamic> _bankList = [];
  String? _selectedBank;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final String url =
        'https://service.besheger.com/forex/data/0'; // Replace with your server URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final parsedJson = jsonDecode(response.body);
        setState(() {
          _bankList = parsedJson['Data'];
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  searchingForJsonArray(dynamic item, String curID) {
    for (int i = 0; i < currecy!.length; i++) {
      if ('$curID'.trim() == '${currecy[i]['name']}'.trim()) {
        dynamic data = {
          'currency_id': currecy[i]['id'],
          'buying_cash': item['buying_cash'],
          'selling_cash': item['selling_cash'],
          'buying_transaction': item['buying_transaction'],
          'selling_transaction': item['selling_transaction'],
          'bank_id': item['bank_id']
        };
        _sendDataToServer(data);
        print(data);
        setState(() {
          jsonData.remove(item);
        });
      }
    }
  }

  List<Map<String, dynamic>> jsonData = [];

  Future<void> _sendDataToServer(dynamic data) async {
    const String url = 'https://service.besheger.com/forex/add/3';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        setState(() {
          serverResponse = 'Data sent successfully!';
          print(serverResponse);
        });
      } else {
        setState(() {
          serverResponse =
              'Failed to send data. Error: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        serverResponse = 'Error: $e';
      });
    }
  }

  Future<void> _pickFile() async {
    // Open file picker to select a CSV file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null && result.files.isNotEmpty) {
      // Read the file
      File file = File(result.files.single.path!);
      final csvString = await file.readAsString();

      print(csvString);
      print('========================================');
      // Parse CSV data
      List<List<dynamic>> csvTable =
          const CsvToListConverter().convert(csvString);

      //print(csvTable);
      // Custom Headers
      List<String> customHeaders = [
        'currency_id',
        'buying_cash',
        'selling_cash',
        'buying_transaction',
        'selling_transaction',
      ];

      // Convert to JSON
      List<Map<String, dynamic>> jsonArray = [];

      for (int i = 1; i < csvTable.length; i++) {
        Map<String, dynamic> jsonObject = {};
        for (int j = 0; j < customHeaders.length; j++) {
          jsonObject[customHeaders[j]] = csvTable[i][j];
        }
        jsonObject['bank_id'] = _selectedBank;
        jsonArray.add(jsonObject);
      }
      //print(jsonArray);

      setState(() {
        jsonData = jsonArray;
        for (int i = 0; i < jsonArray.length; i++) {
          print(jsonData[i]['currency_id']);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dailly Exchange Rate upload'),
      ),
      body: Column(
        children: [
          Center(
            child: _isLoading
                ? CircularProgressIndicator() // Show loading indicator while fetching data
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButton<String>(
                      hint: Text("Select a Bank"),
                      value: _selectedBank,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedBank = newValue;
                        });
                      },
                      items: _bankList
                          .map<DropdownMenuItem<String>>((dynamic bank) {
                        return DropdownMenuItem<String>(
                          value: '${bank['id']}',
                          child: Container(
                            color:
                                ColorConverter.fromHex('${bank['color_back']}'),
                            child: Row(
                              children: [
                                Container(
                                  height: 30,
                                  width: 30,
                                  child: Image.network(
                                    'https://service.besheger.com/static/forex/bank/${bank['logo']}',
                                  ),
                                ),
                                Text(bank['bank_name']),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
          ),
          ElevatedButton(
            onPressed: _pickFile,
            child: Text('Chose CSV File'),
          ),
          Expanded(
            child: jsonData.isEmpty
                ? Center(child: Text('No data loaded'))
                : ListView.builder(
                    itemCount: jsonData.length,
                    itemBuilder: (context, index) {
                      final item = jsonData[index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: item.keys.map((key) {
                                  return Text(
                                    '$key: ${item[key]}',
                                    style: TextStyle(fontSize: 16),
                                  );
                                }).toList(),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    searchingForJsonArray(
                                        item, item['currency_id']);
                                  },
                                  child: Text('register'))
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ColorConverter {
  // Method to convert a color string to a Color object
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
