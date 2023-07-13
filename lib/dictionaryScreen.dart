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
  DatabaseHelper dbHelper = DatabaseHelper.instance;
  List<wordMeaning> matchQuery = [];
  List<wordMeaning> matchQueryHistory = [];

  Future<void> openDatabaseAndExecuteQueries() async {
    dbHelper.getHistoryWord().then((rows) {
      matchQueryHistory = [];

      rows.forEach((row) {
        matchQueryHistory.add(wordMeaning.map(row));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: dbHelper.getRandomWord().then((rows) {
        matchQuery = [];

        rows.forEach((row) { 
          matchQuery.add(wordMeaning.map(row));
        });
      }),
      builder:(context, snapshot) {
        Widget listview;
        if (snapshot.connectionState == ConnectionState.done) {
          listview = Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              leading: IconButton(
                onPressed: () {}, 
                icon: Icon(Icons.menu),
              ),
              title: Text('Nhập từ vựng...'),
              actions: [
                IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: customSearchKeyWordDictionary(),
                    );
                  },
                  icon: Icon(Icons.search)
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_vert)
                )
              ],
            ),
            body: Column(
              children: [
                Container(
                  height: 200,
                  child: ListView.builder(
                    controller: ScrollController(),
                    scrollDirection: Axis.horizontal,
                    itemCount: matchQuery.length,
                    itemBuilder: (context, index) {
                      return buildCard(item: matchQuery[index]);
                    },
                  )
                ),
                Text('Tìm kiếm gần đây'),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: ListView.builder(
                    controller: ScrollController(),
                    scrollDirection: Axis.vertical,
                    itemCount: matchQuery.length,
                    itemBuilder: (context, index) {
                      return buildCard(item: matchQuery[index]);
                    },
                  )
                )
              ],
            )
          );
        } else if (snapshot.hasError) {
            listview = Text(snapshot.error.toString());
        } else {
          listview = Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            )
          );
        }

        return listview;
      },
    );
  }

  Widget buildCard({required wordMeaning item}) => Container(
    margin: EdgeInsets.all(10),
    width: 375,
    height: 300,
    color: Theme.of(context).colorScheme.inversePrimary,
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(children: [
        Text(
          '${item.word}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.yellow
          )
        ),
        SizedBox(height:10),
        Text(
          '${item.description}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.yellow
          )
        )
      ],
      ),
    )
  );
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
            scrollDirection: Axis.horizontal,
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

