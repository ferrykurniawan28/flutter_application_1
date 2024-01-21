// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final database = FirebaseDatabase.instance;

class ScreenSecond extends StatefulWidget {
  // final Function(String, String, String) updateData;
  const ScreenSecond({super.key});
  // const ScreenSecond(this.updateData, {super.key});

  @override
  State<ScreenSecond> createState() => _ScreenSecondState();
}

class _ScreenSecondState extends State<ScreenSecond> {
  final TextEditingController cryptoNameController = TextEditingController();
  final TextEditingController buyPriceController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  final DatabaseReference _dataref = database.ref('crypto');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Portofolio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: cryptoNameController,
              decoration: const InputDecoration(labelText: 'Crytocoin'),
            ),
            TextFormField(
              controller: buyPriceController,
              decoration: const InputDecoration(labelText: 'Buy Price'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
              ],
            ),
            TextFormField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    cryptoNameController.clear();
                    buyPriceController.clear();
                    amountController.clear();
                  },
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // widget.updateData(
                    //   cryptoNameController.text,
                    //   buyPriceController.text,
                    //   amountController.text,
                    // );
                    final name = cryptoNameController.text;
                    final int buyPrice = int.parse(buyPriceController.text);
                    final int amount = int.parse(amountController.text);
                    await _dataref.child(name).set({
                      'cryptoName': cryptoNameController.text,
                      'buyPrice': buyPrice,
                      'amount': amount,
                    });

                    // Return data to the first screen
                    Navigator.pop(context, 'Data saved successfully');
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
