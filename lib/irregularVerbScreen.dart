import 'package:bee/databaseHelper2.dart';
import 'package:bee/irregularVerb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_tts/flutter_tts.dart';

class irregularVerbScreen extends StatefulWidget {
  irregularVerbScreen({super.key});

  @override
  State<StatefulWidget> createState() => _irregularVerbScreenState();
}

class _irregularVerbScreenState extends State<irregularVerbScreen> {
  DatabaseHelper2 dbHelper = DatabaseHelper2.instance;
  List<irregularVerb> matchQuery = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          dbHelper.getAllWord().then((rows) {
            matchQuery = [];
            rows.forEach((row) {
              matchQuery.add(irregularVerb.map(row));
            });
          })
        ]),
        builder: (context, snapshot) {
          Widget listview;
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text('Loading....');
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else {
                listview = Scaffold(
                  appBar:  AppBar(
                    backgroundColor: Colors.orangeAccent,
                    title: Text('Bảng động từ bất quy tắc',
                      style: TextStyle(color: Colors.white)
                    ),
                  ),
                    
                  body: SingleChildScrollView(
                  child: Column(
                    children: [ 
                      Table(
                        border: TableBorder.all(color: Colors.grey),
                        children: [
                        TableRow(children: [
                          Center(child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Nguyên mẫu',
                              style:  TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                            ))
                          )),
                          Center(child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Quá khứ đơn',
                              style:  TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                            ))
                          )),
                          Center(child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Quá khứ phân từ',
                              style:  TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                            ))
                          )),
                        ])
                      ]),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        controller: ScrollController(),
                        scrollDirection: Axis.vertical,
                        itemCount: matchQuery.length,
                        itemBuilder: (context, index) {
                          Widget table;
                          table = Table(
                            border: TableBorder(
                              top: BorderSide.none, 
                              left: BorderSide.none,
                              right: BorderSide.none,
                              bottom: BorderSide(width: 1.0, color: Colors.grey),
                              horizontalInside: BorderSide.none, 
                              verticalInside: BorderSide(width: 1.0, color: Colors.grey),
                            ),
                            children: [
                              TableRow(children: [
                                  Center(child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Text('${matchQuery[index].v1}',
                                    style: TextStyle(fontSize: 17)))),
                                  Center(child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Text('${matchQuery[index].v2}',
                                    style: TextStyle(fontSize: 17)))),
                                  Center(child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Text('${matchQuery[index].v3}',
                                    style: TextStyle(fontSize: 17)))),
                              ])
                            ]);
                            return table;
                      }),
                    ]
                  ))
        
                );
              }
              return listview;
          }
        },
    
    );
  }
}