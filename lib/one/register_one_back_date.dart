import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:forex_aploader/constants.dart';
import 'package:forex_aploader/methods.dart';
import 'package:forex_aploader/one/successPage.dart';
import 'package:http/http.dart' as http;

class CurrencyRate extends StatefulWidget {
  final bank;
  final currency;

  const CurrencyRate(
      {super.key, required this.bank, required this.currency});

  @override
  _CurrencyRateState createState() => _CurrencyRateState();
}

class _CurrencyRateState extends State<CurrencyRate> {
  final _formKey = GlobalKey<FormState>();
  String serverResponse = '';
  bool isBackDate=false;


  // Controllers for form fields
  //final TextEditingController _cIdC = TextEditingController();
  final TextEditingController _bcController = TextEditingController();
  final TextEditingController _scController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _btController = TextEditingController();
  final TextEditingController _stController = TextEditingController();
  //final TextEditingController _bankIdController = TextEditingController();

  @override
  void dispose() {
    _bcController.dispose();
    _scController.dispose();
    _btController.dispose();
    _stController.dispose();
    //_bankIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   // _bankIdController.text = widget.bank['id'].toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Registrations'),
        actions: [
          ElevatedButton(onPressed: (){
            setState(() {
              isBackDate=!isBackDate;
            });
          }, child: Text(!isBackDate?'Back Date':'Today')),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Column(
                children: [
                  Container(
                    height: 100,
                    width: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(
                                '${address}/static/forex/bank/${widget.bank['logo']}'),
                            fit: BoxFit.fitHeight)),
                  ),
                  Text(
                    widget.bank['bank_name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Container(
                    height: 100,
                    width: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(
                                '${address}/static/forex/currency/${widget.currency['logo']}'),
                            fit: BoxFit.fitHeight)),
                  ),
                  Text(
                    '${widget.currency['name']} ${widget.currency['description']}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),

              if(isBackDate)
              buildTextFormField(labelText:'Date(2024-09-20)',errorMessage:'Please enter the Date',controller:_dateController),
              buildTextFormField(labelText:'Buying Cash',errorMessage:'Please enter the buying cash amount',controller:_bcController),
              buildTextFormField(labelText:'Selling Cash',errorMessage:'Please enter the selling cash amount',controller:_scController),
              buildTextFormField(labelText:'Buying Transaction',errorMessage:'Please enter the buying transaction amount',controller:_btController),
              buildTextFormField(labelText:'Selling Transaction',errorMessage:'Please enter the selling transaction amount',controller:_stController),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    serverResponse = 'Registering please wait';
                  });
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display the form data
                    final formData = isBackDate?{
                      'currency_id': widget.currency['id'],
                      'buying_cash': double.parse(_bcController.text),
                      'selling_cash': double.parse(_scController.text),
                      'buying_transaction': double.parse(_btController.text),
                      'rate_date': _dateController.text,
                      'selling_transaction': double.parse(_stController.text),
                      'bank_id': widget.bank['id'],
                    }:{
                      'currency_id': widget.currency['id'],
                      'buying_cash': double.parse(_bcController.text),
                      'selling_cash': double.parse(_scController.text),
                      'buying_transaction': double.parse(_btController.text),
                      'selling_transaction': double.parse(_stController.text),
                      'bank_id': widget.bank['id'],
                    };
                   // print('Form Data: $formData');
                    _sendDataToServer(formData);
                  }
                },
                child: const Text('Submit'),
              ),

              const SizedBox(height: 20),
              Text(serverResponse)
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildTextFormField({required String labelText, required errorMessage, required TextEditingController controller}) {
    return TextFormField(
              controller: controller,
              decoration: InputDecoration(labelText: labelText),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return errorMessage;
                }
                return null;
              },
            );
  }

  Future<void> _sendDataToServer(dynamic data) async {
    const String url = '${address}/forex/add/3';
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
          //print(serverResponse);
          Navigation(context, SuccessPage(isSuccessful: true, messages: serverResponse));
        });
      } else {
        setState(() {
          serverResponse =
              'Failed to send data. Error: ${response.reasonPhrase}';
          Navigation(context, SuccessPage(isSuccessful: false, messages: serverResponse));


        });
      }
    } catch (e) {
      setState(() {
        serverResponse = 'Error: $e';
        Navigation(context, SuccessPage(isSuccessful: false, messages: serverResponse));

      });
    }
  }
}
