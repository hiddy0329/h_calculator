import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../logic/hashing.dart';
import 'home.dart';
import '../logic/mysql.dart';
import '../logic/shared_pref.dart';
import '../components/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // 入力値追跡用コントローラー(username)
  final TextEditingController _nameController = TextEditingController();

  // 入力値追跡用コントローラー(password)
  final TextEditingController _passwordController = TextEditingController();

  // MySQLクラスのインスタンス
  final MySQL _mysql = MySQL();

  // dbボタンが押されたかどうか判定するbool値
  bool _databaseButtonPressed = false;

  // 暗号化したパスワード
  var hashedPassword = "";

  // ユーザーに関するエラーメッセージ
  String _errorMessage = "";

  // 端末保存用のログイン中のユーザーid
  String currentUserId = "";

  // 端末保存用のログイン中のユーザー名
  String currentUsername = "";

  // パスワードが目隠しされたかどうか判定するbool値
  bool _isObscure = true;

  // SharedPrefクラスのインスタンス
  final SharedPref _sharedPref = SharedPref();

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
        _errorMessage = "Please connect with the database!";
      }
    });
  }

  // テキストボックスをクリアするメソッド
  void _clearText() {
    setState(() {
      _nameController.clear();
      _passwordController.clear();
      _errorMessage = "";
    });
  }

  // 電卓画面への遷移メソッド
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
    if (_mysql.dbConnectExec == true &&
        _nameController.text != "" &&
        _passwordController.text != "") {
      hashedPassword = Hashing.main(_passwordController.text);
      await _mysql.selectFromUserDB(_nameController.text, hashedPassword);
      // ログインできるかどうかの判定
      if (_mysql.userList.contains(_nameController.text) &&
          _mysql.userList.contains(hashedPassword)) {
        // Shared_preferenceを利用してユーザーidを端末保存
        await _sharedPref.setPrefUserData(_mysql.userList);
        currentUserId = await _sharedPref.getUserIdFromPref();
        currentUsername = await _sharedPref.getUsernameFromPref();
        _navigateNextPage();
        _clearText();
      } else {
        _getErrorMessage();
      }
    } else {
      _getErrorMessage();
    }
  }

  // ユーザー登録用のメソッド
  Future _checkRegistration() async {
    if (_mysql.dbConnectExec == true) {
      if (_nameController.text != "" && _passwordController.text != "") {
        hashedPassword = Hashing.main(_passwordController.text);
        await _mysql.insertUserDB(_nameController.text, hashedPassword);
        await _mysql.selectFromUserDB(_nameController.text, hashedPassword);
        await _sharedPref.setPrefUserData(_mysql.userList);
        // Shared_preferenceを利用してユーザーidを端末保存
        currentUserId = await _sharedPref.getUserIdFromPref();
        currentUsername = await _sharedPref.getUsernameFromPref();
        _navigateNextPage();
        _clearText();
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
    _sharedPref.setPrefInstance();
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
                  hintText: 'Enter Username',
                  hintStyle: TextStyle(fontFamily: font),
                ),
              ),
              const SizedBox(height: 12.0),
              // Passwordフィールド
              TextFormField(
                controller: _passwordController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                  hintText: 'Enter Password',
                  hintStyle: const TextStyle(fontFamily: font),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
              ),
              ButtonBar(
                children: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(primary: Colors.blueGrey[900]),
                    onPressed: () {
                      _clearText();
                    },
                    child: const Text(
                      'Clear',
                      style: TextStyle(fontFamily: font),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide.none,
                      primary: Colors.blueGrey[900],
                    ),
                    onPressed: () {
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
