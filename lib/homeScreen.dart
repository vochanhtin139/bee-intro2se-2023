import 'package:bee/signInScreen.dart';
import 'package:flutter/material.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Đăng xuất"),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => signInScreen()));
          },
        ),
      ),
    );
  }

}