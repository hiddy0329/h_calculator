import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'logic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //それぞれのボタンに応じて色を指定
  static const Color colorMain = Colors.black;
  static const Color colorNum = Colors.white10;
  static const Color colorFunc = Colors.white54;
  static const Color colorCalc = Colors.orange;
  static const Color colorText = Colors.white;

  //出力値は全て文字列として扱う
  String textResult = "0";

  static const Map<String, IconData> _mapIcon = {
    // Ios用のアイコンを文字列に割り当てるためにMappingする
    "+/-": CupertinoIcons.plus_slash_minus,
    "%": CupertinoIcons.percent,
    "/": CupertinoIcons.divide,
    "×": CupertinoIcons.multiply,
    "-": CupertinoIcons.minus,
    "+": CupertinoIcons.plus,
    "=": CupertinoIcons.equal,
  };

  // Logicクラスのインスタンスを作成
  Logic _logic = Logic();

  Widget Button(String text, Color colorButton, Color colorText) {
    return Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: ElevatedButton(
        child: Padding(
          padding: text == "0"
            ? const EdgeInsets.only(
              left: 20, top: 20, right: 120, bottom: 20)
            : text.length == 1
              ? const EdgeInsets.all(20)
              : const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
          child: _mapIcon.containsKey(text)
            ? Icon(
              _mapIcon[text],
              size: 29,
            )
            : Text(
              // ボタンの値は変数「text」に代入される
              text,
              style: const TextStyle(fontSize: 35),
            ),
        ),
        onPressed: () {
          //インスタンス化してあるので、Logicクラスのinputメソッドが使える
          _logic.input(text);
          setState(() {
            //出力値はinputメソッドによって定められた値が返される
            textResult = _logic.text;
          });
        },
        style: ElevatedButton.styleFrom(
          primary: colorButton,
          onPrimary: colorText,
          shape: text == "0" ? const StadiumBorder() : const CircleBorder(),
        ),
      ),
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorMain,
      body: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children:<Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                      //表示結果が代入されている変数
                      textResult,
                      style: const TextStyle(
                        color: colorText,
                        fontSize: 60,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                    )
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget> [
                Button("C", colorFunc, colorMain),
                Button("+/-", colorFunc, colorMain),
                Button("%", colorFunc, colorMain),
                Button("/", colorFunc, colorText),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget> [
                Button("7", colorNum, colorText),
                Button("8", colorNum, colorText),
                Button("9", colorNum, colorText),
                Button("×", colorCalc, colorText),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget> [
                Button("4", colorNum, colorText),
                Button("5", colorNum, colorText),
                Button("6", colorNum, colorText),
                Button("-", colorCalc, colorText),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget> [
                Button("1", colorNum, colorText),
                Button("2", colorNum, colorText),
                Button("3", colorNum, colorText),
                Button("+", colorCalc, colorText),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget> [
                Button("0", colorNum, colorText),
                Button(".", colorNum, colorText),
                Button("=", colorNum, colorText),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

