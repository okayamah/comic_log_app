import 'package:flutter/material.dart';
import 'package:comic_log_app/model/books_model.dart';
import 'package:comic_log_app/repository/books_repository.dart';
import 'package:comic_log_app/service/book_search_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final Color color;
  final String title;
  HomePage({Key key, this.color, this.title}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 右上に表示される"debug"ラベルを消す
      debugShowCheckedModeBanner: false,
      // リスト一覧画面を表示
      // home: TodoListPage(title: 'My Todo App Home Page'),
      home: TodoListPage(),
    );
  }
}

// リスト一覧画面用Widget
class TodoListPage extends StatefulWidget {
  @override
  TodoListPageState createState() => TodoListPageState();
}

class TodoListPageState extends State<TodoListPage> {
  // Todoリストのデータ
  List<BooksModel> todoList = [];
  BooksRepository _booksRepository;

  @override
  void initState() {
    super.initState();

    // booksテーブルリポジトリの初期化.
    _booksRepository = new BooksRepository();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookSearchService>(
      create: (_) => BookSearchService(),
      // Consumerを使えば上で宣言したmodelにアクセスできるみたいです
      child: Consumer<BookSearchService>(builder: (context, model, child) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                // Column内でListView.builderを使う場合Expandedなどで描画を引き伸ばしおかないと無理みたいです。
                child: RefreshIndicator(
                  onRefresh: () async {
                    print('Loading New Data');
                    await _refresh();
                  },
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: todoList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return new AlertDialog(
                                title: Text(todoList[index].title),
                                content: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.network(
                                          todoList[index].largeImageUrl),
                                      Text(
                                        'あらすじ：',
                                        textAlign: TextAlign.left,
                                      ),
                                      SizedBox(
                                          child: Text(
                                        todoList[index].itemCaption,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(height: 1.5),
                                      )),
                                      Text(
                                        '著者：${todoList[index].author}',
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        '出版日：${todoList[index].salesDate}',
                                        textAlign: TextAlign.left,
                                      ),
                                    ]),
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
                        },
                        onLongPressStart: (details) {
                          print("LongPressed");
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Confirm'),
                                content: Text('削除しますか？'),
                                actions: <Widget>[
                                  FlatButton(
                                      child: Text("OK"),
                                      onPressed: () {
                                        setState(() {
                                          if (_booksRepository != null) {
                                            try {
                                              // DB削除
                                              _booksRepository.deleteByISBN(
                                                  todoList[index].isbn);
                                              // リスト削除
                                              todoList.remove(todoList[index]);
                                            } catch (e) {
                                              print(
                                                  "Error: delete books. [Title: ${todoList[index].title}]");
                                            }
                                          }
                                        });
                                        // リフレッシュ
                                        _refresh();
                                        Navigator.pop(context);
                                      }),
                                  FlatButton(
                                      child: Text("cancel"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }),
                                ],
                              );
                            },
                          );
                        },
                        child: Card(
                          child: ListTile(
                            leading: Image.network(
                              todoList[index].largeImageUrl,
                              width: 70,
                            ),
                            title: Text(
                                todoList[index].title), // 候補リストのListTileを生成
                            subtitle: Text(todoList[index].author),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _refresh() {
    setState(() {
      todoList.clear();
    });
    _booksRepository.getAll().then((value) {
      setState(() {
        todoList.addAll(value);
      });
    });
  }
}
