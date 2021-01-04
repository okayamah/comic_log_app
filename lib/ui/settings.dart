import 'package:flutter/material.dart';
import 'header.dart'; 

// 設定画面用Widget
class SettingsPage extends StatelessWidget  {
  // 引数からユーザー情報を受け取る
  SettingsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBarを表示し、タイトルも設定
      appBar: Header(
        title: Text("設定画面"),
      ),
      body: Center(
        child: Text(
          '設定画面',
           style: TextStyle(fontSize: 25,),
        ),
      ),
    );
  }
}