import 'package:flutter/material.dart';
import 'package:comic_log_app/ui/header.dart';
import 'package:comic_log_app/ui/footer.dart';
import 'package:comic_log_app/ui/home.dart';
import 'package:comic_log_app/ui/new_issues.dart';
import 'package:comic_log_app/ui/settings.dart';
import 'package:comic_log_app/ui/search.dart'; 

// ホーム画面用親Widget
class BasePage extends StatefulWidget {
  @override
  _BasePage createState() => _BasePage();
}

class _BasePage extends State {
  // タブ番号.
  int _currentIndex = 0;

  // 各タブのウィジェットを定義.
  final _pageTitles = [
    '本棚',
    '検索',
    '今月の新刊リスト',
  ];

  // 各タブのウィジェットを定義.
  final _pageWidgets = [
    HomePage(color: Colors.blue, title: '本棚'),
    SearchPage(color: Colors.green, title: '検索'),
    NewIssuesPage(color: Colors.orange, title: '今月の新刊リスト'),
  ];

  // タブ番号のコールバック関数を定義.
  callback(newIndex) {
    setState(() {
      _currentIndex = newIndex;
    });
  }

  // // ホーム画面のみ目的地設定ボタンを表示する.
  // Container _getFloatBtn() {
  //   if (_currentIndex == 0) {
  //     return Container(
  //       height: 80.0,
  //       width: 80.0,
  //       child: FittedBox(
  //           child: FloatingActionButton(
  //         onPressed: () async {
  //           showDialog(
  //               context: context,
  //               builder: (_) {
  //                 return DiceDialog();
  //               });
  //         },
  //         tooltip: "目的地を設定",
  //         child: Image(image: AssetImage('images/rolling-w.png')),
  //         // icon: Icon(Icons.add),
  //         backgroundColor: Colors.lightBlue[900],
  //       )),
  //     );
  //   } else {
  //     return null;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBarを表示し、タイトルも設定
      appBar: Header(
        title: Text(_pageTitles[_currentIndex]),
        actions: <Widget>[
          IconButton(
            tooltip: "セッティング",
            icon: Icon(Icons.settings),
            onPressed: () async {
              // "push"で新規画面に遷移
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) {
                  // 遷移先の画面として設定画面を指定
                  return SettingsPage();
                }),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pageWidgets,
      ),
      // floatingActionButton: _getFloatBtn(),
      bottomNavigationBar: Footer(callback), // Footerを追加
    );
  }
}
