import 'dart:async';
import 'history_page.dart';
import 'package:mysql1/mysql1.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MySQL {
  String sql = "";
  List<String> lists = [];
  List<String> userList = [];
  var conn;

  // mainメソッドが実行されたかどうかを判断するbool値
  bool dbLoadExec = false;

  Future main() async {
    await dotenv.load();
    // Open a connection (testdb should already exist)
    conn = await MySqlConnection.connect(ConnectionSettings(
      host: (dotenv.env['HOST']).toString(),
      port: int.parse(dotenv.get('PORT')),
      user: (dotenv.env['USER']).toString(),
      db: (dotenv.env['DB']).toString(),
      password: (dotenv.env['PASSWORD']).toString(),
    ));

    dbLoadExec = true;
  }

  Future manipulateCalcDB(double _displayedNumber) async {
    if (dbLoadExec == true) {
      sql = '''
          SELECT 
            result 
          FROM 
            `calculations` 
          ORDER BY id DESC LIMIT 10
    ''';

      // Insert some data
      var result = await conn.query(
          'insert into calculations (result, user_id) values (?, ?)',
          [_displayedNumber.toString(), '1']);
      // print('Inserted row id=${result.insertId}');

      // Query the database using a parameterized query
      var results = (await conn.query(sql));
      lists.clear();
      for (var row in results) {
        lists.add('${row[0]}');
      }
    }
  }

  Future manipulateUserDB(String username, String password) async {
    if (dbLoadExec == true) {
      sql = '''
          SELECT 
            * 
          FROM 
            `users` 
      ''';

      // Insert some data
      var result = await conn.query(
          'insert into users (username, password) values (?, ?)',
          [username, password]);

      // Query the database using a parameterized query
      var results = (await conn.query(sql));
      userList.clear();
      for (var row in results) {
        userList.add('${row[1]}, ${row[2]}');
      }
      print(userList);
    }
  }
}

  // // Update some data
  // await conn.query(
  //     'update Users set password=? where username=?', ['222222aaa', 'Bob']);

  // // Query again database using a parameterized query
  // var results2 = await conn.query(
  //     'select username, email, password from Users where id = ?',
  //     [result.insertId]);
  // for (var row in results2) {
  //   print('username: ${row[0]}, email: ${row[1]} password: ${row[2]}');
  // }

  // Finally, close the connection

