import 'package:flutter/material.dart';
import 'package:forex_aploader/bank_list.dart';
import 'package:forex_aploader/csv_to_json.dart';
import 'package:forex_aploader/fileChange.dart';

void main() {
  runApp(

  MaterialApp(
    debugShowCheckedModeBanner: false,
  //debugShowMaterialGrid: true,
  title: 'CSV File Upload',
  theme: ThemeData(
  primarySwatch: Colors.blue,
  ),
  home: Scaffold(body: BankList()),//CSVJSON(),
  )


      );
}

