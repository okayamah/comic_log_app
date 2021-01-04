// search_page.dart

// このあたりは環境に合わせたpathを指定してください
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:comic_log_app/enum/book_status.dart';
import 'package:comic_log_app/repository/books_repository.dart';
import 'package:provider/provider.dart';
import 'package:comic_log_app/service/book_search_service.dart';

// プロバイダーモデルを使ってシンプルな検索機能を実装してみる
// ignore: must_be_immutable
class SearchPage extends StatefulWidget {
  final Color color;
  final String title;

  SearchPage({Key key, this.color, this.title}) : super(key: key);

  // Function callbackAdd;
  // Function callbackCheck;
  // bool isGoogle;
  // SearchPage(this.callbackAdd, this.callbackCheck, this.isGoogle) : super();

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  BooksRepository _booksRepository;

  @override
  void initState() {
    super.initState();

    // booksテーブルリポジトリの初期化.
    _booksRepository = new BooksRepository();
  }

  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookSearchService>(
      create: (_) => BookSearchService(),
      // Consumerを使えば上で宣言したmodelにアクセスできるみたいです
      child: Consumer<BookSearchService>(builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            //  backgroundColor: Colors.black54,
            title: TextField(
              onChanged: (text) {
                // onChangedは入力されている文字が変更するたびに呼ばれます
                model.text = text;
              },
              decoration: new InputDecoration(
                prefixIcon: new IconButton(
                    icon: Icon(Icons.search),
                    color: Colors.white,
                    onPressed: () {
                      model.searchResultList.clear();
                      model.searchByTitle(false);
                    }),
                hintText: "名前で調べる...",
              ),
            ),
          ),
          body: Column(
            children: [
              Text('検索結果がリストで表示されます'),
              Expanded(
                // Column内でListView.builderを使う場合Expandedなどで描画を引き伸ばしおかないと無理みたいです。
                child: RefreshIndicator(
                  onRefresh: () async {
                    print('Loading New Data');
                    model.searchResultList.clear();
                    model.searchByTitle(false);
                  },
                  child: ListView.builder(
                    itemCount: model
                        .searchResultList.length, // ここで要素数を指定できる 検索結果の長さを渡す
                    itemBuilder: (BuildContext context, int index) {
                      if (index == model.totalCnt - 1) {
                        print('Loading Last Data: ${index}');
                        model.searchByTitle(true);
                      }
                      return _searchList(
                          context, model, index); // 上で指定した数だけ繰り返す
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

  Widget _searchList(BuildContext context, BookSearchService model, int index) {
    final alreadySaved = model.searchResultList.elementAt(index).status.index >
        BookStatus.NotSet.index;
    return ListTile(
        leading: Image.network(
          model.searchResultList.elementAt(index).largeImageUrl,
          width: 70,
        ),
        title: Text(
            model.searchResultList.elementAt(index).title), // 候補リストのListTileを生成
        subtitle: Text(model.searchResultList.elementAt(index).author),
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        onTap: () {
          setState(() {
            model.insertBook(index);
          });
        });
  }

  // void _callbackAdd(BooksModel book) {
  //   if (book != null) {
  //     // キャンセルした場合は newListText が null となるので注意
  //     setState(() {
  //       if (!todoList.any((element) => element.isbn == book.isbn)) {
  //         if (_booksRepository != null) {
  //           try {
  //             // DB登録
  //             _booksRepository.insert(book);
  //             // リスト追加
  //             todoList.add(book);
  //           } catch (e) {
  //             print("Error: insert books. [Title: ${book.title}]");
  //           }
  //         }
  //       }
  //     });
  //   }
  // }
}
