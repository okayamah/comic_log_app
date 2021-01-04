import 'package:flutter/material.dart';
import 'package:motion_tab_bar/motiontabbar.dart';

class Footer extends StatefulWidget {
  // 親ウィジェットのコールバック関数.
  Function(int) _callback;

  // 引数からコールバック関数を受け取る
  Footer(this._callback);

  @override
  _Footer createState() => _Footer();
}

class _Footer extends State<Footer> {
  // タブ番号.
  int _selectedIndex = 0;
  final _bottomNavigationBarItems = <BottomNavigationBarItem>[];

  // アイコン情報
  static const _footerIcons = [
    Icons.home,
    Icons.search,
    Icons.book,
  ];

  // アイコン文字列
  static const _footerItemNames = [
    'ホーム',
    '検索',
    '新刊リスト',
  ];

  @override
  void initState() {
    super.initState();
    _bottomNavigationBarItems.add(_UpdateActiveState(0));
    for (var i = 1; i < _footerItemNames.length; i++) {
      _bottomNavigationBarItems.add(_UpdateDeactiveState(i));
    }
  }

  /// インデックスのアイテムをアクティベートする
  BottomNavigationBarItem _UpdateActiveState(int index) {
    return BottomNavigationBarItem(
        icon: Icon(
          _footerIcons[index],
          color: Colors.lightBlue[900],
        ),
        title: Text(
          _footerItemNames[index],
          style: TextStyle(
            color: Colors.lightBlue[900],
          ),
        ));
  }

  /// インデックスのアイテムをディアクティベートする
  BottomNavigationBarItem _UpdateDeactiveState(int index) {
    return BottomNavigationBarItem(
        icon: Icon(
          _footerIcons[index],
          color: Colors.black26,
        ),
        title: Text(
          _footerItemNames[index],
          style: TextStyle(
            color: Colors.black26,
          ),
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _bottomNavigationBarItems[_selectedIndex] =
          _UpdateDeactiveState(_selectedIndex);
      _bottomNavigationBarItems[index] = _UpdateActiveState(index);
      _selectedIndex = index;
      widget._callback(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // return BottomNavigationBar(
    //   type: BottomNavigationBarType.fixed, // これを書かないと3つまでしか表示されない
    //   items: _bottomNavigationBarItems,
    //   currentIndex: _selectedIndex,
    //   onTap: _onItemTapped,
    // );
    return MotionTabBar(
      labels: _footerItemNames,
      initialSelectedTab: 'ホーム',
      tabIconColor: Colors.green,
      tabSelectedColor: Colors.red,
      onTabItemSelected: _onItemTapped,
      icons: _footerIcons,
      textStyle: TextStyle(color: Colors.red),
    );
  }
}
