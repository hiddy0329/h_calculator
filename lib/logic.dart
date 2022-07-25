import 'dart:math' as math;
import 'package:h_calculator/constants.dart';
import 'package:intl/intl.dart' as intl;
import 'package:audioplayers/audioplayers.dart';

class Logic {
  String _text = "0";

  get text => _text;

  // 値を表示する変数
  double displayedNumber = 0;

  // 現在値を格納する変数
  double _setCurrentNumber = 0;

  //掛け算・割り算の結果を保持する変数
  double _temporaryNumber = 0;

  //掛け算・割り算の結果を保持する変数
  double _previousValue = 0;

  //掛け算・割り算の演算子を記録しておく変数
  String _multiDivOperator = "";

  //足し算・引き算の演算子を記録しておく変数
  String _addSubOperator = "";

  // 小数点ボタンが押されたかどうかを示すbool値
  bool _decimalFlag = false;

  // "."が押された後の数値の数をカウントする変数
  int _numAfterPoint = 0;

  //桁区切り実装用
  intl.NumberFormat formatter = intl.NumberFormat('#,###.########', 'en_US');

  // 画面上部に出力するメッセージ
  String cheeringMessage = "";

  // String型に変換したdisplayedNumber
  String displayedNumberAsString = "";

  // データベースに保存する計算式の部分を格納するリスト
  String formula = "";

  bool audioPlayed = false;

  AudioCache _cache = AudioCache(fixedPlayer: AudioPlayer());
  AudioPlayer? _player;

  //入力値をセットするメソッド
  void input(String text) {
    _text = text;
    if (_text == ".") {
      _decimalFlag = true;
      formula += '${_text}';
    } else {
      int digit = getDigit(_setCurrentNumber);

      // 整数部分と少数部分を合わせて表示桁数が9桁以上は表示させない
      if (digit + _numAfterPoint == maxDigit) {
        //処理なし
      } else if (_decimalFlag) {
        _numAfterPoint++;
        if (displayedNumber >= 0) {
          _setCurrentNumber = _setCurrentNumber +
              int.parse(_text) * math.pow(0.1, _numAfterPoint);
        } else {
          _setCurrentNumber = _setCurrentNumber -
              int.parse(_text) * math.pow(0.1, _numAfterPoint);
        }
        // 整数を入力した時、初期状態だった時
      } else if (_setCurrentNumber == 0) {
        _setCurrentNumber = double.parse(_text);
        // 連続入力対応
      } else {
        if (displayedNumber > 0) {
          _setCurrentNumber = _setCurrentNumber * 10 + double.parse(_text);
        } else {
          _setCurrentNumber = _setCurrentNumber * 10 - double.parse(_text);
        }
      }
      //最終的にgetDisplayTextメソッドに送る数値を決定
      displayedNumber = _setCurrentNumber;
      cheeringMessage = "";
      formula += _text;
    }

    if (_decimalFlag) {
      _text = getDisplayText(displayedNumber, numAfterPoint: _numAfterPoint);
    } else {
      _text = getDisplayText(displayedNumber);
    }
  }

  //画面表示用テキスト作成メソッド(小数点以下がない時は-1を取得)
  String getDisplayText(double value, {int numAfterPoint = -1}) {
    // 少数の時
    if (numAfterPoint != -1) {
      int intPart = value.toInt();
      // 初めて"."が押された時
      if (_decimalFlag == false && text.contains(".")) {
        return formatter.format(value);
      } else if (numAfterPoint == 0) {
        return "${formatter.format(value)}.";
        // "1.003などへの対応
      } else if (intPart == value) {
        //文字列の足し算のため、「333」+「0.0」は「3330.0」となってしまうのを回避する
        return formatter.format(intPart) +
            (value - intPart).toStringAsFixed(numAfterPoint).substring(1);
      }
    }
    // 単なる整数の時
    return formatter.format(value);
  }

  //桁数を取得するメソッド
  int getDigit(double value) {
    int i = 0;
    if (value > 0) {
      for (; 10 <= value; i++) {
        value = value / 10;
      }
    } else {
      for (; value <= -10; i++) {
        value = value / 10;
      }
    }
    return i + 1;
  }

  //画面上の数値をオールクリアするメソッド
  void clearNum(text) {
    _text = text;
    _text = "0";
    displayedNumber = 0;
    _setCurrentNumber = 0;
    _previousValue = 0;
    _temporaryNumber = 0;
    _multiDivOperator = "";
    _addSubOperator = "";
    _decimalFlag = false;
    cheeringMessage = "All Clear!";
    _numAfterPoint = 0;
    formula = "";
  }

  // 数値の符号を切り替えるメソッド
  void invertNum(text) {
    _text = text;
    displayedNumber = -displayedNumber;
    _setCurrentNumber = -_setCurrentNumber;

    if (_decimalFlag) {
      _text = getDisplayText(displayedNumber, numAfterPoint: _numAfterPoint);
    } else {
      _text = getDisplayText(displayedNumber);
    }
  }

  // 一の位の数値を削除していくメソッド
  void deleteOnesPlace() {
    String displayedNumberAsString = displayedNumber.toString();
    // double型を文字列に変えたため、整数も小数もデフォルトで文字数が「3」になる
    if (displayedNumberAsString.length > 3) {
      // 単なる整数値の時（例：24.0)
      if (displayedNumberAsString[displayedNumberAsString.length - 1] == "0") {
        displayedNumberAsString = displayedNumberAsString.substring(
            0, displayedNumberAsString.length - 3);
      } else {
        displayedNumberAsString = displayedNumberAsString.substring(
            0, displayedNumberAsString.length - 1);
      }
      // 小数点数で、「.000~」となるときは、double型に変換すると一気に「0.0」まで戻ってしまう
      if (displayedNumberAsString != "-") {
        displayedNumber = double.parse(displayedNumberAsString);
      }
      _numAfterPoint--;
      _decimalFlag = false;

      _text = getDisplayText(displayedNumber);
    }
  }

  // 計算結果に応じて表示するメッセージを切り替えるメソッド
  void getCheeringMessage() {
    if (_multiDivOperator == "×") {
      cheeringMessage = "Excellent!";
    } else if (displayedNumber == double.infinity ||
        displayedNumber.toString() == 'NaN') {
      cheeringMessage = "Sorry, but I have no idea...";
    } else if (_multiDivOperator == "÷") {
      cheeringMessage = "Perfect!";
    } else if (_addSubOperator == "+") {
      cheeringMessage = "Nice Job!";
    } else {
      cheeringMessage = "Awesome!";
    }
  }

  // 途中計算を行うメソッド
  void halfwayCalculation(String operatorType) {
    if (operatorType == "×" || operatorType == "÷") {
      if (_multiDivOperator == "") {
        _previousValue = _setCurrentNumber;
      } else if (_multiDivOperator == "×") {
        //直前にセットされた値と新しく入力された値を掛ける
        _previousValue = _previousValue * _setCurrentNumber;
      } else {
        _previousValue = _previousValue / _setCurrentNumber;
      }
      displayedNumber = _previousValue;
      _setCurrentNumber = 0;
      _numAfterPoint = 0;
      _decimalFlag = false;
      _multiDivOperator = operatorType;
      formula += _multiDivOperator;
      // (1 × 4 + 2 × 4 + ...)などの掛け算の結果を足し合わせていく場合に対応
    } else if (operatorType == "+" || operatorType == "-") {
      if (_multiDivOperator == "×") {
        if (operatorType == "+" && _addSubOperator == "-") {
          _temporaryNumber =
              (_temporaryNumber - (_previousValue * _setCurrentNumber)).abs();
        } else if (operatorType == "+") {
          _temporaryNumber += (_previousValue * _setCurrentNumber);
        } else if (operatorType == "-" && _addSubOperator == "+") {
          _temporaryNumber += (_previousValue * _setCurrentNumber);
        } else {
          _temporaryNumber =
              (_temporaryNumber - (_previousValue * _setCurrentNumber)).abs();
        }
        _previousValue = 0;
        _multiDivOperator = "";
      } else if (_multiDivOperator == "÷") {
        if (operatorType == "+" && _addSubOperator == "-") {
          _temporaryNumber =
              (_temporaryNumber - (_previousValue / _setCurrentNumber)).abs();
        } else if (operatorType == "+") {
          _temporaryNumber += (_previousValue / _setCurrentNumber);
        } else if (operatorType == "-" && _addSubOperator == "+") {
          _temporaryNumber += (_previousValue / _setCurrentNumber);
        } else {
          _temporaryNumber =
              (_temporaryNumber - (_previousValue / _setCurrentNumber)).abs();
        }
        _previousValue = 0;
        _multiDivOperator = "";
      } else if (_addSubOperator == "") {
        _temporaryNumber = _setCurrentNumber;
      } else if (_addSubOperator == "+") {
        _temporaryNumber = _temporaryNumber + _setCurrentNumber;
      } else if (_addSubOperator == "-") {
        _temporaryNumber = _temporaryNumber - _setCurrentNumber;
      }

      displayedNumber = _temporaryNumber;
      _setCurrentNumber = 0;
      _numAfterPoint = 0;
      _decimalFlag = false;
      _addSubOperator = operatorType;
      formula += _addSubOperator;
    }

    _text = getDisplayText(displayedNumber);
  }

  // 最終的な計算結果を求めるメソッド
  void finalCalculation() {
    if (_multiDivOperator == "×" || _multiDivOperator == "÷") {
      double result = (_multiDivOperator == "×")
          ? _previousValue * _setCurrentNumber
          : _previousValue / _setCurrentNumber;

      displayedNumber = (_addSubOperator == "-")
          ? _temporaryNumber - result
          : _temporaryNumber + result;
    } else if (_addSubOperator == "+") {
      displayedNumber = _temporaryNumber + _setCurrentNumber;
    } else {
      displayedNumber = _temporaryNumber - _setCurrentNumber;
    }
    getCheeringMessage();
    _setCurrentNumber = displayedNumber;
    _previousValue = 0;
    _temporaryNumber = 0;
    _numAfterPoint = 0;
    _decimalFlag = false;
    formula += '=';
    _text = getDisplayText(displayedNumber);
  }

  void playAudio() async{
    if (audioPlayed == false) {
      await _cache.load('test_audio.mp3');
      await _cache.play('test_audio.mp3');
      audioPlayed = true;
    } else {
      await _player?.stop();
      audioPlayed = false;
    }
  }
}
