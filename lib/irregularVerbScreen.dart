import 'package:bee/databaseHelper2.dart';
import 'package:bee/irregularVerb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
    myController.addListener(filterSuggestions);
    String emptystr = '';
    dbHelper.getSuggestionWordSearching(emptystr.toLowerCase().trim()).then((rows) {
      matchQuery = [];

      rows.forEach((row) { 
        matchQuery.add(irregularVerb.map(row));
      });
    });
  }
  
  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void filterSuggestions() async {
    dbHelper.getSuggestionWordSearching(myController.text.toLowerCase().trim()).then((rows) {
      matchQuery = [];

      rows.forEach((row) { 
        matchQuery.add(irregularVerb.map(row));
      });
    });

    setState(() {
      matchQuery = matchQuery;
    });
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
      Padding(
        padding: EdgeInsets.all(10),
        child: Row(
        // mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.search,
              // size: 24,
            ),
          ),
        
          Expanded(child: TextField(
            controller: myController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Nhập từ vựng...',
              // bder: OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: 20),
          )),
      ])),
      Expanded(
        child: irregularVerbResults(),
      )
    ]);
  }

  Widget irregularVerbResults() {
    return Material(
      child: Align(       
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
