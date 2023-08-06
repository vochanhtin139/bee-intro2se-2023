import 'package:bee/databaseHelper2.dart';
import 'package:bee/irregularVerb.dart';
import 'package:flutter/material.dart';
class irregularVerbScreen extends StatefulWidget {
  const irregularVerbScreen({super.key});

  @override
  State<StatefulWidget> createState() => _irregularVerbScreenState();
}

class _irregularVerbScreenState extends State<irregularVerbScreen> {
  DatabaseHelper2 dbHelper = DatabaseHelper2.instance;
  List<irregularVerb> matchQuery = [];
  
  final TextEditingController myController = TextEditingController(); 
  
  @override
  void initState() {
    super.initState();
  }
  
  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text('Bảng động từ bất quy tắc',
          style: TextStyle(color: Colors.white)
        ),
      ),
      body: searchField(),
    );
  }

  Widget searchField() {
    return Column(children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Padding(
          //   padding: EdgeInsets.only(left: 20),
          //   child: Icon(
          //     Icons.search,
          //     // size: 24,
          //   ),
          // ),
        
          Expanded(child:Padding(
            padding: const EdgeInsets.all(0),
            child: RawAutocomplete(
              optionsBuilder: (TextEditingValue textEditingValue) {
                dbHelper.getSuggestionWordSearching(textEditingValue.text.toLowerCase().trim()).then((rows) {
                  matchQuery = [];

                  rows.forEach((row) { 
                    matchQuery.add(irregularVerb.map(row));
                  });
                });
                return matchQuery;
              },
              fieldViewBuilder: (BuildContext context, TextEditingController textEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted) {
                  return Padding(padding: EdgeInsets.all(16),
                    child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Nhập từ vựng...'
                    ),
                    style: TextStyle(fontSize: 20),
                    controller: textEditingController,
                    autofocus: true,
                    focusNode: focusNode,
                    onFieldSubmitted: (String value) {
                      irregularVerbResults();
                    },
                  ));
              },
              optionsViewBuilder: (BuildContext context, void Function(irregularVerb) onSelected, Iterable<irregularVerb> options) { 
                return Material(child: Align(
                  // alignment: Alignment.topLeft,
                  child:Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Table(
                        border: TableBorder.all(color: Colors.grey),
                        children: [
                        TableRow(children: [
                          Center(child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Nguyên mẫu',
                              style:  TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                            ))
                          )),
                          Center(child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Quá khứ đơn',
                              style:  TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                            ))
                          )),
                          Center(child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Quá khứ phân từ',
                              style:  TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                            ))
                          )),
                        ])
                      ])),
                      
                      Expanded(child: SingleChildScrollView(
                          controller: ScrollController(),
                          scrollDirection: Axis.vertical,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            controller: ScrollController(),
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
                                        child: Text('${matchQuery.elementAt(index).v1}',
                                        style: TextStyle(fontSize: 16)))),
                                      Center(child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: Text('${matchQuery.elementAt(index).v2}',
                                        style: TextStyle(fontSize: 16)))),
                                      Center(child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: Text('${matchQuery.elementAt(index).v3}',
                                        style: TextStyle(fontSize: 16)))),
                                  ])
                                ]);
                                // return table;
                                return InkWell(
                                  onTap: () => onSelected(options.elementAt(index)),
                                  child: table,
                                );
                            },
                          )
                        )
                      )
                    ])
                ));
              },
            )
          ),)
      ]), 
    ]);
  }

  Widget irregularVerbResults() {
    return Material(child: Align(
                  // alignment: Alignment.topLeft,
                  child:Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Table(
                        border: TableBorder.all(color: Colors.grey),
                        children: [
                        TableRow(children: [
                          Center(child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Nguyên mẫu',
                              style:  TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                            ))
                          )),
                          Center(child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Quá khứ đơn',
                              style:  TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                            ))
                          )),
                          Center(child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Quá khứ phân từ',
                              style:  TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                            ))
                          )),
                        ])
                      ])),
                      
                      Expanded(child: SingleChildScrollView(
                          controller: ScrollController(),
                          scrollDirection: Axis.vertical,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            controller: ScrollController(),
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
                                        style: TextStyle(fontSize: 16)))),
                                      Center(child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: Text('${matchQuery[index].v2}',
                                        style: TextStyle(fontSize: 16)))),
                                      Center(child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: Text('${matchQuery[index].v3}',
                                        style: TextStyle(fontSize: 16)))),
                                  ])
                                ]);
                                return table;
                            },
                          )
                        )
                      )
                    ])
                ));
  }
}


