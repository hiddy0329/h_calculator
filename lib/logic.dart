import 'package:intl/intl.dart' as intl;
import 'dart:math' as Math;

class Logic {
  String _text = "0";
  // 他のファイルからは「text」として呼び出す
  get text => _text;

  //現在の値
  double _currentNumber = 0;

  //小数点の有無
  bool _decimalFlag = false;

  //小数点以下の数
  int _numAfterPoint = 0;

  intl.NumberFormat formatter = intl.NumberFormat('#,###.########', 'en_US');

  // 入力された値を「_text」に代入
  void input(String text) {
    //現在値のセット
    if(text == ".") {
      _decimalFlag = true;
    } else {
      // 数値の入力
      if(_decimalFlag) {
        // 「整数 + "."」のパターンの時
        _numAfterPoint++;
        _currentNumber = _currentNumber + int.parse(text) * Math.pow(0.1, _numAfterPoint);
        // 「最初の0」のパターンの時
      } else if (_currentNumber == 0) {
        _currentNumber = double.parse(text);
        // 「整数 + 整数」のパターンの時
      } else {
        _currentNumber = _currentNumber * 10 + double.parse(text);
      }
    }

    //出力する文字列のセット
    if(_decimalFlag) {
      //小数点以下の値があるときは、整数値 + "."
      if(_numAfterPoint == 0) {
        _text = formatter.format(_currentNumber) + ".";
      } else {
        _text = formatter.format(_currentNumber);
      }
    } else {
      // 表示値は整数値で出力する
      _text = formatter.format(_currentNumber);
    }
  }
}