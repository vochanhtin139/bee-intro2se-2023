import 'package:flutter/material.dart';

class dictionaryScreen extends StatelessWidget {
  const dictionaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Dictionary Screen'),
        SearchBar()
      ],
      ),
    );
  }

}