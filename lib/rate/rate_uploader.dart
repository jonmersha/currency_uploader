import 'package:flutter/material.dart';
import 'package:forex_aploader/local_data.dart';
import 'package:forex_aploader/network_access.dart';
import 'package:forex_aploader/rate/uploader_components.dart';

class RateUploader extends StatefulWidget {
  final bank;

  const RateUploader({super.key, required this.bank});

  @override
  State<RateUploader> createState() => _RateUploaderState();
}

class _RateUploaderState extends State<RateUploader> {
  @override
  void initState() {
    super.initState();
    if (!isCurrencyLoaded) {
      rateCurrencyGrouped = fetchCurrencyData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Upload'),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    rateCurrencyGrouped = fetchCurrencyData();
                  });
                },
                icon: const Icon(Icons.refresh))
          ],
        ),
        body: FutureBuilder<List<dynamic>>(
          future: rateCurrencyGrouped,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error: Check Your Connection'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data available'));
            }
            isCurrencyLoaded = true;
            final currencyList = snapshot.data!;
            return UploaderComponents(
              bank: widget.bank,
              currecyList: currencyList,
            );
          },
        ));
  }
}
