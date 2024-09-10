import 'dart:io';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:forex_aploader/local_data.dart';
import 'package:forex_aploader/methods.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

class UploaderComponents extends StatefulWidget {
  final bank;
  final currecyList;

  const UploaderComponents(
      {super.key, required this.bank, required this.currecyList});

  @override
  State<UploaderComponents> createState() => _UploaderComponentsState();
}

class _UploaderComponentsState extends State<UploaderComponents> {
  String serverResponse = '';

  dynamic getCurrencyID(dynamic item, String curID) {
    dynamic data;

    for (int i = 0; i < widget.currecyList.length; i++) {
      if (curID.trim() == '${widget.currecyList[i]['name']}'.trim()) {
        data = {
          'currency_id': widget.currecyList[i]['id'],
          'buying_cash': item['buying_cash'],
          'selling_cash': item['selling_cash'],
          'rate_date': item['rate_date'],
          'buying_transaction': item['buying_transaction'],
          'selling_transaction': item['selling_transaction'],
          'bank_id': item['bank_id']
        };

        return data;
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
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null && result.files.isNotEmpty) {
      String stringData = await csvString(result);

      List<List<dynamic>> csvTable =
          const CsvToListConverter().convert(stringData);

      List<Map<String, dynamic>> jsonArray = [];

      List<String> customHeaders = [
        'currency_id',
        'buying_cash',
        'selling_cash',
        'buying_transaction',
        'selling_transaction',
        'rate_date',
      ];

      convertToJson(csvTable, customHeaders, jsonArray);

      setState(() {
        jsonData = jsonArray;
        // for (int i = 0; i < jsonArray.length; i++) {
        //   print(jsonData[i]['currency_id']);
        // }
      });
    }
  }

  Future<String> csvString(FilePickerResult result) async {
    String stringData = '';
    if (kIsWeb) {
      final fileBytes = result.files.first.bytes!;
      stringData = String.fromCharCodes(fileBytes);
      // print(stringData);
    } else {
      File file = File(result.files.single.path!);
      stringData = await file.readAsString();
    }

    return stringData;
  }

  void convertToJson(List<List<dynamic>> csvTable, List<String> customHeaders,
      List<Map<String, dynamic>> jsonArray) {
    for (int i = 1; i < csvTable.length; i++) {
      Map<String, dynamic> jsonObject = {};
      for (int j = 0; j < customHeaders.length; j++) {
        jsonObject[customHeaders[j]] = csvTable[i][j];
      }
      jsonObject['bank_id'] = widget.bank['id'];
      jsonArray.add(jsonObject);
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.bank['id']);
    return Column(
      children: [
        Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              image: DecorationImage(
                  image: NetworkImage(
                      'https://service.besheger.com/static/forex/bank/${widget.bank['logo']}'),
                  fit: BoxFit.fitHeight)),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: _pickFile,
          child: const Text('Chose CSV File'),
        ),
        Expanded(
          child: jsonData.isEmpty
              ? const Center(child: Text('No data loaded'))
              : ListView.builder(
                  itemCount: jsonData.length,
                  itemBuilder: (context, index) {
                    final item = jsonData[index];
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: ColorConverter.fromHex(
                              '${widget.bank['color_back']}')),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: item.keys.map((key) {
                                return Text(
                                  '$key: ${item[key]}',
                                  style: const TextStyle(fontSize: 16),
                                );
                              }).toList(),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  dynamic data =
                                      getCurrencyID(item, item['currency_id']);
                                  setState(() {
                                    jsonData.remove(item);
                                  });
                                  _sendDataToServer(data);
                                },
                                child: const Text('register'))
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
