import 'package:bee/resuableWidget.dart';
import 'package:flutter/material.dart';

import 'colorUtils.dart';
import 'homeScreen.dart';

class signUpScreen extends StatefulWidget {
  const signUpScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _usernameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Đăng kí", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(gradient: LinearGradient(colors: [
          hexStringToColor("FF5C00"),
          hexStringToColor("FD923F")
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
          child: Column(
            children: <Widget>[
              SizedBox(
                  height: 30,
              ),
              reusableTextField("Tên đăng nhập", Icons.person_outline, false, _usernameTextController), 
              SizedBox(
                height: 20,
              ),
              reusableTextField("Địa chỉ email", Icons.lock_outline, true, _emailTextController),
              SizedBox(
                height: 20,
              ),
              reusableTextField("Nhập mật khẩu", Icons.person_outline, false, _passwordTextController), 
              Padding(padding: EdgeInsets.only(top: 20),
                child:
                signInSignUpButton(context, false, () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => homeScreen()));
                })
              )
            ],
          ),
        ),
      ),
    ));

  }
}