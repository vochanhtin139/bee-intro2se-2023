import 'package:bee/databaseHelper.dart';
import 'package:bee/wordMeaning.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqlite_api.dart';

class dictionaryScreen extends StatefulWidget {
  const dictionaryScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _homeScreenState();
  }

}

class _homeScreenState extends State<dictionaryScreen> {
  // DatabaseHelper dbHelper = DatabaseHelper.instance;
  // List<wordMeaning> wordMeaningList = [];

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();

  //   dbHelper.getSuggestionWordSearching('he').then((rows) {
  //     setState(() {
  //       rows.forEach((row) { 
  //         wordMeaningList.add(wordMeaning.map(row));
  //       });

  //       print('loading done!');
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Personal Journal'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: customSearchKeyWordDictionary(),
              );
            },
            icon: const Icon(Icons.search)
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text('Hi'),
          ),
        ],
      ),
    );
  }
}

class customSearchKeyWordDictionary extends SearchDelegate {
  List<String> keywordDictionary = [
    'hello', 'bonjour', 'hola', 'halo', 'hi'
  ];

  DatabaseHelper dbHelper = DatabaseHelper.instance;
  List<wordMeaning> matchQuery = [];

  // Future<List> getWordSuggestion(String query) async {
  //   matchQuery = [];

  //   return dbHelper.getSuggestionWordSearching(query.toLowerCase().trim()).then((rows) {
  //     rows.forEach((row) { 
  //       matchQuery.add(wordMeaning.map(row));
  //     });

  //     print('loading done!');
  //   });
  // }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        }, 
        icon: const Icon(Icons.clear)
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // List<String> matchQuery = [];

    // for (var item in keywordDictionary) {
    //   if (item.toLowerCase().trim().contains(query.toLowerCase().trim())) {
    //     matchQuery.add(item);
    //   }
    // }

    // return ListView.builder(
    //   itemCount: matchQuery.length,
    //   itemBuilder: (context, index) {
    //     var result = matchQuery[index];
    //     return ListTile(title: Text(result));
    //   },
    // );

    //---------
    
    // List<wordMeaning> matchQuery = [];

    // dbHelper.getSuggestionWordSearching(query.toLowerCase().trim()).then((rows) {
    //     rows.forEach((row) { 
    //       matchQuery.add(wordMeaning.map(row));
    //     });

    //     print('loading done!');
    //   });

    // for (var item in keywordDictionary) {
    //   if (item.toLowerCase().trim().contains(query.toLowerCase().trim())) {
    //     matchQuery.add(item);
    //   }
    // }

    // for (var item in matchQuery) {
    //   if (item.word!.trim().contains(query.toLowerCase().trim())) {
    //     matchQuery.add(item);
    //   }
    // }

    // return ListView.builder(
    //   itemCount: matchQuery.length,
    //   itemBuilder: (context, index) {
    //     var result = matchQuery[index];
    //     return ListTile(title: Text(result));
    //   },
    // );

    // return ListView.builder(
    //   itemCount: matchQuery.length,
    //   itemBuilder: (context, index) {
    //     var result = matchQuery[index].word;
    //     return ListTile(title: Text(result!));
    //   },
    // );

    return FutureBuilder(
      future: dbHelper.getSuggestionWordSearching(query.toLowerCase().trim()).then((rows) {
        matchQuery = [];

        rows.forEach((row) { 
          matchQuery.add(wordMeaning.map(row));
        });

        print('loading done!');
      }),
      builder: (context, snapshot) {
        Widget listView;

        if (snapshot.hasData) {
          listView = ListView.builder(
            itemCount: matchQuery.length,
            itemBuilder: (context, index) {
              var result = matchQuery[index].word;
              return ListTile(title: Text(result!),);
            },
          );
        }
        else {
          listView = SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(),
          );
        }

        return listView;
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // List<wordMeaning> matchQuery = [];

    // dbHelper.getSuggestionWordSearching(query.toLowerCase().trim()).then((rows) {
    //     rows.forEach((row) { 
    //       matchQuery.add(wordMeaning.map(row));
    //     });

    //     print('loading done!');
    //   });

    // for (var item in keywordDictionary) {
    //   if (item.toLowerCase().trim().contains(query.toLowerCase().trim())) {
    //     matchQuery.add(item);
    //   }
    // }

    // for (var item in matchQuery) {
    //   if (item.word!.trim().contains(query.toLowerCase().trim())) {
    //     matchQuery.add(item);
    //   }
    // }

    // return ListView.builder(
    //   itemCount: matchQuery.length,
    //   itemBuilder: (context, index) {
    //     var result = matchQuery[index];
    //     return ListTile(title: Text(result));
    //   },
    // );

    // return ListView.builder(
    //   itemCount: matchQuery.length,
    //   itemBuilder: (context, index) {
    //     var result = matchQuery[index].word;
    //     return ListTile(title: Text(result!));
    //   },
    // );
    return FutureBuilder(
      future: dbHelper.getSuggestionWordSearching(query.toLowerCase().trim()).then((rows) {
        matchQuery = [];

        rows.forEach((row) { 
          matchQuery.add(wordMeaning.map(row));
        });

        print('loading done!');
      }),
      builder: (context, snapshot) {
        Widget listView;

        Fluttertoast.showToast(msg: snapshot.data.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );

        if (snapshot.connectionState == ConnectionState.done) {
          listView = ListView.builder(
            itemCount: matchQuery.length,
            itemBuilder: (context, index) {
              var result = matchQuery[index].word;
              return ListTile(title: Text(result!),);
            },
          );
        }
        else if (snapshot.hasError) {
          listView = Text(snapshot.error.toString());
        }
        else {
          listView = SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(),
          );
        }

        return listView;
      },
    );
  }

}