import 'package:bee/databaseHelper.dart';
import 'package:bee/wordMeaning.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  // const SettingScreen({super.key});
  final Function callBackFunction;

  SettingScreen({Key? key, required this.callBackFunction});

  @override
  State<SettingScreen> createState() => _SettingScreenState(callBackFunction: callBackFunction);
}

class _SettingScreenState extends State<SettingScreen> {
  DatabaseHelper dbHelper = DatabaseHelper.instance;
  final Function callBackFunction;

  _SettingScreenState({Key? key, required this.callBackFunction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'Cài đặt',
          style: TextStyle(
            color: Colors.yellow,
          ),
        )
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () => showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text(
                  'Bạn có muốn xoá lịch sử?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  )
                ),
                content: const Text('Tất cả lịch sử tra từ của bạn sẽ mất!'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Không'),
                    child: const Text('Không'),
                  ),
                  TextButton(
                    onPressed: () {
                      dbHelper.DeleteHistory();
                      Navigator.pop(context, 'Có');
                      callBackFunction();
                    },
                    child: const Text('Có'),
                  ),
                ],
              )
            ),
            child:Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(10),
              child: Container(
                margin: EdgeInsets.all(10),
                width: 350,
                height: 50,
                color: Theme.of(context).colorScheme.inversePrimary,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Xoá lịch sử tìm kiếm',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15,
                              color: Colors.yellow,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ),
            ),
          ),
          SizedBox(height: 5),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(10),
            child: Container(
              margin: EdgeInsets.all(10),
              width: 350,
              height: 50,
              color: Theme.of(context).colorScheme.inversePrimary,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Chức năng Từ vựng ngẫu nhiên',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            color: Colors.yellow,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ),
          ),
        ]
      )  
    );
  }
}


