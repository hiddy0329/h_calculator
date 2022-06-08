import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'history_page.dart';
import 'dart:math' as Math; 

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

//演算子をそれぞれenum値で定義する
enum OPERATOR_TYPE {add, sub, multi, div, ini}

class _MyHomePageState extends State<MyHomePage> {
  // 値を格納する変数
  double _setNumber = 0;
  // 値を表示する変数
  double _displayedNumber = 0;
  // 最初の値を保持する変数
  double _firstNum = 0;
  bool _decimalFlag = false;

  late OPERATOR_TYPE _operatorType;

  // 数値を画面に表示するメソッド
  void _setNum(double num) {
    const _maxValueNumber = 10000000;
    // _displayedNumber == _setNumber、つまり、表示値と格納値が同じならば。
    if (_displayedNumber == _setNumber) {
      if (_displayedNumber < _maxValueNumber) {
        setState(() {
          if (!_decimalFlag) _displayedNumber = _displayedNumber * 10 + num;
          else {
            int count = 1;
            for (int i = 0;
            _displayedNumber * Math.pow(10, i) != (_displayedNumber * Math.pow(10, i)).ceil();
            i++) {
              count++;
            }
            _displayedNumber = double.parse((_displayedNumber + (num / Math.pow(10, count))).toStringAsFixed(count));
            checkDecimal();
          }
          _setNumber = _displayedNumber;
        });
      }
    // 表示値と格納値が違うなら、表示値は打ち込んだ値に更新する
    } else {
      setState(() {
        _displayedNumber = num;
        _setNumber = _displayedNumber;
        _operatorType = OPERATOR_TYPE.ini;
      });
    }
  }

  // 押された演算子の種類の応じて_firstNumに_setNumberを格納するメソッド
  void _operatorPressed(OPERATOR_TYPE type) {
    _setNumber = _displayedNumber;
    _firstNum = _setNumber;
    _setNumber = 0;
    _displayedNumber = 0;
    _operatorType = type;
    _decimalFlag = false;
  }

  // _operatorTypeが「add」なら足し算を実行するメソッド
  void _add() {
    setState(() {
      _displayedNumber =  _firstNum + _setNumber;
      _firstNum = _displayedNumber;
    });
  }

  // _operatorTypeが「sub」なら引き算を実行するメソッド
  void _sub() {
    setState(() {
      _displayedNumber = _firstNum - _setNumber; 
      _firstNum = _displayedNumber;
    });
  }

  // _operatorTypeが「multi」なら掛け算を実行するメソッド
  void _multi() {
    setState(() {
      _displayedNumber = _firstNum * _setNumber; 
      _firstNum = _displayedNumber;
    });
  }

  // _operatorTypeが「div」なら割り算を実行するメソッド
  void _div() {
    setState(() {
      _displayedNumber = _firstNum / _setNumber; 
      _firstNum = _displayedNumber;
    });
  }

  void checkDecimal() {
    double checkNum = _displayedNumber;
    if (1000000000 < _displayedNumber || _displayedNumber == _displayedNumber.toInt()) {
      int count;
      for(int i = 0; 1000000000 < _displayedNumber / Math.pow(10, i); i++) {
        count = i;
        checkNum = checkNum / 10;
      }
      setState(() {
        _displayedNumber = checkNum;
      });
    }
    else {
      int count = 0;
      for(int i = 0; 1 < _displayedNumber / Math.pow(10, i); i++) {
        count = i;
      }
      int displayCount = 10 - count;
      _displayedNumber = double.parse(_displayedNumber.toStringAsFixed(displayCount));

    }
  }

  // 画面上の数値をオールクリアするメソッド
  void _clearNum() {
    setState(() {
      _setNumber = 0;
      _displayedNumber = 0;
      _firstNum = 0;
      // _operatorTypeも初期化したい
      _operatorType = OPERATOR_TYPE.ini;
      _decimalFlag = false;
    });
  }

  // List<int> _calcElements = [];
  // // 演算子入力時に値をリストに格納するメソッド
  // void _setElements(int setNumber) {
  //   setState(() {
  //     _calcElements.add(_setNumber);
  //     _setNum(_setNumber);
  //     _clearNum();
  //   });
  // }

  // // 演算を実行するメソッド
  // void _calculation(int setNumber) {
  //   setState(() {
  //     for (int i = 0; i < _calcElements.length; i++) {
  //       _setNumber += _calcElements[i];
  //     }
  //     // 次の演算に備え、クリア
  //     _calcElements.clear();
  //     // resultは出力後、初期化
  //   });
  // }

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
                  // 表示値が整数値か小数点数かで表示方法を分岐する
                  _displayedNumber == _displayedNumber.toInt() 
                    ? _displayedNumber.toInt().toString()
                    : _displayedNumber.toString(),
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
                                  onPressed: () {
                                    _operatorPressed(OPERATOR_TYPE.div);
                                  },
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
                                  onPressed: () {
                                    _operatorPressed(OPERATOR_TYPE.multi);
                                  },
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
                                  onPressed: () {
                                    _operatorPressed(OPERATOR_TYPE.sub);
                                  },
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
                                    _operatorPressed(OPERATOR_TYPE.add);
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
                                    _decimalFlag = true;
                                  },
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
                                    switch(_operatorType) {
                                      case OPERATOR_TYPE.add:
                                        _add();
                                        break;
                                      case OPERATOR_TYPE.sub:
                                        _sub();
                                        break;
                                      case OPERATOR_TYPE.multi:
                                        _multi();
                                        break;
                                      case OPERATOR_TYPE.div:
                                        _div();
                                        break;
                                      case OPERATOR_TYPE.ini:
                                        break;
                                      default:
                                        break;
                                    }
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
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<OPERATOR_TYPE>('_operatorType', _operatorType));
  }
}
