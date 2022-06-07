import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class HistoryPage extends StatefulWidget {
  // インスタンス変数を定義
  final String title;

  //コンストラクタ
  HistoryPage(this.title);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //「widget.変数名」とすることで、NextPageクラスで定義した変数を使用できる
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          //Columnウィジェットはデフォルトで中央揃えのため、左揃えにする
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Containerで箱詰めすると、インデントなどを揃えやすくなる
                Container(
                  child: Text("計算履歴"),
                  width: 50,
                ),
                Container(
                  child: Text(":"),
                  width: 20,
                ),
                Text("計算履歴"),
              ],
            ),
            Padding(padding: EdgeInsets.all(10)),
            Row(
              children: [
                Container(
                  child: Text("計算履歴"),
                  width: 50,
                ),
                Container(
                  child: Text(":"),
                  width: 20,
                ),
                Text("計算履歴"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
