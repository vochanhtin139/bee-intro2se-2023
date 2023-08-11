import 'package:bee/colorUtils.dart';
import 'package:bee/resuableWidget.dart';
import 'package:bee/signUpScreen.dart';
import 'package:flutter/material.dart';

class signInScreen extends StatefulWidget {
  const signInScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _signInScreenState();
}

class _signInScreenState extends State<signInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(gradient: LinearGradient(colors: [
          hexStringToColor("CB2B93"),
          hexStringToColor("9546C4"),
          hexStringToColor("5E61F4")
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget("assets/creative-teaching.png"),
                SizedBox(
                  height: 30,
                ),
                reusableTextField("Enter username", Icons.person_outline, false, _emailTextController), 
                SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter password", Icons.lock_outline, true, _passwordTextController),
                SizedBox(
                  height: 20,
                ),
                signInSignUpButton(context, true, () {}),
                SizedBox(
                  height: 20,
                ),
                signUpOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, 
      children: [
        const Text("Chưa có tài khoản? ", 
                  style: TextStyle(color: Colors.white70),),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => signUpScreen()));
          },
          child: const Text("Đăng ký ngay", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        )
      ],
    );
  }
}