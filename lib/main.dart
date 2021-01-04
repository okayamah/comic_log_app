import 'package:flutter/material.dart';
import 'package:comic_log_app/ui/header.dart';
import 'package:comic_log_app/ui/base.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // 追加

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ComicApp());
}

class ComicApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // ユーザー情報を渡す
    return MaterialApp(
      // 追加　ここから
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ja', 'JP'),
      ],
      // 追加　ここまで
      debugShowCheckedModeBanner: false,
      title: 'コミック管理アプリ',
      theme: ThemeData(
        // テーマカラー
        primaryColor: Colors.lightBlue[900],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // ログイン画面を表示
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 登録・ログインに関する情報を表示
  String infoText = "";
  // 入力されたメールアドレス（ログイン）
  String loginUserEmail = "";
  // 入力されたパスワード（ログイン）
  String loginUserPassword = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBarを表示し、タイトルも設定
      appBar: Header(),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                constraints: BoxConstraints(minWidth: 400, maxWidth: 800),
                child: TextFormField(
                  // テキスト入力のラベルを設定
                  decoration: InputDecoration(labelText: "メールアドレス"),
                  onChanged: (String value) {
                    setState(() {
                      loginUserEmail = value;
                    });
                  },
                ),
              ),
              Container(
                constraints: BoxConstraints(minWidth: 400, maxWidth: 800),
                child: TextFormField(
                  decoration: InputDecoration(labelText: "パスワード（６文字以上）"),
                  // パスワードが見えないようにする
                  obscureText: true,
                  onChanged: (String value) {
                    setState(() {
                      loginUserPassword = value;
                    });
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                // メッセージ表示
                child: Text(infoText),
              ),
              Container(
                padding: EdgeInsets.all(5),
                height: 50,
                constraints: BoxConstraints(minWidth: 150, maxWidth: 300),
                width: double.infinity,
                // ログイン登録ボタン
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.lightBlue[900])),
                  child: const Text('ログイン'),
                  // label: Text("ログイン"),
                  // icon: Icon(Icons.login),
                  color: Colors.lightBlue[900],
                  textColor: Colors.white,
                  onPressed: () async {
                    try {
                      // ホーム画面に遷移＋ログイン画面を破棄
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return BasePage();
                        }),
                      );
                    } catch (e) {
                      // ログインに失敗した場合
                      setState(() {
                        infoText = "ログインNG：${e.message}";
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
