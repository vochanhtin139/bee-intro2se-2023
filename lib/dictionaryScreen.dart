import 'package:bee/databaseHelper.dart';
import 'package:bee/signInScreen.dart';
import 'package:bee/signUpScreen.dart';
import 'package:bee/wordMeaning.dart';
import 'package:bee/irregularVerbScreen.dart';
import 'package:bee/settingScreen.dart';
import 'package:bee/infoScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dictionaryDetailScreen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isVisible = true;

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

  callbackValue(value) {
    setState(() {
      _isVisible = value;
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
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 255, 177, 60),
              leading: IconButton(
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                }, 
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
                // IconButton(
                //   onPressed: () {},
                //   icon: Icon(Icons.more_vert)
                // )
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'AV') {
                      DatabaseHelper.setToAV();
                    }
                    else {
                      DatabaseHelper.setToVA();
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem<String>(
                        value: 'AV',
                        child: Text('Anh - Việt'),
                      ),
                      PopupMenuItem<String>(
                        value: 'VA',
                        child: Text('Việt - Anh'),
                      ),
                    ];
                  }),
              ],
            ),
            drawer: buildDrawer(context, callback, callbackValue),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Visibility(
                    visible: _isVisible,
                    child: Container(
                      height: 320,
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
                  ),
                  Visibility(
                    visible: _isVisible,
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: matchQuery.length,
                      effect: SwapEffect(
                        dotHeight: 8,
                        dotWidth: 8
                      ),
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
                          color: Color.fromARGB(255, 0, 0, 0),
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
    margin: const EdgeInsets.all(20),
    child: Container(
      margin: EdgeInsets.all(8),
      width: 300,
      height: 300,
      color: Color.fromARGB(255, 255, 177, 60),
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
                    fontSize: 24,
                    color: Colors.black,
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
                    fontSize: 14,
                    color: Color.fromARGB(255, 0, 0, 0),
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
                    fontSize: 14,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
      margin: EdgeInsets.all(5),
      width: 300,
      
      // height: 100,
      color: Color.fromARGB(255, 255, 177, 60),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: 
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Text(
                          '${item.word}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Text(
                          '${item.pronounce}',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontStyle: FontStyle.italic
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
              ),
              SizedBox(height:10),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '${item.description}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.justify,
                ),
              )
            ],
          ),
      )
    ),
  );
}

Drawer buildDrawer(BuildContext context, Function callback, Function(bool) updateVisible) {
  return Drawer(
    // child: ListView(
    //   padding: EdgeInsets.zero,
    //   children: getDrawerItems(),
    // ),
    child: SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 200,
                  color: Colors.orange,
                  child: Center(child: Image.asset(
                'assets/logoBEE.png', // Replace 'assets/logo.png' with the actual path to your logo image
                width: 120, // Adjust the width as per your requirement
                height: 120, // Adjust the height as per your requirement
              ),),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 2.5),
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 2.5),
                  child: Text(
                    "Tài khoản", 
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
          ListTile(
            leading: Icon(Icons.login),
            title: Text('Đăng nhập'),
            onTap: () {
              //do sth
              Navigator.push(context, MaterialPageRoute(builder: (context) => signInScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text('Đăng ký'),
            onTap: () {
              //do sth
              Navigator.push(context, MaterialPageRoute(builder: (context) => signUpScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Đăng xuất'),
            onTap: () {
              //do sth
              Navigator.pop(context);
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.question_mark),
          //   title: Text('Quên mật khẩu'),
          //   onTap: () {
          //     //do sth
          //     Navigator.pop(context);
          //   },
          // ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 2.5),
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 2.5),
                  child: Text(
                    "Loại từ điển", 
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Anh - Việt'),
            onTap: () {
              DatabaseHelper.setToAV();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Việt - Anh'),
            onTap: () {
              DatabaseHelper.setToVA();
              Navigator.pop(context);
            },
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 2.5),
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 2.5),
                  child: Text(
                    "Công cụ", 
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
          ListTile(
            leading: Icon(Icons.book_online),
            title: Text('Từ điển Oxford'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MiniBrowser(
                    initialUrl: 'https://www.oxfordlearnersdictionaries.com/',
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.book_online),
            title: Text('Từ điển Cambridge'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MiniBrowser(
                    initialUrl: 'https://dictionary.cambridge.org/vi',
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.backup_table),
            title: Text('Bảng động từ bất quy tắc'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => irregularVerbScreen()));
            },
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 2.5),
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 2.5),
                  child: Text(
                    "Thông tin", 
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('Phiên bản'),
            subtitle: Text('1.0'),
          ),
          ListTile(
            leading: Icon(Icons.reviews),
            title: Text('Đánh giá'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MiniBrowser(
                    initialUrl: 'https://docs.google.com/forms/d/1Dl6pPX47e95gpmNiWqq89wRnEBUvNjnA9ReHT-7gFLw/edit',
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info_sharp),
            title: Text('Thông tin thêm'),
            onTap: () {
              //do sth
              //Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => infoScreen()));
            },
          ),

          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 2.5),
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 2.5),
                  child: Text(
                    "Tuỳ chọn", 
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Cài đặt'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen(callBackFunction: callback, callBackValue: updateVisible)));
            },
          ),
          ListTile(
            leading: Icon(Icons.close),
            title: Text('Thoát'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ),
  );
}

List<Widget> getDrawerItems() {
  return [
    ListTile(
      leading: Icon(Icons.home),
      title: Text('Home'),
      onTap: () {},
    ),
    ListTile(
      leading: Icon(Icons.settings),
      title: Text('Settings'),
      onTap: () {},
    )
  ];
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

class MiniBrowser extends StatefulWidget {
  final String initialUrl;

  MiniBrowser({required this.initialUrl});

  @override
  _MiniBrowserState createState() => _MiniBrowserState();
}

class _MiniBrowserState extends State<MiniBrowser> {
  InAppWebViewController? webViewController;
  TextEditingController urlController = TextEditingController();
  String currentUrl = '';
  String pageTitle = '';

  @override
  void initState() {
    super.initState();
    urlController.text = widget.initialUrl;
    currentUrl = widget.initialUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.close),
        ),
        title: Text(pageTitle.isEmpty ? currentUrl : pageTitle), // Display the website title or current URL
        actions: [
          // Back button
          IconButton(
            onPressed: () {
              if (webViewController != null) {
                webViewController!.goBack();
              }
            },
            icon: Icon(Icons.arrow_back),
          ),
          // Reload button
          IconButton(
            onPressed: () {
              if (webViewController != null) {
                webViewController!.reload();
              }
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: urlController,
                    decoration: InputDecoration(hintText: 'Enter URL'),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (urlController.text.isNotEmpty) {
                      if (webViewController != null) {
                        webViewController!.loadUrl(
                            urlRequest: URLRequest(url: Uri.parse(urlController.text)));
                      }
                    }
                  },
                  icon: Icon(Icons.link),
                ),
              ],
            ),
          ),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(widget.initialUrl)),
              initialOptions: InAppWebViewGroupOptions(
                android: AndroidInAppWebViewOptions(
                  useHybridComposition: true,
                ),
              ),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              // Listen to URL changes
              onLoadStart: (controller, url) {
                setState(() {
                  currentUrl = url.toString();
                });
              },
              // Listen to page title changes
              onTitleChanged: (controller, title) {
                setState(() {
                  pageTitle = title ?? '';
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

