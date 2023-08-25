import 'package:flutter/material.dart';

class infoScreen extends StatefulWidget {
  const infoScreen({super.key});

  @override
  State<StatefulWidget> createState() => _infoScreenState();
}

class _infoScreenState extends State<infoScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text('Thông tin thêm',
          style: TextStyle(color: Colors.white)
        ),
      ),
      
    );
  }

}


