import 'package:flutter/material.dart';

class Header extends StatelessWidget with PreferredSizeWidget{
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  // リーディング
  final Widget leading;

  // タイトル
  final Text title;

  // アクション
  final List<Widget> actions;

  // コンストラクタ
  Header({
    this.leading,
    this.title,
    this.actions,
  });
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: this.leading,
      backgroundColor: Colors.lightBlue[900],
      title: this.title == null ? Text('コミック管理アプリ') : this.title,
      actions: this.actions,
    );
  }
}