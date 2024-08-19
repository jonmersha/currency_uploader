
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';


class CSVUPLOAD extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CsvUploadScreen();
  }
}

class CsvUploadScreen extends StatefulWidget {
  @override
  _CsvUploadScreenState createState() => _CsvUploadScreenState();
}

class _CsvUploadScreenState extends State<CsvUploadScreen> {
  List<List<dynamic>> csvData = [];

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

      // Parse CSV data
      List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvString);

      setState(() {
        csvData = csvTable;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CSV File Upload'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _pickFile,
            child: Text('Upload CSV File'),
          ),
          Expanded(
            child: csvData.isEmpty
                ? Center(child: Text('No data loaded'))
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: csvData[0].map((header) {
                  return DataColumn(
                    label: Text(
                      header.toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
                rows: csvData.sublist(1).map((row) {
                  return DataRow(
                    cells: row.map((cell) {
                      return DataCell(Text(cell.toString()));
                    }).toList(),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
