import 'package:flutter/material.dart';
import 'package:comic_log_app/model/books_model.dart';
import 'package:comic_log_app/service/book_search_service.dart';

class NewIssuesPage extends StatefulWidget {
  final Color color;
  final String title;

  NewIssuesPage({Key key, this.color, this.title}) : super(key: key);
  @override
  NewIssuesPageState createState() => NewIssuesPageState();
}

class NewIssuesPageState extends State<NewIssuesPage> {
  // Todoリストのデータ
  List<BooksModel> todoList = [];

  // サービスインスタンス
  BookSearchService _model;

  @override
  void initState() {
    super.initState();
    _model = new BookSearchService();
    _model.searchInRakuten().then((value) {
      setState(() {
        todoList.addAll(_model.searchResultList);

        // サムネイルの取得
        todoList.forEach((book) {
          _model.requestOpenDB(book.isbn).then((value) {
            setState(() {
              book.largeImageUrl = value.thumbnail;
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // return ChangeNotifierProvider<SearchModel>(
    //   create: (_) => SearchModel(),
    // // Consumerを使えば上で宣言したmodelにアクセスできるみたいです
    // child: Consumer<SearchModel>(builder: (context, model, child) {
    // child: Consumer<SearchModel>(builder: (context, model, child) {
    return Scaffold(
      body: Column(
        children: [
          Text('検索結果がリストで表示されます'),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            alignment: Alignment.topCenter,
            child: new ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: const Text(
                      'データ取得',
                      style: TextStyle(fontSize: 15),
                    ),
                    color: Colors.green,
                    shape: const StadiumBorder(),
                    onPressed: () {
                      if (_model == null) _model = new BookSearchService();
                      _model.searchInRakuten().then((value) {
                        setState(() {
                          todoList.addAll(_model.searchResultList);
                        });

                        // サムネイルの取得
                        todoList.forEach((book) {
                          _model.requestOpenDB(book.isbn).then((value) {
                            setState(() {
                              book.largeImageUrl = value.thumbnail;
                            });
                          });
                        });
                      });
                    },
                  ),
                  RaisedButton(
                    child: const Text(
                      'データクリア',
                      style: TextStyle(fontSize: 15),
                    ),
                    color: Colors.green,
                    shape: const StadiumBorder(),
                    onPressed: () async {
                      setState(() {
                        todoList.clear();
                      });
                    },
                  ),
                ]),
          ),
          Expanded(
            // Column内でListView.builderを使う場合Expandedなどで描画を引き伸ばしおかないと無理みたいです。
            // child: ListView.builder(
            //   itemCount:
            //       model.searchResultList.length, // ここで要素数を指定できる 検索結果の長さを渡す
            //   itemBuilder: (BuildContext context, int index) {
            //     return _searchList(context, model, index); // 上で指定した数だけ繰り返す
            //   },
            // ),
            child: (todoList == null || todoList.length == 0)
                ? Text("Loading....")
                : ListView.builder(
                    itemCount: todoList.length, // ここで要素数を指定できる 検索結果の長さを渡す
                    itemBuilder: (BuildContext context, int index) {
                      return _bookCart(
                          context, todoList[index], index); // 上で指定した数だけ繰り返す
                    },
                  ),
          ),
        ],
      ),
    );
    //   }),
    // );
    // return Scaffold(
    //     body: ListView.builder(
    //       itemCount: todoList.length,
    //       itemBuilder: (context, index) {
    //         return GestureDetector(
    //           onTap: () {
    //             showDialog<bool>(
    //               context: context,
    //               builder: (BuildContext context) {
    //                 return new AlertDialog(
    //                   title: Text(todoList[index].title),
    //                   content: Column(
    //                       mainAxisAlignment: MainAxisAlignment.start,
    //                       children: [
    //                       Image.network(todoList[index].thumbnail),
    //                       Text(
    //                         'あらすじ：',
    //                         textAlign: TextAlign.left,
    //                       ),
    //                       SizedBox(
    //                         child: Text(todoList[index].description,
    //                         textAlign: TextAlign.center,
    //                         style: TextStyle(height: 1.5),)
    //                       ),
    //                       Text(
    //                         '著者：${todoList[index].authors}',
    //                         textAlign: TextAlign.left,
    //                       ),
    //                       Text(
    //                         '出版日：${todoList[index].publishedDate}',
    //                         textAlign: TextAlign.left,
    //                       ),
    //                     ]
    //                   ),
    //                   actions: <Widget>[
    //                     FlatButton(
    //                       onPressed: () {
    //                         Navigator.pop(context);
    //                       },
    //                       child: Text(
    //                         '戻る',
    //                         style: TextStyle(color: Colors.redAccent),
    //                       ),
    //                     ),
    //                   ],
    //                 );
    //               },
    //             );
    //           },
    //           onLongPressStart: (details) {
    //             print("LongPressed");
    //             showDialog(
    //               context: context,
    //               builder: (context) {
    //                 return AlertDialog(
    //                   title: Text('Confirm'),
    //                   content: Text('削除しますか？'),
    //                   actions: <Widget>[
    //                     FlatButton(
    //                         child: Text("OK"),
    //                         onPressed: () {
    //                           setState(() {
    //                             // リスト削除
    //                             todoList.remove(todoList[index]);
    //                           });
    //                           Navigator.pop(context);
    //                         }),
    //                     FlatButton(
    //                         child: Text("cancel"),
    //                         onPressed: () {
    //                           Navigator.pop(context);
    //                         }),
    //                   ],
    //                 );
    //               },
    //             );
    //           },
    //           child: Card(
    //             child: ListTile(
    //               leading: Image.network(
    //                 todoList[index].thumbnail,
    //                 width: 70,
    //               ),
    //               title: Text(todoList[index].title), // 候補リストのListTileを生成
    //               subtitle: Text(todoList[index].authors),
    //             ),
    //           ),
    //         );
    //       },
    //     ),);
  }

  Widget _bookCart(BuildContext context, BooksModel model, int index) {
    return ListTile(
      leading: model.largeImageUrl != null
          ? Image.network(
              model.largeImageUrl,
              width: 70,
            )
          : Image.asset("images/noimage.png"),
      title: Text(
          "${model.title} [${model.salesDate}] [${model.publisherName}]"), // 候補リストのListTileを生成
      subtitle: Text(model.author),
      onTap: () async {
        try {
          var book = await _model.requestOpenDB(model.isbn);
          showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                contentPadding: EdgeInsets.only(left: 5, right: 5),
                title: Center(child: Text(book.title)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                content: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Image.network(book.thumbnail),
                        Text(
                          'あらすじ：',
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                            child: Text(
                          book.description,
                          textAlign: TextAlign.left,
                          style: TextStyle(height: 1.5),
                        )),
                        Text(
                          '著者：${book.authors}',
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          '出版日：${book.publishedDate}',
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      '戻る',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              );
            },
          );
        } catch (e) {
          print(e.toString());
        }
      },
    );
  }

  void _callbackAdd(BooksModel newListText) {
    if (newListText != null) {
      // キャンセルした場合は newListText が null となるので注意
      setState(() {
        if (!todoList.contains((element) => element.id == newListText.id)) {
          // リスト追加
          todoList.add(newListText);
        }
      });
    }
  }

  bool _callbackCheck(String id) {
    if (id != null) {
      return todoList.any((element) => element.id == id);
    } else {
      return false;
    }
  }

  Widget _searchList(BuildContext context, BookSearchService model, int index) {
    return ListTile(
        // leading: Image.network(
        //   model.searchResultList.elementAt(index).thumbnail,
        //   width: 70,
        // ),
        title: Text(
            "${model.searchResultList.elementAt(index).title} [${model.searchResultList.elementAt(index).salesDate}] [${model.searchResultList.elementAt(index).publisherName}]"), // 候補リストのListTileを生成
        subtitle: Text(model.searchResultList.elementAt(index).author),
        onTap: () async {
          var book = await model
              .requestOpenDB(model.searchResultList.elementAt(index).isbn);
          showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                contentPadding: EdgeInsets.only(left: 5, right: 5),
                title: Center(child: Text(book.title)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                content: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Image.network(book.thumbnail),
                        Text(
                          'あらすじ：',
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                            child: Text(
                          book.description,
                          textAlign: TextAlign.left,
                          style: TextStyle(height: 1.5),
                        )),
                        Text(
                          '著者：${book.authors}',
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          '出版日：${book.publishedDate}',
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      '戻る',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              );
            },
          );
        });
  }
}
