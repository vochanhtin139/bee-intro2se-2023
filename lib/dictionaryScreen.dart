import 'package:bee/databaseHelper.dart';
import 'package:bee/wordMeaning.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dictionaryDetailScreen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  // Future<void> openDatabaseAndExecuteQueries() async {
  //   dbHelper.getHistoryWord().then((rows) {
  //     matchQueryHistory = [];

  //     rows.forEach((row) {
  //       matchQueryHistory.add(wordMeaning.mapHistory(row));
  //     });
  //   });
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadSearchHistory();
  }

  void _loadSearchHistory() async {
    dbHelper.getHistoryWord().then((rows) {
      matchQueryHistory = [];

      rows.forEach((row) {
        matchQueryHistory.add(wordMeaning.mapHistory(row));
      });
    });
  }

  callback() {
    setState(() {
      dbHelper.getHistoryWord().then((rows) {
        matchQueryHistory = [];

        rows.forEach((row) {
          matchQueryHistory.add(wordMeaning.mapHistory(row));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        dbHelper.getRandomWord().then((rows) {
          matchQuery = [];

          rows.forEach((row) { 
            matchQuery.add(wordMeaning.map(row));
          });
        },),

      //   dbHelper.getHistoryWord().then((rows) {
      //   matchQueryHistory = [];

      //   rows.forEach((row) {
      //     matchQueryHistory.add(wordMeaning.mapHistory(row));
      //   });
      // })
      ], ),
      // dbHelper.getRandomWord().then((rows) {
      //   matchQuery = [];

      //   rows.forEach((row) { 
      //     matchQuery.add(wordMeaning.map(row));
      //   });
      // },),
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
                      delegate: customSearchKeyWordDictionary(callBackFunction: callback),
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
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 300,
                    child: PageView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: _pageController,
                      onPageChanged: (value) {
                        _currentPage = value;
                        print('page');
                        print(_currentPage);
                      },
                      itemCount: matchQuery.length,
                      itemBuilder: (context, index) => buildCardHorizontal(item: matchQuery[index]),
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: matchQuery.length,
                    effect: SwapEffect(
                      dotHeight: 8,
                      dotWidth: 8
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Lịch sử tìm kiếm',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color.fromARGB(255, 140, 127, 127),
                        ),
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    controller: ScrollController(),
                    scrollDirection: Axis.vertical,
                    itemCount: matchQueryHistory.length,
                    itemBuilder: (context, index) => buildCard(item: matchQueryHistory[index])
                  )
                ],
              ),
            ),
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

  Widget buildCardHorizontal({required wordMeaning item}) => Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    margin: const EdgeInsets.all(10),
    child: Container(
      margin: EdgeInsets.all(10),
      width: 300,
      height: 100,
      color: Theme.of(context).colorScheme.inversePrimary,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Image.asset(
              'assets/creative-teaching.png',
              height: 100,
              width: 100,
            ),
            SizedBox(height:20),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '${item.word}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.yellow,
                  ),
                ),
              ),
            ),
            SizedBox(height:10),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '${item.pronounce}',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    color: Color.fromARGB(255, 140, 127, 127),
                    fontStyle: FontStyle.italic
                  ),
                ),
              ),
            ),
            SizedBox(height:10),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '${item.description}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
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
  );


  Widget buildCard({required wordMeaning item}) => Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    margin: const EdgeInsets.all(10),
    child: Container(
      margin: EdgeInsets.all(10),
      width: 300,
      height: 100,
      color: Theme.of(context).colorScheme.inversePrimary,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: 
          Column(
            children: [
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        '${item.word}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        '${item.pronounce}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                  ),
                ]
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
    ),
  );
}

class customSearchKeyWordDictionary extends SearchDelegate {
  List<String> keywordDictionary = [
    'hello', 'bonjour', 'hola', 'halo', 'hi'
  ];

  DatabaseHelper dbHelper = DatabaseHelper.instance;
  List<wordMeaning> matchQuery = [];
  final Function callBackFunction;

  customSearchKeyWordDictionary({Key? key, required this.callBackFunction});

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
                  dbHelper.insertIntoHistory(matchQuery[index].word!);
                  callBackFunction();
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

