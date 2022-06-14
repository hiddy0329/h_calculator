import 'package:intl/intl.dart' as intl;
import 'dart:math' as Math;

//演算子をenum値で定義
enum OperatorType { add, sub, multi, div }

class Logic {
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
  String _divErrorMessage = "";
  // 画面上部に出力するメッセージ
  String _cheeringMessage = "";


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
}