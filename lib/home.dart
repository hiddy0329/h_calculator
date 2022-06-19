// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'mysql.dart';
import 'history_page.dart';
import 'dart:math' as Math;
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // To load the .env file contents into dotenv.
  // NOTE: fileName defaults to .env and can be omitted in this case.
  // Ensure that the filename corresponds to the path in step 1 and 2.
  await dotenv.load(fileName: ".env");

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
        // MyHomePageクラスを呼び出し、画面の描画に移る
        home: const MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//演算子をenum値で定義
enum OperatorType { add, sub, multi, div }

class _MyHomePageState extends State<MyHomePage> {
  // ボタンの色設定
  static const Color colorMain = Colors.black;
  static const Color colorNum = Colors.white10;
  static const Color colorFunc = Colors.white54;
  static const Color colorCalc = Colors.orange;
  static const Color colorText = Colors.white;

  // 現在値を格納する変数
  double _setCurrentNumber = 0;
  // 値を表示する変数
  double _displayedNumber = 0;
  // 最初の値を保持する変数
  double _firstNum = 0;
  // 小数点ボタンが押されたかどうかを示すbool値
  bool _decimalFlag = false;
  // "."が押された後の数値の数をカウントする変数
  int _numAfterPoint = 0;
  // enum値を示す変数
  OperatorType? _operatorType;
  // 0で数値を割った場合のエラーメッセージ
  String _divErrorMessage = "";
  // 画面上部に出力するメッセージ
  String _cheeringMessage = "";
  // String型に変換した_displayedNumber
  String _displayedNumberAsString = "";

  bool _databaseButtonPressed = false;

  MySQL _mysql = MySQL(); // MySQLクラスのインスタンスを作成

  // 実際に表示する値を形成するメソッド
  String _buildDisplayedNum(double _displayedNumber, double num) {
    int intPart = _setCurrentNumber.toInt();
    String _displayedNumberAsString = _displayedNumber.toString();
    // 0で割った場合はエラーメッセージを表示
    if (_operatorType == OperatorType.div && _setCurrentNumber == 0.0) {
      return _divErrorMessage = "Sorry, but I have no idea...";
    } else if (_decimalFlag && _setCurrentNumber - intPart == 0.0) {
      return _displayedNumber.toStringAsFixed(_numAfterPoint);
    } else if (_displayedNumberAsString[_displayedNumberAsString.length - 1] !=
            "0" &&
        num == 0.0) {
      return _displayedNumber.toStringAsFixed(_numAfterPoint);
    } else if (_displayedNumber == _displayedNumber.toInt()) {
      return _displayedNumber.toInt().toString();
    } else {
      return _displayedNumber.toString();
    }
  }

  // 演算に使用する数値をセットするメソッド
  void _setCurrentNum(double num) {
    // 画面に出力できる最大値
    const maxValueNumber = 100000000;
    // _displayedNumber == _setCurrentNumber、つまり、表示値と格納値が同じならば以下の処理を行う
    if (_displayedNumber == _setCurrentNumber) {
      if (_displayedNumber < maxValueNumber) {
        setState(() {
          // 小数点が存在していなければ(=表示値が整数ならば)以下の処理を行う
          if (!_decimalFlag)
            _displayedNumber = _displayedNumber * 10 + num;
          // 小数点"."が押されたとき
          else {
            _numAfterPoint++;
            _displayedNumber =
                _displayedNumber + num * Math.pow(0.1, _numAfterPoint);
            _checkDecimal();
          }
          _setCurrentNumber = _displayedNumber;
          _divErrorMessage = "";
        });
      }
      // 表示値と格納値が違うなら、表示値は打ち込んだ値に更新する
    } else {
      setState(() {
        _displayedNumber = num;
        _setCurrentNumber = _displayedNumber;
        _operatorType = null;
        _divErrorMessage = "";
      });
    }
  }

  // 押された演算子の種類に応じて_firstNumに_setCurrentNumberを格納するメソッド
  void _setFirstNum(OperatorType type) {
    // 演算結果を次の_firstNUmにする
    _setCurrentNumber = _displayedNumber;
    _firstNum = _setCurrentNumber;
    _setCurrentNumber = 0;
    _displayedNumber = 0;
    _operatorType = type;
    _decimalFlag = false;
    _numAfterPoint = 0;
    _cheeringMessage = "";
  }

  // _operatorTypeが「add」なら足し算を実行するメソッド
  void _add() {
    setState(() {
      _displayedNumber = _firstNum + _setCurrentNumber;
      _checkDecimal();
      _firstNum = _displayedNumber;
      _cheeringMessage = "Nice Job!";
    });
  }

  // _operatorTypeが「sub」なら引き算を実行するメソッド
  void _sub() {
    setState(() {
      _displayedNumber = _firstNum - _setCurrentNumber;
      _checkDecimal();
      _firstNum = _displayedNumber;
      _cheeringMessage = "Perfect!";
    });
  }

  // _operatorTypeが「multi」なら掛け算を実行するメソッド
  void _multi() {
    setState(() {
      _displayedNumber = _firstNum * _setCurrentNumber;
      _checkDecimal();
      _firstNum = _displayedNumber;
      _cheeringMessage = "Excellent!";
    });
  }

  // _operatorTypeが「div」なら割り算を実行するメソッド
  void _div() {
    setState(() {
      _displayedNumber = _firstNum / _setCurrentNumber;
      _checkDecimal();
      _firstNum = _displayedNumber;
      if (_divErrorMessage.isNotEmpty) {
        _cheeringMessage = "Try again!";
      } else {
        _cheeringMessage = "Amazing!";
      }
    });
  }

  void _checkDecimal() {
    double checkNmber = _displayedNumber;
    if (100000000 < _displayedNumber ||
        _displayedNumber == _displayedNumber.toInt()) {
      int count;
      for (int i = 0; 100000000 < _displayedNumber / Math.pow(10, i); i++) {
        count = i;
        checkNmber = checkNmber / 10;
      }
      setState(() {
        _displayedNumber = checkNmber;
      });
    } else {
      int count = 0;
      for (int i = 0; 1 < _displayedNumber / Math.pow(10, i); i++) {
        count = i;
      }
      int displayCount = 10 - count;
      _displayedNumber =
          double.parse(_displayedNumber.toStringAsFixed(displayCount));
    }
  }

  // 数値の符号を切り替えるメソッド
  void _invertNum() {
    setState(() {
      _displayedNumber = -_displayedNumber;
      _setCurrentNumber = -_setCurrentNumber;
    });
  }

  // 一の位の数値を削除していくメソッド
  void _deleteOnesPlace() {
    setState(() {
      String _displayedNumberAsString = _displayedNumber.toString();
      // double型を文字列に変えたため、デフォルトで文字数が「3」になる
      if (_displayedNumberAsString.length > 3) {
        if (_displayedNumberAsString[_displayedNumberAsString.length - 1] ==
            "0") {
          _displayedNumberAsString = _displayedNumberAsString.substring(
              0, _displayedNumberAsString.length - 3);
        } else if (_displayedNumberAsString.contains(".0")) {
          _displayedNumberAsString = _displayedNumberAsString.substring(
              0, _displayedNumberAsString.length - 1);
        } else {
          _displayedNumberAsString = _displayedNumberAsString.substring(
              0, _displayedNumberAsString.length - 1);
        }
        _displayedNumber = double.parse(_displayedNumberAsString);
        _decimalFlag = false;
        _numAfterPoint--;
      }
    });
  }

  // 画面上の数値をオールクリアするメソッド
  void _clearNum() {
    setState(() {
      _setCurrentNumber = 0;
      _displayedNumber = 0;
      _firstNum = 0;
      // _operatorTypeも初期化したい
      _operatorType = null;
      _decimalFlag = false;
      _divErrorMessage = "";
      _cheeringMessage = "All Clear!";
      _numAfterPoint = 0;
    });
  }

  // データベースボタンの色を変えるメソッド
  void _changeDbButtonColor() {
    setState(() {
      _databaseButtonPressed = true;
    });
  }

  // ボタンをウィジェット化
  Widget Button(String text, Color colorButton, Color colorText) {
    return SizedBox(
      width: text == "0" ? 188 : 94,
      height: 80,
      child: ElevatedButton(
        child: Padding(
          padding: text == "0"
              ? const EdgeInsets.only(left: 20, top: 20, right: 50, bottom: 20)
              : const EdgeInsets.all(10),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: text == "+/-" || text == "AC" ? 30 : 35,
            ),
          ),
        ),
        onPressed: () {
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
            case "➡":
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
              switch (_operatorType) {
                case OperatorType.add:
                  _add();
                  _mysql.manipulateCalcDB(_displayedNumber);
                  break;
                case OperatorType.sub:
                  _sub();
                  _mysql.manipulateCalcDB(_displayedNumber);
                  break;
                case OperatorType.multi:
                  _multi();
                  _mysql.manipulateCalcDB(_displayedNumber);
                  break;
                case OperatorType.div:
                  _div();
                  _mysql.manipulateCalcDB(_displayedNumber);
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
          shape: text == "0" ? const StadiumBorder() : const CircleBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 計算履歴表示ボタンエリア
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: BorderSide(
                  color: Colors.black,
                  width: 1,
                  style: BorderStyle.none,
                ),
                primary: Colors.black,
              ),
              onPressed: () {
                _changeDbButtonColor();
                _mysql.main();
              },
              child: Icon(
                FontAwesomeIcons.database,
                color: (_databaseButtonPressed == true) ? colorCalc : colorText,
              ),
            ),
            Text(
              (_databaseButtonPressed == true) ? "database on" : "database off"
            ),
            ElevatedButton(
              child: Icon(FontAwesomeIcons.clockRotateLeft),
              style: ElevatedButton.styleFrom(
                side: BorderSide(
                  color: Colors.black,
                  width: 1,
                  style: BorderStyle.none,
                ),
                primary: Colors.black,
              ),
              onPressed: () {
                if (_mysql.lists.length > 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          //履歴ページへ値を送る
                          builder: (context) => HistoryPage(_mysql.lists)));
                }
              },
            ),
          ],
        ),
      ),
      body: Container(
          color: colorMain,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            // なぜWidgetで囲む？
            children: <Widget>[
              // 計算結果表示エリア
              Expanded(
                flex: 1,
                child: Text(
                  _cheeringMessage,
                  style: TextStyle(fontSize: 28, color: colorCalc),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Text(
                    (_operatorType == null)
                        ? _buildDisplayedNum(_displayedNumber, 0.0)
                        : (_operatorType != null &&
                                _displayedNumber == _displayedNumber.toInt())
                            ? _buildDisplayedNum(_displayedNumber, 0.0)
                            : _displayedNumber.toString(),
                    style: TextStyle(
                        fontSize:
                            (_divErrorMessage == "Sorry, but I have no idea...")
                                ? 33.0
                                : 73.5,
                        color:
                            (_divErrorMessage == "Sorry, but I have no idea...")
                                ? Colors.orange
                                : colorText),
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
                            Button("AC", colorFunc, colorMain),
                            Button("+/-", colorFunc, colorMain),
                            Button("➡", colorFunc, colorMain),
                            Button("÷", colorCalc, colorText),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Button("7", colorNum, colorText),
                            Button("8", colorNum, colorText),
                            Button("9", colorNum, colorText),
                            Button("×", colorCalc, colorText),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Button("4", colorNum, colorText),
                            Button("5", colorNum, colorText),
                            Button("6", colorNum, colorText),
                            Button("-", colorCalc, colorText),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Button("1", colorNum, colorText),
                            Button("2", colorNum, colorText),
                            Button("3", colorNum, colorText),
                            Button("+", colorCalc, colorText),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Button("0", colorNum, colorText),
                            Button(".", colorNum, colorText),
                            Button("=", colorNum, colorText),
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
    properties.add(EnumProperty<OperatorType>('_operatorType', _operatorType));
  }
}
