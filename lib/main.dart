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
enum OperatorType { add, sub, multi, div }

class _MyHomePageState extends State<MyHomePage> {
  // ボタンの色設定
  static const Color colorMain = Colors.black;
  static const Color colorNum = Colors.white10;
  static const Color colorFunc = Colors.white54;
  static const Color colorCalc = Colors.orange;
  static const Color colorText = Colors.white;

  // 値を格納する変数
  double _setCurrentNumber = 0;
  // 値を表示する変数
  double _displayedNumber = 0;
  // 最初の値を保持する変数
  double _firstNum = 0;
  // 小数点ボタンが押されたかどうかを示す変数
  bool _decimalFlag = false;
  // "."が押された後の数値の数をカウントする変数
  int _numAfterPoint = 0;
  // enum値を示す変数
  OperatorType? _operatorType;
  // 0で数値を割った場合のエラーメッセージ
  String _errorMessage = "";
  // 画面上部に出力するメッセージ
  String _cheeringmessage = "";

  // 実際に表示する値を調整するメソッド
  String _buildDisplayedNumber(double _displayedNumber) {
    int intPart = _setCurrentNumber.toInt();
     // 0で割った場合はエラーメッセージを表示
    if (_operatorType == OperatorType.div && _setCurrentNumber == 0.0) {
      return _errorMessage = "Sorry, but I have no idea...";
    } else if (_decimalFlag && _setCurrentNumber - intPart == 0.0) {
      return _displayedNumber.toStringAsFixed(_numAfterPoint);
    } else if ( _displayedNumber == _displayedNumber.toInt()) {
      return _displayedNumber.toInt().toString();
    } else {
      return _displayedNumber.toString();
    }
  }

  // 数値を画面に表示するメソッド
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
            _displayedNumber = _displayedNumber + num * Math.pow(0.1, _numAfterPoint);
            _checkDecimal();
          }
          _setCurrentNumber = _displayedNumber;
        });
      }
      // 表示値と格納値が違うなら、表示値は打ち込んだ値に更新する
    } else {
      setState(() {
        _displayedNumber = num;
        _setCurrentNumber = _displayedNumber;
        _operatorType = null;
      });
    }
  }

  // 押された演算子の種類に応じて_firstNumに_setCurrentNumberを格納するメソッド
  void _operatorPressed(OperatorType type) {
    // 演算結果を次の_firstNUmにする
    _setCurrentNumber = _displayedNumber;
    _firstNum = _setCurrentNumber;
    _setCurrentNumber = 0;
    _displayedNumber = 0;
    _operatorType = type;
    _decimalFlag = false;
    _numAfterPoint = 0;
    _cheeringmessage = "";
  }

  // _operatorTypeが「add」なら足し算を実行するメソッド
  void _add() {
    setState(() {
      _displayedNumber = _firstNum + _setCurrentNumber;
      _checkDecimal();
      _firstNum = _displayedNumber;
      _cheeringmessage = "Nice Job!";
    });
  }

  // _operatorTypeが「sub」なら引き算を実行するメソッド
  void _sub() {
    setState(() {
      _displayedNumber = _firstNum - _setCurrentNumber;
      _checkDecimal();
      _firstNum = _displayedNumber;
      _cheeringmessage = "Perfect!";
    });
  }

  // _operatorTypeが「multi」なら掛け算を実行するメソッド
  void _multi() {
    setState(() {
      _displayedNumber = _firstNum * _setCurrentNumber;
      _checkDecimal();
      _firstNum = _displayedNumber;
      _cheeringmessage = "Excellent!";
    });
  }

  // _operatorTypeが「div」なら割り算を実行するメソッド
  void _div() {
    setState(() {
      _displayedNumber = _firstNum / _setCurrentNumber;
      _checkDecimal();
      _firstNum = _displayedNumber;
      if (_errorMessage == "Sorry, but I have no idea...") {
        _cheeringmessage = "Try again!";
      } else {
        _cheeringmessage = "Amazing!";
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
        checkNmber = checkNmber / 8;
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
      String _newNum = _displayedNumber.toString();
      // double型を文字列に変えたため、デフォルトで文字数が「3」になる
      if (_newNum.length > 3) {
        if (_newNum[_newNum.length - 1] == "0") {
          _newNum = _newNum.substring(0, _newNum.length - 3);
        } else if (_newNum.contains(".0")) {
          _newNum = _newNum.substring(0, _newNum.length - 1);
        } else {
          _newNum = _newNum.substring(0, _newNum.length - 1);
        }
        _displayedNumber = double.parse(_newNum);
        _decimalFlag = false;
        _numAfterPoint = 0;
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
      _errorMessage = "";
      _cheeringmessage = "All Clear!";
      _numAfterPoint = 0;
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
            case "1":
              _setCurrentNum(1);
              break;
            case "2":
              _setCurrentNum(2);
              break;
            case "3":
              _setCurrentNum(3);
              break;
            case "4":
              _setCurrentNum(4);
              break;
            case "5":
              _setCurrentNum(5);
              break;
            case "6":
              _setCurrentNum(6);
              break;
            case "7":
              _setCurrentNum(7);
              break;
            case "8":
              _setCurrentNum(8);
              break;
            case "9":
              _setCurrentNum(9);
              break;
            case "0":
              _setCurrentNum(0);
              break;
            case ".":
              _decimalFlag = true;
              break;
            case "AC":
              _clearNum();
              break;
            case "+/-":
              _invertNum();
              break;
            case "D":
              _deleteOnesPlace();
              break;
            case "÷":
              _operatorPressed(OperatorType.div);
              break;
            case "×":
              _operatorPressed(OperatorType.multi);
              break;
            case "-":
              _operatorPressed(OperatorType.sub);
              break;
            case "+":
              _operatorPressed(OperatorType.add);
              break;
            case "=":
              switch (_operatorType) {
                case OperatorType.add:
                  _add();
                  break;
                case OperatorType.sub:
                  _sub();
                  break;
                case OperatorType.multi:
                  _multi();
                  break;
                case OperatorType.div:
                  _div();
                  break;
                default:
                  break;
              }
              break;
            default:
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
          color: colorMain,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            // なぜWidgetで囲む？
            children: <Widget>[
              // 計算結果表示エリア
              Expanded(
                flex: 1,
                child: Text(
                  _cheeringmessage,
                  style: TextStyle(fontSize: 28, color: colorCalc),
                ),
              ),
              Expanded(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    _buildDisplayedNumber(_displayedNumber),
                    style: TextStyle(
                        fontSize: 32,
                        color: (_errorMessage == "Sorry, but I have no idea...")
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
                            Button("D", colorFunc, colorMain),
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
