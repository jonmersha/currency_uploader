import 'package:flutter/material.dart';
import 'package:forex_aploader/constants.dart';
import 'package:forex_aploader/local_data.dart';
import 'package:forex_aploader/methods.dart';
import 'package:forex_aploader/network_access.dart';
import 'package:forex_aploader/one/currency_list.dart';
import 'package:forex_aploader/rate/rate_uploader.dart';

class BankList extends StatefulWidget {
  final option;

  const BankList({super.key, required this.option});

  @override
  State<BankList> createState() => _BankListState();
}

class _BankListState extends State<BankList> {
  @override
  void initState() {
    super.initState();
    if (!isBankLoaded) {
      rateBankGrouped = fetchData();
    }
  }

  void refresh() {
    setState(() {
      rateBankGrouped = fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.blueGrey.shade400,
      appBar: AppBar(
        //backgroundColor: Colors.blueGrey,
        title: Text((!widget.option) ? 'Upload File' : 'Register Rate'),
        actions: [
          IconButton(
              onPressed: () {
                refresh();
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ))
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: rateBankGrouped,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error: Check Your Connection'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }
          isBankLoaded = true;
          final bankList = snapshot.data!;
          return ListView.builder(
              itemCount: bankList.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4),
                  child: InkWell(
                    onTap: () {
                      if (widget.option) {
                        Navigation(context, CurrencyList(bank: bankList[i]));
                      } else {
                        Navigation(context, RateUploader(bank: bankList[i]));
                      }
                    },
                    child: Container(
                      height: 60,
                      decoration: containerDecoration(),
                      child: Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      '${address}/static/forex/bank/${bankList[i]['logo']}'),
                                  fit: BoxFit.fitHeight),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      '${bankList[i]['bank_name']} (${bankList[i]['short_name']})',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ),
                                  Icon(
                                    Icons.input,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  Text buttonText(String s) => Text(
        s,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.normal,
            letterSpacing: 1),
      );
}
