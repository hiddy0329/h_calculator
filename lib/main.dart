import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'home.dart';
import 'mysql.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatelessWidget {
  const LoginApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // エミュレーター右上の「debug」という帯を消す
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // フォント設定
  static const String font = 'Roboto';

  final _nameController = TextEditingController();

  final _passwordController = TextEditingController();

  final MySQL _mysql = MySQL();

  bool _databaseButtonPressed = false;

  // 新規usernameを代入する変数
  String newUsername = "";
  // 新規passwordを代入する変数
  String newPassword = "";
  // ログインusernameを代入する変数
  String loginUsername = "";
  // ログインpasswordを代入する変数
  String loginPassword = "";
  // ユーザーに関するエラーメッセージ
  String _errorMessage = "";

  String currentUserId = "";

  String currentUsername = "";

  late SharedPreferences prefs;

  Future<void> setInstance() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> setUserInfo() async {
    await prefs.setString('userId', _mysql.userList[0]);
    await prefs.setString('username', _mysql.userList[1]);
  }

  Future<void> getUserInfo() async {
    setState(() {
      currentUserId = prefs.getString('userId')!;
      currentUsername = prefs.getString('username')!;
    });
  }

  // データベースボタンの色を変えるメソッド
  void _changeDbButtonColor() {
    setState(() {
      _databaseButtonPressed = true;
    });
  }

  // エラーメッセージ取得メソッド
  void _getErrorMessage() {
    setState(() {
      if (_mysql.dbConnectExec == true) {
        _errorMessage = "Username and Password is invalid.";
      } else {
        _errorMessage = "Please connect app to the database!";
      }
    });
  }

  // テキストボックスをクリアするメソッド
  void _clearText() {
    setState(() {
      _nameController.clear();
      _passwordController.clear();
      loginUsername = "";
      loginPassword = "";
      newUsername = "";
      newPassword = "";
      _errorMessage = "";
    });
  }

  void _navigateNextPage() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return MyHomePage(userId: currentUserId, username: currentUsername);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const Offset begin = Offset(1.0, 0.0); // 右から左
          // final Offset begin = Offset(-1.0, 0.0); // 左から右
          const Offset end = Offset.zero;
          final Animatable<Offset> tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: Curves.easeInOut));
          final Animation<Offset> offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  // ログイン判定のためのメソッド
  Future _checkLogin() async {
    _navigateNextPage();
    // if (_mysql.dbConnectExec == true) {
    //   await _mysql.selectFromUserDB(loginUsername, loginPassword);
    //   // ログインできるかどうかの判定
    //   if (_mysql.userList.contains(loginUsername) &&
    //       _mysql.userList.contains(loginPassword)) {
    //     // Shared_preferenceを利用してユーザーidを端末保存
    //     await setUserInfo();
    //     await getUserInfo();
    //     _navigateNextPage();
    //     setState(() {
    //       _clearText();
    //     });
    //   } else {
    //     _getErrorMessage();
    //   }
    // } else {
    //   _getErrorMessage();
    // }
  }

  // ユーザー登録用のメソッド
  Future _checkRegistration() async {
    _navigateNextPage();
    if (_mysql.dbConnectExec == true) {
      if (newUsername != "" && newPassword != "") {
        await _mysql.insertUserDB(newUsername, newPassword);
        await _mysql.selectFromUserDB(newUsername, newPassword);
        // Shared_preferenceを利用してユーザーidを端末保存
        await setUserInfo();
        await getUserInfo();
        _navigateNextPage();
        setState(() {
          _clearText();
        });
      } else {
        _getErrorMessage();
      }
    } else {
      _getErrorMessage();
    }
  }

  @override
  void initState() {
    super.initState();
    setInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[100],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              "Login Page",
              style: TextStyle(fontFamily: font),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                elevation: 0,
              ),
              onPressed: () {
                _changeDbButtonColor();
                _mysql.dbConnect();
              },
              child: Icon(
                FontAwesomeIcons.database,
                color: (_databaseButtonPressed)
                    ? Colors.pinkAccent.shade200
                    : Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                (_databaseButtonPressed) ? "Database On" : "Database Off",
                style: const TextStyle(fontFamily: font),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_errorMessage,
                  style: const TextStyle(fontSize: 20.0, color: Colors.red)),
              // Usernameフィールド
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Username',
                  hintStyle: TextStyle(fontFamily: font),
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
                decoration: const InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(fontFamily: font),
                ),
                onChanged: (context) {
                  newPassword = context;
                  loginPassword = context;
                },
              ),
              ButtonBar(
                children: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(primary: Colors.blueGrey[900]),
                    onPressed: () {
                      _clearText();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontFamily: font),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide.none,
                      primary: Colors.blueGrey[900],
                    ),
                    onPressed: () {
                      // _mysql.dbConnect();
                      _checkLogin();
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(fontFamily: font),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide.none,
                      primary: Colors.blueGrey[900],
                    ),
                    onPressed: () {
                      _checkRegistration();
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontFamily: font),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
