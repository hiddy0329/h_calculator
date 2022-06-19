import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'mysql.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage(this.lists);
  List<String> lists;

  Widget HistoryArea(String text, String colon, String result) {
    return SizedBox(
      child: Row(children: <Widget>[
        Container(
          child: Text(
            text,
            style: TextStyle(fontSize: 30),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Text(
            colon,
            style: TextStyle(fontSize: 30),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            result,
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 30),
          ),
        ),
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
        child: ListView.builder(
            padding: EdgeInsets.all(20.0),
            shrinkWrap: true,
            itemCount: lists.length,
            itemBuilder: (BuildContext context, int index) {
              return HistoryArea("計算履歴${index + 1}", ":", lists[index]);
            }),
      ),
    );
  }
}
