import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'history_page.dart';

// アプリを立ち上げ、MyAppクラスを呼び出す
void main() {
  runApp(const MyApp());
}

//一番最初に実行されるクラス
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // エミュレーター右上の「debug」という帯を消す
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // MyHomePageクラスを呼び出し、画面の描画に移る
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

//画面の描画をするためのクラス
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _setNumber = 0;

  // 数値を画面に表示するメソッド
  void _setNum(int num) {
    if (_setNumber < 10000000) {
      if (num == 10) {
        setState(() {
          _setNumber = _setNumber * 100;
        });
      } else {
        setState(() {
          _setNumber = _setNumber * 10 + num;
        });
      }
    }
  }

  // 画面上の数値をオールクリアするメソッド
  void _clearNum() {
    setState(() {
      _setNumber = 0;
    });
  }

  List<int> _calcElements = [];
  // 演算子入力時に値をリストに格納するメソッド
  void _setElements(int setNumber) {
    setState(() {
      _calcElements.add(_setNumber);
      _setNum(_setNumber);
      _clearNum();
    });
  }

  // 演算を実行するメソッド
  void _calculation(int setNumber) {
    setState(() {
      for (int i = 0; i < _calcElements.length; i++) {
        _setNumber += _calcElements[i];
      }
      // 次の演算に備え、クリア
      _calcElements.clear();
      // resultは出力後、初期化
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 計算履歴表示ボタンエリア
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            RaisedButton(
              child: Icon(FontAwesomeIcons.clockRotateLeft),
              color: Colors.white,
              shape: const CircleBorder(
                side: BorderSide(
                  color: Colors.black,
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
              onPressed: () {
                // 履歴表示ページへ遷移
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        //履歴ページへ値を送る
                        builder: (context) => HistoryPage("計算履歴")));
              },
            ),
          ],
        ),
      ),
      body: Container(
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            // なぜWidgetで囲む？
            children: <Widget>[
              // 計算結果表示エリア
              Expanded(
                flex: 1,
                child: Text("  "),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  // _setNumberを文字列に変換して出力
                  _setNumber.toString(),
                  style: TextStyle(
                    fontSize: 80,
                    color: Colors.white,
                  ),
                ),
              ),
              // ボタン表示エリア
              Expanded(
                flex: 6,
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: FlatButton(
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  color: Colors.red,
                                  onPressed: () {
                                    // ボタンが押されたら_clearNumメソッドを呼び出し、引数()を渡す
                                    _clearNum();
                                  },
                                  child: Text(
                                    "All Clear",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: FlatButton(
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  color: Colors.orange,
                                  onPressed: () {},
                                  child: Text(
                                    "+/-",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: FlatButton(
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  color: Colors.orange,
                                  onPressed: () {},
                                  child: Text(
                                    "%",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: FlatButton(
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  color: Colors.orange,
                                  onPressed: () {},
                                  child: Text(
                                    "÷",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: FlatButton(
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  color: Colors.grey,
                                  onPressed: () {
                                    _setNum(7);
                                  },
                                  child: Text(
                                    "7",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 50,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: FlatButton(
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  color: Colors.grey,
                                  onPressed: () {
                                    _setNum(8);
                                  },
                                  child: Text(
                                    "8",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 50,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: FlatButton(
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  color: Colors.grey,
                                  onPressed: () {
                                    _setNum(9);
                                  },
                                  child: Text(
                                    "9",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 50,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: FlatButton(
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  color: Colors.orange,
                                  onPressed: () {},
                                  child: Text(
                                    "×",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 50,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: FlatButton(
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  color: Colors.grey,
                                  onPressed: () {
                                    _setNum(4);
                                  },
                                  child: Text(
                                    "4",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 50,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: FlatButton(
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  color: Colors.grey,
                                  onPressed: () {
                                    _setNum(5);
                                  },
                                  child: Text(
                                    "5",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 50,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: FlatButton(
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  color: Colors.grey,
                                  onPressed: () {
                                    _setNum(6);
                                  },
                                  child: Text(
                                    "6",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 50,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: FlatButton(
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  color: Colors.orange,
                                  onPressed: () {},
                                  child: Text(
                                    "-",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 50,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: FlatButton(
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  color: Colors.grey,
                                  onPressed: () {
                                    _setNum(1);
                                  },
                                  child: Text(
                                    "1",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 50,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: FlatButton(
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  color: Colors.grey,
                                  onPressed: () {
                                    _setNum(2);
                                  },
                                  child: Text(
                                    "2",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 50,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: FlatButton(
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  color: Colors.grey,
                                  onPressed: () {
                                    _setNum(3);
                                  },
                                  child: Text(
                                    "3",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 50,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: FlatButton(
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  color: Colors.orange,
                                  onPressed: () {
                                    _setElements(_setNumber);
                                  },
                                  child: Text(
                                    "+",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 50,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: FlatButton(
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  color: Colors.grey,
                                  onPressed: () {
                                    _setNum(0);
                                  },
                                  child: Text(
                                    "0",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 50,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: FlatButton(
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  color: Colors.grey,
                                  onPressed: () {
                                    _setNum(10);
                                  },
                                  child: Text(
                                    "00",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 50,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: FlatButton(
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  color: Colors.grey,
                                  onPressed: () {},
                                  child: Text(
                                    ".",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 50,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 80,
                                height: 80,
                                child: FlatButton(
                                  shape: const CircleBorder(
                                    side: BorderSide(
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  color: Colors.orange,
                                  onPressed: () {
                                    _calculation(_setNumber);
                                  },
                                  child: Text(
                                    "=",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 50,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
