import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'modernclass.dart';
import 'provider.dart';

enum SearchEngine { Google, Yahoo, Bing, DuckDuckGo }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => provider())
      ],
      child: Consumer<provider>(builder: (context, provider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            useMaterial3: true,
          ),

          home: checkConnection(),
        );
      }),
    );
  }
}

class checkConnection extends StatefulWidget {
  const checkConnection({super.key});

  @override
  State<checkConnection> createState() => _checkConnectionState();
}

class _checkConnectionState extends State<checkConnection> {

  @override
  void initState() {
    final providerVar = Provider.of<provider>(context, listen: false);

    super.initState();
    providerVar.initConnectivity();

    providerVar.connectivitySubscription = providerVar
        .connectivity.onConnectivityChanged
        .listen(providerVar.updateConnectionStatus);
  }

  @override
  void dispose() {
    final providerVar = Provider.of<provider>(context, listen: false);

    providerVar.connectivitySubscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final providerVar = Provider.of<provider>(context, listen: true);
    return  (providerVar.connectionStatus.name != 'none')
        ? MyHomePage()
        : checkConnection();
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final webKey = GlobalKey();
  TextEditingController searchController = TextEditingController();
  InAppWebViewController? webViewController;
  PullToRefreshController? refreshController;



  SearchEngine? Engine = SearchEngine.Google;
  int? index = 0;

  @override
  Widget build(BuildContext context) {
    final providerVar = Provider.of<provider>(context, listen: true);
    var width = MediaQuery.of(context).size.width;
    print(providerVar.connectionStatus.index);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,

        title: Text('My Browser'),
        actions: [
          PopupMenuButton(
            position: PopupMenuPosition.under,
            itemBuilder: (context) {
              return <PopupMenuItem<String>>[
                PopupMenuItem<String>(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return
                            providerVar.bookMarkList.isNotEmpty
                                ? Container(

                              child: ListView.separated(
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      onTap: () {
                                        setState(() {
                                          webViewController!.loadUrl(urlRequest: URLRequest(url: WebUri('${providerVar.bookMarkList[index].bookmark}')));
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      title: Text(
                                        "${providerVar.bookMarkList[index].bookmarktitle}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                      subtitle: Text(
                                          "${providerVar.bookMarkList[index].bookmark}"),
                                      trailing: IconButton(onPressed: (){
                                        providerVar.deleteBookMark(index);
                                        Navigator.of(context).pop();
                                      }, icon: Icon(Icons.close)),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      height: 10,
                                    );
                                  },
                                  itemCount: providerVar.bookMarkList.length),
                            )
                                : Center(
                              child: Text("No any bookmark yet...."),
                            );
                        },
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.bookmark),
                        Text('All Bookmarks'),
                      ],
                    )),
                PopupMenuItem<String>(
                  child: Row(
                    children: [
                      IconButton(onPressed: (){},
                          icon: Icon(Icons.screen_search_desktop_outlined)),
                      Text('Search Engine'),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              title: Center(child: Text('Search Engine')),
                              content: Container(
                                height: 250,
                                width: 150,
                                child: Center(
                                  child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        RadioListTile(
                                            value: SearchEngine.Google,
                                            groupValue: Engine,
                                            onChanged: (value) {
                                              setState(() {
                                                Engine = value;
                                              });
                                              Navigator.of(context).pop();
                                              webViewController!.loadUrl(
                                                  urlRequest: URLRequest(
                                                      url: WebUri(
                                                          'https://www.google.com/')));
                                            },
                                            title: Text('Google')),
                                        RadioListTile(
                                            value: SearchEngine.Yahoo,
                                            groupValue: Engine,
                                            onChanged: (value) {
                                              setState(() {
                                                Engine = value;
                                              });
                                              Navigator.of(context).pop();
                                              webViewController!.loadUrl(
                                                  urlRequest: URLRequest(
                                                      url: WebUri(
                                                          'https://in.search.yahoo.com/')));
                                            },
                                            title: Text('Yahoo')),
                                        RadioListTile(
                                            value: SearchEngine.Bing,
                                            groupValue: Engine,
                                            onChanged: (value) {
                                              setState(() {
                                                Engine = value;
                                              });
                                              Navigator.of(context).pop();
                                              webViewController!.loadUrl(
                                                  urlRequest: URLRequest(
                                                      url: WebUri(
                                                          'https://www.bing.com/')));
                                            },
                                            title: Text('Bing')),
                                        RadioListTile(
                                            value: SearchEngine.DuckDuckGo,
                                            groupValue: Engine,
                                            onChanged: (value) {
                                              setState(() {
                                                Engine = value;
                                              });
                                              webViewController!.loadUrl(
                                                  urlRequest: URLRequest(
                                                      url: WebUri(
                                                          'https://duckduckgo.com/')));
                                              Navigator.of(context).pop();
                                            },
                                            title: Text('DuckDuckGo')),
                                      ]),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ];
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              key: webKey,
              initialUrlRequest:
              URLRequest(url: WebUri('https://www.google.com')),
              onWebViewCreated: (value) {
                webViewController = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(suffixIcon: IconButton(onPressed: (){ webViewController!.loadUrl(
                  urlRequest: URLRequest(
                      url: (Engine == SearchEngine.Google)
                          ? WebUri(
                          'https://www.google.com/search?q=${searchController.text}')
                          : (Engine == SearchEngine.Yahoo)
                          ? WebUri(
                          'https://in.search.yahoo.com/search?q=${searchController.text}')
                          : (Engine == SearchEngine.Bing)
                          ? WebUri(
                          'https://www.bing.com/search?q=${searchController.text}')
                          : WebUri(
                          'https://duckduckgo.com/${searchController.text}')));
              searchController.clear();},icon: Icon(Icons.search)),hintText: 'Search or type web address',border: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.solid,width: 2))),
              controller: searchController,
              onFieldSubmitted: (value) {
                webViewController!.loadUrl(
                    urlRequest: URLRequest(
                        url: (Engine == SearchEngine.Google)
                            ? WebUri(
                            'https://www.google.com/search?q=${searchController.text}')
                            : (Engine == SearchEngine.Yahoo)
                            ? WebUri(
                            'https://in.search.yahoo.com/search?q=${searchController.text}')
                            : (Engine == SearchEngine.Bing)
                            ? WebUri(
                            'https://www.bing.com/search?q=${searchController.text}')
                            : WebUri(
                            'https://duckduckgo.com/${searchController.text}')));
                searchController.clear();
              },
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {
                    (Engine == SearchEngine.Google)?webViewController!.loadUrl(urlRequest: URLRequest(url: WebUri('https://www.google.com/')))
                        :(Engine == SearchEngine.Yahoo)?webViewController!.loadUrl(urlRequest: URLRequest(url: WebUri('https://in.search.yahoo.com/')))
                        : (Engine == SearchEngine.Bing)?webViewController!.loadUrl(urlRequest: URLRequest(url: WebUri('https://www.bing.com/')))
                        :webViewController!.loadUrl(urlRequest: URLRequest(url: WebUri('https://duckduckgo.com/')));
                  },
                  icon: Icon(Icons.home,size: 27,)),
              IconButton(
                  onPressed: () async {
                    if (webViewController != null) {
                      BookmarkModel DATA = BookmarkModel(
                          bookmarktitle: await webViewController!.getTitle(),
                          bookmark: await webViewController!.getUrl());
                      providerVar.bookMarkADD(DATA);
                    }
                  },
                  icon: Icon(Icons.bookmark_add_outlined,size: 27)),
              IconButton(
                  onPressed: () {
                    webViewController!.goBack();
                  },
                  icon: Icon(Icons.arrow_back_ios_new,size: 27)),
              IconButton(
                  onPressed: () {
                    webViewController!.reload();
                  },
                  icon: Icon(Icons.refresh,size: 27)),
              IconButton(
                  onPressed: () {
                    webViewController!.goForward();
                  },
                  icon: Icon(Icons.arrow_forward_ios,size: 27)),
            ],
          )
        ],
      ),
    );
  }
}
