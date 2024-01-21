import 'package:flutter/material.dart';

class ScreenThird extends StatefulWidget {
  final Function(String) updateNama;

  const ScreenThird({super.key, required this.updateNama});

  @override
  State<ScreenThird> createState() => _ScreenThirdState();
}

class _ScreenThirdState extends State<ScreenThird> {
  final TextEditingController nameController = TextEditingController();

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
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Input Nama'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.updateNama(nameController.text);
                Navigator.pop(context, nameController.text);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
