import 'package:flutter/material.dart';

mixin TestPage<T extends StatefulWidget> on State<T> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(pageTitle(), style: const TextStyle(fontSize: 30)),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: TextButton(
          onPressed: onNextPressed(),
          child: const Text("Next Page"),
        ),
      ),
    );
  }

  String pageTitle();

  VoidCallback onNextPressed() => () {};
}
