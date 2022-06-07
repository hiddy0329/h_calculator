import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ButtonArea extends StatefulWidget {
  const ButtonArea({Key? key}) : super(key: key);

  @override
  State<ButtonArea> createState() => _ButtonAreaState();
}

class _ButtonAreaState extends State<ButtonArea> {
  @override
  Widget build(BuildContext context) {
    // 各ボタンに表示する文字をリスト化
    List<String> buttonList = [
      "AC",
      "C",
      "%",
      "÷",
      "7",
      "8",
      "9",
      "×",
      "4",
      "5",
      "6",
      "-",
      "1",
      "2",
      "3",
      "+",
      "0",
      "00",
      ".",
      "="
    ];

    // ループ処理でボタンを表示
    List<Widget> widgetList = [];
    for (int i = 0; i < buttonList.length; i++) {
      (i == 0 ||
              i == 1 ||
              i == 2 ||
              i == 3 ||
              i == 7 ||
              i == 11 ||
              i == 15 ||
              i == 19)
          ? widgetList.add(
              RaisedButton(
                shape: const CircleBorder(
                  side: BorderSide(
                    style: BorderStyle.none,
                  ),
                ),
                color: Colors.orange,
                child: Text(
                  buttonList[i],
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                onPressed: () {
                },
              ),
            )
          : widgetList.add(
              RaisedButton(
                shape: const CircleBorder(
                  side: BorderSide(
                    style: BorderStyle.none,
                  ),
                ),
                color: Colors.grey,
                child: Text(
                  buttonList[i],
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                onPressed: () {
                  log(buttonList[i]);
                },
              ),
            );
    }
    return GridView.count(
      //crossAxisCountの数だけ横に表示してくれる
      crossAxisCount: 4,
      children: widgetList,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
    );
  }
}
