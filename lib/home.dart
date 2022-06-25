// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'mysql.dart';
import 'history_page.dart';
import 'dart:math' as math;

class MyHomePage extends StatefulWidget {
  final String userId;
  final String username;

  const MyHomePage({Key? key, required this.userId, required this.username})
      : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//演算子をenum値で定義
enum OperatorType { add, sub, multi, div }

class _MyHomePageState extends State<MyHomePage> {
  // ボタンの色設定
  static Color colorMain = Colors.indigo.shade100;
  static Color colorNum = Colors.blueGrey.shade900;
  static Color colorFunc = Colors.pinkAccent.shade200;
  static const Color colorText = Colors.white;

  // フォント設定
  static const String font = 'Roboto';

  // 現在値を格納する変数
  double _setCurrentNumber = 0;
  // 値を表示する変数
  double displayedNumber = 0;
  // 最初の値を保持する変数
  double _firstNum = 0;
  // 小数点ボタンが押されたかどうかを示すbool値
  bool _decimalFlag = false;
  // "."が押された後の数値の数をカウントする変数
  int _numAfterPoint = 0;
  // enum値を示す変数
  OperatorType? _operatorType;
  // 画面上部に出力するメッセージ
  String _cheeringMessage = "";
  // String型に変換したdisplayedNumber
  String displayedNumberAsString = "";
  // 画面上に表示する内容を格納する変数
  String text = "";
  // データベースに保存する計算式の部分を格納するリスト
  List<String> formula = [];

  final MySQL _mysql = MySQL(); // MySQLクラスのインスタンスを作成

  // 実際に表示する値を形成するメソッド
  String _buildDisplayedNum(double displayedNumber) {
    try {
      int intPart = _setCurrentNumber.toInt();
      displayedNumberAsString = displayedNumber.toString();
      // 単なる小数点数、もしくは小数点が押された後に「0」が押された場合（例：1.2, 3.0, 3.02）
      if (_decimalFlag && displayedNumberAsString.contains(".0")) {
        return displayedNumber.toStringAsFixed(_numAfterPoint);
      } else if (_decimalFlag ||
          _decimalFlag && _setCurrentNumber - intPart == 0.0) {
        return displayedNumberAsString;
        // 単なる整数値の時（例：12.0）
      } else if (displayedNumberAsString[displayedNumberAsString.length - 1] ==
          "0") {
        _numAfterPoint = 0;
        return displayedNumber.toInt().toString();
        // 割り算の結果が割り切れないときなどを含むその他
      } else {
        return displayedNumber.toString();
      }
    } catch (e) {
      return e.toString();
    }
  }

  // 演算に使用する数値をセットするメソッド
  void _setCurrentNum(double num) {
    // 画面に出力できる最大値
    const maxValueNumber = 100000000;
    displayedNumberAsString = displayedNumber.toString();
    // displayedNumber == _setCurrentNumber、つまり、表示値と格納値が同じならば以下の処理を行う
    if (displayedNumber == _setCurrentNumber) {
      if (displayedNumber < maxValueNumber) {
        setState(() {
          // 小数点が存在していなければ(=表示値が整数ならば)以下の処理を行う
          if (!_decimalFlag) {
            if (displayedNumber >= 0) {
              displayedNumber = displayedNumber * 10 + num;
            } else {
              displayedNumber = displayedNumber * 10 - num;
            }
          }
          // 小数点"."が押されたとき
          else {
            if (displayedNumberAsString.length < 10) {
              _numAfterPoint++;
              if (displayedNumber >= 0) {
                displayedNumber =
                    displayedNumber + num * math.pow(0.1, _numAfterPoint);
                _checkDecimal();
              } else {
                displayedNumber =
                    displayedNumber - num * math.pow(0.1, _numAfterPoint);
                _checkDecimal();
              }
            }
          }
          _setCurrentNumber = displayedNumber;
        });
      }
    }
    // 表示値と格納値が違うなら、表示値は打ち込んだ値に更新する
    else {
      setState(() {
        displayedNumber = num;
        _setCurrentNumber = displayedNumber;
        _operatorType = null;
      });
    }
  }

  // 押された演算子の種類に応じて_firstNumに_setCurrentNumberを格納するメソッド
  void _setFirstNum(OperatorType type) {
    // 演算結果を次の_firstNumにする
    if (_operatorType == null) {
      _operatorType = type;
      _setCurrentNumber = displayedNumber;
      _firstNum = _setCurrentNumber;
        switch (_operatorType) {
                  case OperatorType.add:
                    formula.add(_firstNum.toString());
                    formula.add("+");
                    break;
                  case OperatorType.sub:
                    formula.add(_firstNum.toString());
                    formula.add("-");
                    break;
                  case OperatorType.multi:
                    formula.add(_firstNum.toString());
                    formula.add("×");
                    break;
                  case OperatorType.div:
                    formula.add(_firstNum.toString());
                    formula.add("÷");
                    break;
                  default:
                    break;
                }
      _setCurrentNumber = 0;
      displayedNumber = 0;
      _decimalFlag = false;
      _numAfterPoint = 0;
      _cheeringMessage = "";
    } else if (_operatorType != null) {
      _operatorType = type;
      _setCurrentNumber = 0;
      displayedNumber = 0;
      _decimalFlag = false;
      _numAfterPoint = 0;
    }
  }

  // _operatorTypeが「add」なら足し算を実行するメソッド
  void _add() {
    setState(() {
      formula.add(_setCurrentNumber.toString());
      displayedNumber = _firstNum + _setCurrentNumber;
      _checkDecimal();
      _firstNum = displayedNumber;
      _cheeringMessage = "Nice Job!";
    });
  }

  // _operatorTypeが「sub」なら引き算を実行するメソッド
  void _sub() {
    setState(() {
      displayedNumber = _firstNum - _setCurrentNumber;
      _checkDecimal();
      _firstNum = displayedNumber;
      _cheeringMessage = "Perfect!";
    });
  }

  // _operatorTypeが「multi」なら掛け算を実行するメソッド
  void _multi() {
    setState(() {
      displayedNumber = _firstNum * _setCurrentNumber;
      _checkDecimal();
      _firstNum = displayedNumber;
      _cheeringMessage = "Excellent!";
    });
  }

  // _operatorTypeが「div」なら割り算を実行するメソッド
  void _div() {
    setState(() {
      displayedNumber = _firstNum / _setCurrentNumber;
      _checkDecimal();
      _firstNum = displayedNumber;
      if (displayedNumber == double.infinity) {
        _cheeringMessage = "Sorry, but I have no idea...";
      } else {
        _cheeringMessage = "Amazing!";
      }
    });
  }

  void _checkDecimal() {
    double checkNumber = displayedNumber;
    if (100000000 < displayedNumber ||
        displayedNumber == displayedNumber.toInt()) {
      int count;
      for (int i = 0; 100000000 < displayedNumber / math.pow(10, i); i++) {
        count = i;
        checkNumber = checkNumber / 10;
      }
      setState(() {
        displayedNumber = checkNumber;
      });
    } else {
      int count = 0;
      for (int i = 0; 1 < displayedNumber / math.pow(10, i); i++) {
        count = i;
      }
      int displayCount = 10 - count;
      displayedNumber =
          double.parse(displayedNumber.toStringAsFixed(displayCount));
    }
  }

  // 数値の符号を切り替えるメソッド
  void _invertNum() {
    setState(() {
      displayedNumber = -displayedNumber;
      _setCurrentNumber = -_setCurrentNumber;
    });
  }

  // 一の位の数値を削除していくメソッド
  void _deleteOnesPlace() {
    setState(() {
      String displayedNumberAsString = displayedNumber.toString();
      // double型を文字列に変えたため、整数も小数もデフォルトで文字数が「3」になる
      if (displayedNumberAsString.length > 3) {
        // 単なる整数値の時（例：24.0)
        if (displayedNumberAsString[displayedNumberAsString.length - 1] ==
            "0") {
          displayedNumberAsString = displayedNumberAsString.substring(
              0, displayedNumberAsString.length - 3);
        } else {
          displayedNumberAsString = displayedNumberAsString.substring(
              0, displayedNumberAsString.length - 1);
        }
        // 小数点数で、「.000~」となるときは、double型に変換すると一気に「0.0」まで戻ってしまう
        displayedNumber = double.parse(displayedNumberAsString);
        _numAfterPoint--;
        _decimalFlag = false;
      }
    });
  }

  // 画面上の数値をオールクリアするメソッド
  void _clearNum() {
    setState(() {
      _setCurrentNumber = 0;
      displayedNumber = 0;
      _firstNum = 0;
      // _operatorTypeも初期化したい
      _operatorType = null;
      _decimalFlag = false;
      _cheeringMessage = "All Clear!";
      _numAfterPoint = 0;
    });
  }

  // ボタンをウィジェット化
  Widget button(String text, Color colorButton, Color colorText) {
    return SizedBox(
      width: text == "0" ? 195 : 94,
      height: 87,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: ElevatedButton(
          onPressed: () async {
            switch (text) {
              case ".":
                _decimalFlag = true;
                break;
              case "AC":
                _clearNum();
                break;
              case "+/-":
                _invertNum();
                break;
              case "Del":
                _deleteOnesPlace();
                break;
              case "÷":
                _setFirstNum(OperatorType.div);
                break;
              case "×":
                _setFirstNum(OperatorType.multi);
                break;
              case "-":
                _setFirstNum(OperatorType.sub);
                break;
              case "+":
                _setFirstNum(OperatorType.add);
                break;
              case "=":
                // await _mysql.dbConnect();
                switch (_operatorType) {
                  case OperatorType.add:
                    _add();
                    // 計算式、計算結果、ユーザーidをデータベースへ送る
                    _mysql.manipulateCalcDB(formula, displayedNumber, widget.userId);
                    break;
                  case OperatorType.sub:
                    _sub();
                    _mysql.manipulateCalcDB(formula, displayedNumber, widget.userId);
                    break;
                  case OperatorType.multi:
                    _multi();
                    _mysql.manipulateCalcDB(formula, displayedNumber, widget.userId);
                    break;
                  case OperatorType.div:
                    _div();
                    _mysql.manipulateCalcDB(formula, displayedNumber, widget.userId);
                    break;
                  default:
                    break;
                }
                break;
              default:
                _setCurrentNum(double.parse(text));
                break;
            }
          },
          style: ElevatedButton.styleFrom(
            primary: colorButton,
            onPrimary: colorText,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Padding(
            padding: text == "0"
                ? const EdgeInsets.only(
                    left: 50.0, top: 20.0, right: 50.0, bottom: 20.0)
                : const EdgeInsets.all(8.0),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: font,
                fontWeight: FontWeight.bold,
                fontSize:
                    text == "+/-" || text == "AC" || text == "Del" ? 26 : 40,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // エミュレーター右上の「debug」という帯を消す
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: colorMain,
          // 計算履歴表示ボタンエリア
          appBar: AppBar(
            backgroundColor: colorNum,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text("<< logout",
                      style: TextStyle(
                          fontFamily: font, fontSize: 20, color: colorText)),
                  onPressed: () {
                    Navigator.pop(context, widget.userId);
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    elevation: 0,
                  ),
                  onPressed: () {},
                  child: Icon(
                    FontAwesomeIcons.database,
                    color: colorFunc,
                  ),
                ),
                Text(
                  "database on",
                  style: TextStyle(
                    fontFamily: font,
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return HistoryPage(_mysql.lists, widget.username);
                          },
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            final Offset begin = Offset(1.0, 0.0); // 右から左
                            // final Offset begin = Offset(-1.0, 0.0); // 左から右
                            const Offset end = Offset.zero;
                            final Animatable<Offset> tween =
                                Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: Curves.easeInOut));
                            final Animation<Offset> offsetAnimation =
                                animation.drive(tween);
                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Icon(FontAwesomeIcons.clockRotateLeft)),
              ],
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              // 計算結果表示エリア
              Expanded(
                flex: 1,
                child: Text(
                  _cheeringMessage,
                  style: TextStyle(
                      fontFamily: font,
                      fontSize: 34.0,
                      fontWeight: FontWeight.bold,
                      color: colorFunc),
                ),
              ),
              Expanded(
                flex: 1,
                child: FittedBox(
                  child: Text(
                    text = _buildDisplayedNum(displayedNumber),
                    style: TextStyle(
                        fontFamily: font, fontSize: 75.0, color: colorNum),
                  ),
                ),
              ),
              // ボタン表示エリア
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          button("AC", colorFunc, colorText),
                          button("+/-", colorFunc, colorText),
                          button("Del", colorFunc, colorText),
                          button("÷", colorFunc, colorText),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          button("7", colorNum, colorText),
                          button("8", colorNum, colorText),
                          button("9", colorNum, colorText),
                          button("×", colorFunc, colorText),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          button("4", colorNum, colorText),
                          button("5", colorNum, colorText),
                          button("6", colorNum, colorText),
                          button("-", colorFunc, colorText),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          button("1", colorNum, colorText),
                          button("2", colorNum, colorText),
                          button("3", colorNum, colorText),
                          button("+", colorFunc, colorText),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: <Widget>[
                          button("0", colorNum, colorText),
                          button(".", colorNum, colorText),
                          button("=", colorFunc, colorText),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<OperatorType>('_operatorType', _operatorType));
  }
}
