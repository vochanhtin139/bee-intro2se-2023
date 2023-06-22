import 'package:bee/wordMeaning.dart';
import 'package:flutter/material.dart';


class dictionaryDetailScreen extends StatefulWidget {
  wordMeaning wordDetail;

  dictionaryDetailScreen({super.key, required this.wordDetail});
  
  @override
  State<StatefulWidget> createState() => _dictionaryDetailScreenState();
}

class _dictionaryDetailScreenState extends State<dictionaryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('${widget.wordDetail.html}')
    );
  }

}