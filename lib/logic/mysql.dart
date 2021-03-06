import 'dart:async';
import 'package:mysql1/mysql1.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MySQL {
  String sql = "";
  List<String> resultLists = [];
  List<String> formulaLists = [];
  List<String> userList = [];
  // ignore: prefer_typing_uninitialized_variables
  var conn;

  // dbConnectメソッドが実行されたかどうかを判断するbool値
  bool dbConnectExec = false;

  Future dbConnect() async {
    await dotenv.load();
    // Open a connection
    conn = await MySqlConnection.connect(ConnectionSettings(
      host: (dotenv.env['HOST2']).toString(),
      port: int.parse(dotenv.get('PORT')),
      user: (dotenv.env['USER']).toString(),
      db: (dotenv.env['DB']).toString(),
      password: (dotenv.env['PASSWORD']).toString(),
    ));

    dbConnectExec = true;
  }

  Future manipulateCalcDB(
      String formula, double displayedNumber, String userId) async {
    if (dbConnectExec == true) {
      if (displayedNumber != double.infinity &&
          displayedNumber.toString() != "NaN") {

        // Insert some data
        var result = await conn.query(
            'insert into calculations (formula, result, user_id) values (?, ?, ?)',
            [formula, displayedNumber.toString(), userId]);
      }
    }
  }

  Future selectFromCalcDB(String userId) async {
    if (dbConnectExec == true) {
      sql = '''
          SELECT 
            formula, result 
          FROM 
            `calculations` 
          Where
            user_id = '$userId'
          ORDER BY id DESC LIMIT 10
    ''';

     // Query the database using a parameterized query
        var results = (await conn.query(sql));
        resultLists.clear();
        formulaLists.clear();
        for (var row in results) {
          formulaLists.add('${row[0]}');
          resultLists.add('${row[1]}');
        }

    }
  }

  Future insertUserDB(String username, String password) async {
    if (dbConnectExec == true) {
      // Insert some data
      var result = await conn.query(
          'insert into users (username, password) values (?, ?)',
          [username, password]);
    }
  }

  Future selectFromUserDB(String username, String password) async {
    if (dbConnectExec == true) {
      sql = '''
          SELECT 
            * 
          FROM 
            `users` 
          Where
            username = '$username' 
          AND
            password = '$password';
      ''';

      // Query the database using a parameterized query
      var results = (await conn.query(sql));
      userList.clear();
      for (var row in results) {
        userList.add('${row[0]}');
        userList.add('${row[1]}');
        userList.add('${row[2]}');
      }
    }
  }
}
