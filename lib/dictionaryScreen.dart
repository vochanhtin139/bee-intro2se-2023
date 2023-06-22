import 'package:bee/databaseHelper.dart';
import 'package:bee/wordMeaning.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dictionaryDetailScreen.dart';

class dictionaryScreen extends StatefulWidget {
  const dictionaryScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _homeScreenState();
  }

}

class _homeScreenState extends State<dictionaryScreen> {
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

        if (snapshot.connectionState == ConnectionState.done) {
          listView = ListView.builder(
            itemCount: matchQuery.length,
            itemBuilder: (context, index) {
              var result = matchQuery[index].word;
              return ListTile(
                title: Text(result!),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => dictionaryDetailScreen(wordDetail: matchQuery[index],)));
                },
              );
            },
          );
        }
        else if (snapshot.hasError) {
          listView = Text(snapshot.error.toString());
        }
        else {
          listView = Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return listView;
      },
    );
  }

}

