import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage(this.formulaLists, this.resultLists, this.username, {Key? key}) : super(key: key);
  final List<String> formulaLists;
  final List<String> resultLists;
  final String username;

  // フォント設定
  static const String font = 'Roboto';

  Widget historyArea(String text, String colon, String formula, String result) {
    return SizedBox(
      child: Column(
        children: [
          Row(children: <Widget>[
            Expanded(
              flex: 3,
              child: Text(
                text,
                style: const TextStyle(fontFamily: font, fontSize: 22),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                colon,
                style: const TextStyle(fontFamily: font, fontSize: 20),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                formula,
                style: const TextStyle(fontFamily: font, fontSize: 20),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  result,
                  style: const TextStyle(fontFamily: font, fontSize: 24),
                  textAlign: TextAlign.end,
                ),
              ),
            )
          ]),
          const Divider(color: Colors.blueGrey),
          const SizedBox(height: 30.0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigo[100],
        appBar: AppBar(
          title: FittedBox(
              child: Text("$username's history <DESC>",
                  style: const TextStyle(
                    fontFamily: font,
                  ))),
          backgroundColor: Colors.blueGrey[900],
        ),
        body: (formulaLists.isNotEmpty && resultLists.isNotEmpty)
            ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView.builder(
                    padding: const EdgeInsets.all(20.0),
                    shrinkWrap: true,
                    itemCount: formulaLists.length,
                    itemBuilder: (BuildContext context, int index) {
                      return historyArea(
                          "history${index + 1}", ":", formulaLists[index], resultLists[index]);
                    }),
              )
            : Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "You have no history...",
                      style: TextStyle(fontFamily: font, fontSize: 25.0),
                    ),
                    Text(
                      "Please execute calculation so that I can show your history. ",
                      style: TextStyle(fontFamily: font, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )));
  }
}
