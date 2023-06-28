import 'package:bee/dictionaryScreen.dart';
import 'package:flutter/material.dart';
import 'package:bee/wordMeaning.dart';
import 'package:bee/databaseHelper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> { 
  DatabaseHelper dbHelper = DatabaseHelper.instance;
  List<wordMeaning> matchQuery = [];

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
                  onPressed: () {},
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        width: 375,
                        height: 300,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.inversePrimary
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                '${matchQuery[0].word}',
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '${matchQuery[0].description}',
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        width: 375,
                        height: 300,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.inversePrimary
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                '${matchQuery[1].word}',
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '${matchQuery[1].description}',
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        width: 375,
                        height: 300,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.inversePrimary
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                '${matchQuery[2].word}',
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '${matchQuery[2].description}',
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        width: 375,
                        height: 300,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.inversePrimary
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                '${matchQuery[3].word}',
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '${matchQuery[3].description}',
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        width: 375,
                        height: 300,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).colorScheme.inversePrimary
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                '${matchQuery[4].word}',
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '${matchQuery[4].description}',
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 20,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                FloatingActionButton(
                  child: Text('Dictionary'),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const dictionaryScreen()));
                  },
                )
              ],
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
}