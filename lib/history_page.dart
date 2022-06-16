import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'mysql.dart';
import 'mysql.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage(this.lists);
  List<String> lists;

  Widget HistoryArea(String text, String colon, String result) {
    return SizedBox(
      child: Row(children: <Widget>[
        Text(text),
        Text(colon),
        Text(result),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //「widget.変数名」とすることで、NextPageクラスで定義した変数を使用できる
        title: Text("計算履歴"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(children: <Widget>[
          for (int i = 0; i < lists.length; i++) ...{
            HistoryArea("計算履歴", ":", lists[i])
          }
        ]),
      ),
    );
  }
}
