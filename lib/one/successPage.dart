import 'package:flutter/material.dart';
import 'package:forex_aploader/methods.dart';

class SuccessPage extends StatelessWidget {
  final isSuccessful;
  final String messages;

  const SuccessPage(
      {super.key, required this.isSuccessful, required this.messages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 300,
          child: Column(
            children: [
              Text(messages, style: TextStyle(fontSize: 16)),
              const SizedBox(
                height: 100,
              ),
              InkWell(
                onTap: () {
                  !isSuccessful
                      ? {Navigator.pop(context)}
                      : {Navigator.pop(context), Navigator.pop(context)};
                },
                child: Container(
                  height: 50,
                  width: 300,
                  alignment: Alignment.center,
                  decoration: containerDecoration(),
                  child: Text(
                    isSuccessful ? 'Back To Currency' : 'Try Again',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
