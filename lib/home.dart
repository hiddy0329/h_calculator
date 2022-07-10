// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'logic.dart';
import 'mysql.dart';
import 'history_page.dart';

class MyHomePage extends StatefulWidget {
  final String userId;
  final String username;

  const MyHomePage({Key? key, required this.userId, required this.username})
      : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ボタンの色設定
  static Color colorMain = Colors.indigo.shade100;
  static Color colorNum = Colors.blueGrey.shade900;
  static Color colorFunc = Colors.pinkAccent.shade200;
  static const Color colorText = Colors.white;

  // フォント設定
  static const String font = 'Roboto';

  // 画面上に表示する内容を格納する変数
  String text = "";

  String txtResult = "0";

  final MySQL _mysql = MySQL(); // MySQLクラスのインスタンスを作成

  final Logic _logic = Logic(); // Logicクラスのインスタンス作成

  @override
  void initState() {
    super.initState();
    _mysql.dbConnect();
  }

  // ボタンをウィジェット化
  Widget button(String text, Color colorButton, Color colorText) {
    return SizedBox(
      width: text == "0" ? 195 : 90,
      height: 85,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              switch (text) {
                case "AC":
                  _logic.clearNum(text);
                  _logic.playAudio();
                  break;
                case "+/-":
                  _logic.invertNum(text);
                  break;
                case "Del":
                  _logic.deleteOnesPlace();
                  break;
                case "÷":
                  _logic.halfwayCalculation(text);
                  break;
                case "×":
                  _logic.halfwayCalculation(text);
                  break;
                case "-":
                  _logic.halfwayCalculation(text);
                  break;
                case "+":
                  _logic.halfwayCalculation(text);
                  break;
                case "=":
                  _logic.finalCalculation();
                  try {
                    _mysql.manipulateCalcDB(
                        _logic.formula, _logic.displayedNumber, widget.userId);
                  } catch (e) {
                    txtResult = e.toString();
                  }
                  _logic.formula = "";
                  break;
                default:
                  _logic.input(text);
                  break;
              }
              txtResult = _logic.text;
            });
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
            toolbarHeight: 77.0,
            title: FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        "${widget.username.toUpperCase()}'s calculator",
                        style: TextStyle(
                            fontFamily: font,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: colorFunc),
                      ),
                      TextButton(
                        child: Text("<< logout",
                            style: TextStyle(
                                fontFamily: font,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: colorText)),
                        onPressed: () {
                          Navigator.pop(context, widget.userId);
                        },
                      ),
                    ],
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
                      onPressed: () async {
                        if (_mysql.dbConnectExec == false) {
                          await _mysql.dbConnect();
                        }
                        await _mysql.selectFromCalcDB(widget.userId);
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return HistoryPage(_mysql.formulaLists,
                                  _mysql.resultLists, widget.username);
                            },
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              final Offset begin = Offset(1.0, 0.0); // 右から左
                              // final Offset begin = Offset(-1.0, 0.0); // 左から右
                              const Offset end = Offset.zero;
                              final Animatable<Offset> tween = Tween(
                                      begin: begin, end: end)
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
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              // 計算結果表示エリア
              Expanded(
                flex: 1,
                child: Text(
                  _logic.cheeringMessage,
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
                    txtResult,
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
}
