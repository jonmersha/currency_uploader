import 'package:flutter/material.dart';
import 'package:forex_aploader/constants.dart';
import 'package:forex_aploader/local_data.dart';
import 'package:forex_aploader/methods.dart';
import 'package:forex_aploader/network_access.dart';
import 'package:forex_aploader/one/register_one_back_date.dart';

class CurrencyList extends StatefulWidget {
  final bank;

  const CurrencyList({super.key, required this.bank});

  @override
  State<CurrencyList> createState() => _CurrencyListState();
}

class _CurrencyListState extends State<CurrencyList> {
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
        title: const Text('Currency List'),
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
          return SizedBox(
            child: ListView.builder(
                itemCount: currencyList.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 4),
                    child: InkWell(
                      onTap: () {
                        Navigation(
                          context,
                          CurrencyRate(
                            currency: currencyList[i],
                            bank: widget.bank,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        height: 50,
                        width: 400,
                        decoration: containerDecoration(),
                        child: Container(
                          width: 300,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 40,
                                width: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(1),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            '${address}/static/forex/currency/${currencyList[i]['logo']}'),
                                        fit: BoxFit.fitWidth)),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${currencyList[i]['name']}-${currencyList[i]['description']}',
                                        ),
                                      ),
                                      const Icon(
                                        Icons.input,
                                        color: Colors.white,
                                        //size: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          );
        },
      ),
    );
  }
}
