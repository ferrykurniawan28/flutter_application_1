import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/secondscreen.dart';
import 'package:flutter_application_1/screens/thirdscreen.dart';

final database = FirebaseDatabase.instance;
// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Crypto App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ScreenFirst(),
//     );
//   }
// }

class ScreenFirst extends StatefulWidget {
  const ScreenFirst({super.key});

  @override
  State<ScreenFirst> createState() => _ScreenFirstState();
}

class _ScreenFirstState extends State<ScreenFirst> {
  final DatabaseReference _dataref = database.ref('crypto');
  List<Map<String, dynamic>> cryptoDataList = [];
  String inputNama = '';

  @override
  void initState() {
    cryptoDataList = [];
    _dataref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      print(data);
      if (data != null && data is Map) {
        cryptoDataList.clear();
        for (var e in data.entries) {
          final Map<String, dynamic> cryptoData = {
            'cryptoName': e.key,
            'buyPrice': e.value['buyPrice'],
            'amount': e.value['amount'],
          };
          print(cryptoData);
          cryptoDataList.add(cryptoData);
          print(cryptoDataList);
          setState(() {});
        }
        // final cryptoData = Map<String, dynamic>.from(e.value);

        // cryptoDataList.add({
        //   'cryptoName': e.key,
        //   'buyPrice': e.value['buyPrice'].toString(),
        //   'amount': e.value['amount'].toString(),
        // });
      }
    });
    // final cryptoData = Map<String, dynamic>.from(event.snapshot.value);
    // cryptoDataList = cryptoData.entries
    //     .map((e) => {
    //           'cryptoName': e.key,
    //           'buyPrice': e.value['buyPrice'].toString(),
    //           'amount': e.value['amount'].toString(),
    //         })
    //     .toList();
    // setState(() {});
    // });
    super.initState();
  }

  void updateData(String cryptoName, String buyPrice, String amount) {
    setState(() {
      cryptoDataList.add({
        'cryptoName': cryptoName,
        'buyPrice': buyPrice,
        'amount': amount,
      });
      print(cryptoDataList);
    });
  }

  void removeCryptoData(int index) {
    setState(() {
      cryptoDataList.removeAt(index);
    });
  }

  void updateNama(String nama) {
    setState(() {
      inputNama = nama;
    });
  }

  void navigateToScreenThird() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenThird(updateNama: updateNama),
      ),
    );

    if (result != null) {
      setState(() {
        inputNama = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Portofolio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScreenSecond(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              navigateToScreenThird();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'Welcome, $inputNama',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TotalPortfolioWidget(cryptoDataList: cryptoDataList),
            Expanded(
              child: ListView.builder(
                itemCount: cryptoDataList.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(cryptoDataList[index]['cryptoName']!),
                    onDismissed: (direction) {
                      // removeCryptoData(index);
                      _dataref
                          .child(cryptoDataList[index]['cryptoName']!)
                          .remove();
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20.0),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                        ),
                        child: ListTile(
                          title: Text('${cryptoDataList[index]['cryptoName']}'),
                          subtitle: Text(
                              cryptoDataList[index]['buyPrice'].toString()),
                          trailing: Text((cryptoDataList[index]['buyPrice'] *
                                  cryptoDataList[index]['amount'])
                              .toStringAsFixed(2)),
                          leading:
                              Text(cryptoDataList[index]['amount'].toString()),
                          // trailing: Text((double.parse(cryptoDataList[index]
                          //                 ['buyPrice'] ??
                          //             '0') *
                          //         double.parse(cryptoDataList[index]['amount']
                          //                 .toString() ??
                          //             '0'))
                          //     .toStringAsFixed(2)),
                          // leading:
                          //     Text(cryptoDataList[index]['amount'].toString()),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class TotalPortfolioWidget extends StatelessWidget {
  final List<Map<String, dynamic>> cryptoDataList;

  const TotalPortfolioWidget({super.key, required this.cryptoDataList});

  @override
  Widget build(BuildContext context) {
    double totalPortfolio = 0;

    for (var crypto in cryptoDataList) {
      int buyPrice = crypto['buyPrice'] ?? 0;
      int amount = crypto['amount'] ?? 0;
      // double buyPrice = double.parse(crypto['buyPrice'] ?? '0');
      // double amount = double.parse(crypto['amount'] ?? '0');
      totalPortfolio += buyPrice * amount;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Total Portfolio',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text('Total: $totalPortfolio'),
      ],
    );
  }
}
