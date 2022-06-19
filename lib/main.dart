import 'package:flutter/material.dart';
import 'home.dart';
import 'mysql.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // エミュレーター右上の「debug」という帯を消す
      debugShowCheckedModeBanner: false,
      title: 'ログイン画面',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(title: 'Login Page'),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _errorMessage = "";

  var _nameController = TextEditingController();
  var _passwordController = TextEditingController();

  // 新規usernameを代入する変数
  String newUsername = "";
  // 新規passwordを代入する変数
  String newPassword = "";
  // ログインusernameを代入する変数
  String loginUsername = "";
  // ログインpasswordを代入する変数
  String loginPassword = "";

  MySQL _mysql = MySQL();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_errorMessage, style: const TextStyle(color: Colors.red)),
              // Usernameフィールド
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Username',
                ),
                onChanged: (context) {
                  newUsername = context;
                  loginUsername = context;
                },
              ),
              const SizedBox(height: 12.0),
              // Passwordフィールド
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
                onChanged: (context) {
                  newPassword = context;
                  loginPassword = context;
                },
              ),
              ButtonBar(
                children: <Widget>[
                  TextButton(
                    child: const Text('CANCEL'),
                    onPressed: () {
                      _nameController.clear();
                      _passwordController.clear();
                    },
                  ),
                  ElevatedButton(
                      child: const Text('LOGIN'),
                      onPressed: () {
                        // TODO ユーザーログイン時にデータベースに登録されているユーザー情報かどうか判定する
                        // if (_mysql.userList.contains(loginUsername) &&
                        //     _mysql.userList.contains(loginPassword)) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  //履歴ページへ値を送る
                                  builder: (context) => MyApp()));
                        }
                      // }
                      ),
                  ElevatedButton(
                      child: const Text('SIGNUP'),
                      onPressed: () {
                        _mysql.main();
                        _mysql.manipulateUserDB(newUsername, newPassword);
                        //サインアップ処理
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                //履歴ページへ値を送る
                                builder: (context) => MyApp()));
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
