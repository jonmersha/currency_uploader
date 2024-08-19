import 'package:flutter/material.dart';
import 'package:forex_aploader/csv_to_json.dart';
import 'package:forex_aploader/local_data.dart';
import 'package:forex_aploader/network_access.dart';
import 'package:forex_aploader/upload_csv.dart';

class BankList extends StatefulWidget {
  const BankList({super.key});

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: rateBankGrouped,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error: Check Your Connection'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        }
        isBankLoaded = true;
        final bankList = snapshot.data!;
        return Scaffold(
          body: ListView.builder(
              itemCount: bankList.length,
              itemBuilder: (context, i) {
                // print();
                return Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 4),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: ColorConverter.fromHex(
                                '${bankList[i]['color_main']}'),
                            width: 1),
                        borderRadius: BorderRadius.circular(10),
                        color: ColorConverter.fromHex(
                            '${bankList[i]['color_back']}')),
                    child: Row(
                      children: [
                        Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(
                                      'https://service.besheger.com/static/forex/bank/${bankList[i]['logo']}'),
                                  fit: BoxFit.fitHeight)),
                        ),
                        Flexible(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UploadCsv(bank:bankList[i]),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(10),
                                  height: 40,
                                 // width: 150,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: ColorConverter.fromHex(
                                          '${bankList[i]['color_main']}')//ColorConverter.fromHex('${bankList[i]['color_back']}')
                                      ),
                                  child: buttonText('Upload'),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(10),
                                height: 40,
                                width: 150,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: ColorConverter.fromHex(
                                        '${bankList[i]['color_main']}') //ColorConverter.fromHex('${bankList[i]['color_back']}')
                                    ),
                                child: buttonText('View'),
                              ),
                              Container(
                                margin: const EdgeInsets.all(10),
                                height: 40,
                                width: 150,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: ColorConverter.fromHex(
                                        '${bankList[i]['color_main']}') //ColorConverter.fromHex('${bankList[i]['color_back']}')
                                    ),
                                child: buttonText('update'),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
        );
      },
    );
  }

  Text buttonText(String s) => Text(s,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600, letterSpacing: -1),);
}
