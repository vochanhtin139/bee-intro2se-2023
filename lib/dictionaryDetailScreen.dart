import 'package:bee/databaseHelper.dart';
import 'package:bee/wordMeaning.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:webview_flutter/webview_flutter.dart';

class dictionaryDetailScreen extends StatefulWidget {
  wordMeaning wordDetail;

  dictionaryDetailScreen({super.key, required this.wordDetail});
  
  @override
  State<StatefulWidget> createState() => _dictionaryDetailScreenState();
}

class _dictionaryDetailScreenState extends State<dictionaryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${widget.wordDetail.word}',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.orangeAccent,
          actions: [
            IconButton(
              onPressed:() {},
              icon: Icon(
                Icons.volume_up,
                color: Colors.white,
              ),
            )
          ],
          bottom: TabBar(
            indicatorColor: const Color.fromARGB(255, 9, 138, 13),
            tabs: [
              Tab(text: 'TỪ ĐIỂN OFFLINE'),
              Tab(text: 'TỪ ĐIỂN OXFORD'),
              Tab(text: 'TỪ ĐIỂN CAMBRIDGE'),
              Tab(text: 'HÌNH ẢNH'),
            ],
          ),
          elevation: 20,
          titleSpacing: 20,
        ),
        body: TabBarView(
          children: [
            OfflineWeb(wordDetail: widget.wordDetail,),
            OxfordWeb(wordDetail: widget.wordDetail),
            CambridgeWeb(wordDetail: widget.wordDetail),
            googleImageWebView(wordDetail: widget.wordDetail),
          ],
        ),
      ),
    );
  }

  Widget buildPage(String text) => Center(
    child: Text(
      text,
      style: TextStyle(fontSize: 28),
    ),
  );
}

class OxfordWeb extends StatefulWidget {
  wordMeaning wordDetail;

  OxfordWeb({super.key, required this.wordDetail});

  @override
  State<OxfordWeb> createState() => _OxfordWebState();
}

class _OxfordWebState extends State<OxfordWeb> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://www.oxfordlearnersdictionaries.com/definition/english/' + '${widget.wordDetail.word}'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(
        controller: controller,
      ),
    );;
  }
}

class CambridgeWeb extends StatefulWidget {
  wordMeaning wordDetail;

  CambridgeWeb({super.key, required this.wordDetail});

  @override
  State<CambridgeWeb> createState() => _CambridgeWebState();
}

class _CambridgeWebState extends State<CambridgeWeb> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://dictionary.cambridge.org/dictionary/english/' + '${widget.wordDetail.word}'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}


class OfflineWeb extends StatefulWidget {
  wordMeaning wordDetail;

  OfflineWeb({super.key, required this.wordDetail});

  @override
  State<OfflineWeb> createState() => _OfflineWebState();
}

class _OfflineWebState extends State<OfflineWeb> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController();
    controller.loadHtmlString('${widget.wordDetail.html}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: WebViewWidget(controller: controller),
      body: SingleChildScrollView(child: Html(data: '${widget.wordDetail.html}',))
    );
  }
}

class googleImageWebView extends StatefulWidget {
  wordMeaning wordDetail;

  googleImageWebView({super.key, required this.wordDetail});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _googleImageWebviewState();
  }
}

class _googleImageWebviewState extends State<googleImageWebView> {
  late final WebViewController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://www.google.com/search?tbm=isch&q=' + '${widget.wordDetail.word}'),
      );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
  
}